package com.androidsaver.statusgetter

import android.app.Activity
import android.content.Intent
import android.graphics.Bitmap
import android.media.MediaMetadataRetriever
import android.net.Uri
import android.provider.DocumentsContract
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream

/**
 * Handles all Storage Access Framework (SAF) operations for reading WhatsApp status files
 * on Android 11+ (SDK 30+) where MANAGE_EXTERNAL_STORAGE is no longer available.
 *
 * Communicates with Dart via a dedicated [MethodChannel]. Each method maps 1:1
 * to a call from `SafService` on the Dart side.
 *
 * Lifecycle: created in [MainActivity.configureFlutterEngine], activity results
 * delegated via [MainActivity.onActivityResult].
 */
class SafHandler(private val activity: Activity, messenger: BinaryMessenger) {

    companion object {
        private const val TAG = "SafHandler"
        private const val CHANNEL_NAME = "com.androidsaver.statusgetter/saf"
        private const val REQUEST_CODE_SAF = 1001
        private const val CACHE_DIR_NAME = "statuses"
        private const val THUMBNAIL_QUALITY = 30

        /** File extensions that WhatsApp uses for status media. */
        private val STATUS_EXTENSIONS = setOf(".jpg", ".jpeg", ".png", ".mp4")
    }

    private val channel = MethodChannel(messenger, CHANNEL_NAME)
    private var pendingResult: MethodChannel.Result? = null

    /** Convenience accessor for the statuses cache directory path. */
    private val statusesCacheDir: File
        get() = File(activity.cacheDir, CACHE_DIR_NAME)

