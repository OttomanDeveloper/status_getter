package com.androidsaver.statusgetter

import android.content.Intent
import android.graphics.Bitmap
import android.media.MediaMetadataRetriever
import android.media.ThumbnailUtils
import android.net.Uri
import android.provider.MediaStore
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

/**
 * Main activity that hosts two [MethodChannel]s:
 *
 * 1. **Thumbnail channel** (`ottomancoder`) — generates video thumbnails from filesystem paths.
 *    Used by the legacy storage path (SDK < 30).
 *
 * 2. **SAF channel** — delegated to [SafHandler] for all Storage Access Framework operations.
 *    Used on Android 11+ (SDK >= 30) to access WhatsApp status files without
 *    MANAGE_EXTERNAL_STORAGE.
 */
class MainActivity : FlutterActivity() {

    companion object {
        private const val TAG = "MainActivity"
        private const val THUMBNAIL_CHANNEL = "com.androidsaver.statusgetter/ottomancoder"
        private const val THUMBNAIL_METHOD = "thumbnail"
    }

    private lateinit var safHandler: SafHandler

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val messenger = flutterEngine.dartExecutor.binaryMessenger

        MethodChannel(messenger, THUMBNAIL_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == THUMBNAIL_METHOD) {
                val videoPath = call.argument<String>("path")
                val quality = call.argument<Int>("quality")
                val thumbnail = getVideoThumbnail(videoPath, quality)
                    ?: generateThumbnailFallback(videoPath, quality)
                result.success(thumbnail)
            } else {
                result.notImplemented()
            }
        }

        safHandler = SafHandler(this, messenger)
        safHandler.register()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (::safHandler.isInitialized && safHandler.onActivityResult(requestCode, resultCode, data)) {
            return
        }
        super.onActivityResult(requestCode, resultCode, data)
    }

    /**
     * Extracts a video thumbnail using [MediaMetadataRetriever].
     * Takes the frame at the video's midpoint and compresses it as JPEG.
     */
    private fun getVideoThumbnail(videoPath: String?, quality: Int?): ByteArray? {
        val retriever = MediaMetadataRetriever()
        try {
            retriever.setDataSource(this, Uri.parse(videoPath))
            val durationMs = retriever.extractMetadata(
                MediaMetadataRetriever.METADATA_KEY_DURATION
            )?.toLong() ?: 0
            val bitmap = retriever.getFrameAtTime((durationMs / 2) * 1000)

            if (bitmap != null) {
                val stream = ByteArrayOutputStream()
                bitmap.compress(Bitmap.CompressFormat.JPEG, quality ?: 30, stream)
                bitmap.recycle()
                return stream.toByteArray()
            }
        } catch (e: Exception) {
            Log.w(TAG, "getVideoThumbnail failed: ${e.message}")
        } finally {
            retriever.release()
        }
        return null
    }

    /**
     * Fallback thumbnail generation using [ThumbnailUtils] for cases where
     * [MediaMetadataRetriever] fails (e.g. unsupported codec).
     */
    @Suppress("DEPRECATION")
    private fun generateThumbnailFallback(videoPath: String?, quality: Int?): ByteArray? {
        if (videoPath == null) return null
        return try {
            val bitmap = ThumbnailUtils.createVideoThumbnail(
                videoPath, MediaStore.Images.Thumbnails.MINI_KIND
            )
            if (bitmap != null) {
                val stream = ByteArrayOutputStream()
                bitmap.compress(Bitmap.CompressFormat.JPEG, quality ?: 25, stream)
                bitmap.recycle()
                stream.toByteArray()
            } else {
                null
            }
        } catch (e: Exception) {
            Log.w(TAG, "generateThumbnailFallback failed: ${e.message}")
            null
        }
    }
}