    /** Registers the [MethodChannel] handler. Call once from [MainActivity.configureFlutterEngine]. */
    fun register() {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "checkPermission" -> {
                    val path = call.argument<String>("path") ?: ""
                    checkPermission(path, result)
                }
                "requestPermission" -> {
                    val path = call.argument<String>("path") ?: ""
                    requestPermission(path, result)
                }
                "listFiles" -> {
                    val treeUri = call.argument<String>("treeUri") ?: ""
                    listFiles(treeUri, result)
                }
                "copyToCache" -> {
                    val uri = call.argument<String>("uri") ?: ""
                    val fileName = call.argument<String>("fileName") ?: ""
                    copyToCache(uri, fileName, result)
                }
                "getThumbnailFromUri" -> {
                    val uri = call.argument<String>("uri") ?: ""
                    getThumbnailFromUri(uri, result)
                }
                "releasePermission" -> {
                    val treeUri = call.argument<String>("treeUri") ?: ""
                    releasePermission(treeUri, result)
                }
                "clearCache" -> clearCache(result)
                else -> result.notImplemented()
            }
        }
    }

    /**
     * Checks whether a persisted SAF permission exists for [relativePath].
     *
     * Iterates [android.content.ContentResolver.getPersistedUriPermissions] and matches
     * against the decoded URI. Returns `{granted: true, treeUri: "..."}` or `{granted: false}`.
     */
    private fun checkPermission(relativePath: String, result: MethodChannel.Result) {
        try {
            for (perm in activity.contentResolver.persistedUriPermissions) {
                if (!perm.isReadPermission) continue
                val decodedUri = Uri.decode(perm.uri.toString())
                if (decodedUri.contains(relativePath)) {
                    result.success(mapOf("granted" to true, "treeUri" to perm.uri.toString()))
                    return
                }
            }
            result.success(mapOf("granted" to false))
        } catch (e: Exception) {
            Log.e(TAG, "checkPermission failed", e)
            result.error("CHECK_PERMISSION_ERROR", e.message, null)
        }
    }

    /**
     * Launches the system folder picker ([Intent.ACTION_OPEN_DOCUMENT_TREE]) pre-navigated
     * to [relativePath] via [DocumentsContract.EXTRA_INITIAL_URI].
     *
     * The result is delivered asynchronously through [onActivityResult].
     * Only one request can be pending at a time — [pendingResult] stores the Dart callback.
     */
    private fun requestPermission(relativePath: String, result: MethodChannel.Result) {
        try {
            pendingResult = result

            val initialUri = DocumentsContract.buildDocumentUri(
                "com.android.externalstorage.documents",
                "primary:$relativePath"
            )

            val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).apply {
                putExtra(DocumentsContract.EXTRA_INITIAL_URI, initialUri)
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                addFlags(Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
            }
            activity.startActivityForResult(intent, REQUEST_CODE_SAF)
        } catch (e: Exception) {
            Log.e(TAG, "requestPermission failed", e)
            pendingResult = null
            result.error("REQUEST_PERMISSION_ERROR", e.message, null)
        }
    }

    /**
     * Receives the folder picker result, persists the URI permission, and returns
     * the granted tree URI string to Dart (or null if cancelled).
     *
     * Called by [MainActivity.onActivityResult]. Returns `true` if this handler
     * consumed the result (matching [REQUEST_CODE_SAF]).
     */
    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != REQUEST_CODE_SAF) return false

        val result = pendingResult
        pendingResult = null
        if (result == null) return true

        if (resultCode == Activity.RESULT_OK && data?.data != null) {
            val uri = data.data!!
            try {
                activity.contentResolver.takePersistableUriPermission(
                    uri, Intent.FLAG_GRANT_READ_URI_PERMISSION
                )
                result.success(uri.toString())
            } catch (e: SecurityException) {
                Log.e(TAG, "takePersistableUriPermission failed", e)
                result.error("PERSIST_PERMISSION_ERROR", e.message, null)
            }
        } else {
            result.success(null)
        }
        return true
    }

    /**
     * Lists status files (images/videos) in the SAF-granted directory using a single
     * [android.content.ContentResolver.query] call.
     *
     * This is 10-14x faster than [androidx.documentfile.provider.DocumentFile.listFiles]
     * because it fetches all columns for all files in one IPC round-trip instead of
     * N files × M properties separate calls.
     *
     * Returns a list of maps with keys: name, uri, mimeType, size, lastModified.
     * Files are sorted newest-first by lastModified.
     */
    private fun listFiles(treeUriString: String, result: MethodChannel.Result) {
        try {
            val treeUri = Uri.parse(treeUriString)
            val docId = DocumentsContract.getTreeDocumentId(treeUri)
            val childrenUri = DocumentsContract.buildChildDocumentsUriUsingTree(treeUri, docId)

            val projection = arrayOf(
                DocumentsContract.Document.COLUMN_DOCUMENT_ID,
                DocumentsContract.Document.COLUMN_DISPLAY_NAME,
                DocumentsContract.Document.COLUMN_MIME_TYPE,
                DocumentsContract.Document.COLUMN_SIZE,
                DocumentsContract.Document.COLUMN_LAST_MODIFIED
            )

            val files = mutableListOf<Map<String, Any?>>()

            activity.contentResolver.query(
                childrenUri, projection, null, null, null
            )?.use { cursor ->
                val idIdx = cursor.getColumnIndexOrThrow(DocumentsContract.Document.COLUMN_DOCUMENT_ID)
                val nameIdx = cursor.getColumnIndexOrThrow(DocumentsContract.Document.COLUMN_DISPLAY_NAME)
                val mimeIdx = cursor.getColumnIndexOrThrow(DocumentsContract.Document.COLUMN_MIME_TYPE)
                val sizeIdx = cursor.getColumnIndexOrThrow(DocumentsContract.Document.COLUMN_SIZE)
                val modifiedIdx = cursor.getColumnIndexOrThrow(DocumentsContract.Document.COLUMN_LAST_MODIFIED)

                while (cursor.moveToNext()) {
                    val name = cursor.getString(nameIdx) ?: continue
                    if (!isStatusFile(name)) continue

                    val documentUri = DocumentsContract.buildDocumentUriUsingTree(
                        treeUri, cursor.getString(idIdx)
                    )

                    files.add(mapOf(
                        "name" to name,
                        "uri" to documentUri.toString(),
                        "mimeType" to (cursor.getString(mimeIdx) ?: ""),
                        "size" to cursor.getLong(sizeIdx),
                        "lastModified" to cursor.getLong(modifiedIdx)
                    ))
                }
            }

            files.sortByDescending { it["lastModified"] as? Long ?: 0L }
            result.success(files)
        } catch (e: Exception) {
            Log.e(TAG, "listFiles failed", e)
            result.error("LIST_FILES_ERROR", e.message, null)
        }
    }

    /**
     * Copies a single file from a SAF [content://] URI to the app's cache directory.
     *
     * Skips the copy if the file is already cached (same filename).
     * Returns the absolute path of the cached file so Dart's [File] class can read it.
     */
    private fun copyToCache(uriString: String, fileName: String, result: MethodChannel.Result) {
        try {
            val cacheDir = statusesCacheDir
            if (!cacheDir.exists()) cacheDir.mkdirs()

            val safeName = sanitizeFileName(fileName)
            val destFile = File(cacheDir, safeName)

            if (destFile.exists()) {
                result.success(destFile.absolutePath)
                return
            }

            val sourceUri = Uri.parse(uriString)
            activity.contentResolver.openInputStream(sourceUri)?.use { input ->
                FileOutputStream(destFile).use { output ->
                    input.copyTo(output)
                }
            } ?: throw IllegalStateException("Cannot open input stream for $uriString")

            result.success(destFile.absolutePath)
        } catch (e: Exception) {
            Log.e(TAG, "copyToCache failed for $fileName", e)
            result.error("COPY_TO_CACHE_ERROR", e.message, null)
        }
    }

    /**
     * Generates a JPEG thumbnail from a video at a SAF [content://] URI.
     *
     * Extracts the frame at the video's midpoint using [MediaMetadataRetriever],
     * which natively supports content URIs. Returns the compressed bytes directly —
     * no file copy needed for thumbnails.
     */
    private fun getThumbnailFromUri(uriString: String, result: MethodChannel.Result) {
        val retriever = MediaMetadataRetriever()
        try {
            retriever.setDataSource(activity, Uri.parse(uriString))

            val durationMs = retriever.extractMetadata(
                MediaMetadataRetriever.METADATA_KEY_DURATION
            )?.toLong() ?: 0

            val bitmap = retriever.getFrameAtTime((durationMs / 2) * 1000)
            if (bitmap != null) {
                val stream = ByteArrayOutputStream()
                bitmap.compress(Bitmap.CompressFormat.JPEG, THUMBNAIL_QUALITY, stream)
                bitmap.recycle()
                result.success(stream.toByteArray())
            } else {
                result.success(null)
            }
        } catch (e: Exception) {
            Log.w(TAG, "getThumbnailFromUri failed for $uriString", e)
            result.success(null)
        } finally {
            retriever.release()
        }
    }

    /** Revokes a previously persisted SAF read permission for the given tree URI. */
    private fun releasePermission(treeUriString: String, result: MethodChannel.Result) {
        try {
            activity.contentResolver.releasePersistableUriPermission(
                Uri.parse(treeUriString), Intent.FLAG_GRANT_READ_URI_PERMISSION
            )
            result.success(true)
        } catch (e: Exception) {
            Log.e(TAG, "releasePermission failed", e)
            result.error("RELEASE_PERMISSION_ERROR", e.message, null)
        }
    }

    /** Deletes all cached status files. Called at the start of each fetch cycle. */
    private fun clearCache(result: MethodChannel.Result) {
        try {
            val cacheDir = statusesCacheDir
            if (cacheDir.exists()) cacheDir.deleteRecursively()
            result.success(true)
        } catch (e: Exception) {
            Log.e(TAG, "clearCache failed", e)
            result.error("CLEAR_CACHE_ERROR", e.message, null)
        }
    }

    /** Returns true if [fileName] has an extension matching a WhatsApp status media type. */
    private fun isStatusFile(fileName: String): Boolean {
        val lower = fileName.lowercase()
        return STATUS_EXTENSIONS.any { lower.endsWith(it) }
    }

    /** Strips characters that are illegal in Android filenames. */
    private fun sanitizeFileName(name: String): String {
        return name.replace(Regex("[/\\\\:*?\"<>|]"), "_")
    }
}
