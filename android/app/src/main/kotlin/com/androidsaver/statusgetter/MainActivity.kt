package com.androidsaver.statusgetter

import android.graphics.Bitmap
import android.media.MediaMetadataRetriever
import android.media.ThumbnailUtils
import android.net.Uri
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class MainActivity : FlutterActivity() {

    /// Thumbnail Getter `MethodChannel` Name
    private val channelId: String = "com.androidsaver.statusgetter/ottomancoder";

    ///  Thumbnail Method ID
    private val methodId: String = "thumbnail";

    /// Initialize Flutter Engine and Set Method Handler
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, channelId
        ).setMethodCallHandler { call, result ->
            if (call.method == methodId) {
                val videoPath: String? = call.argument<String>("path");
                val quality: Int? = call.argument("quality");
                var thumbnail: ByteArray? = getVideoThumbnail(videoPath, quality);
                // Check if the thumbnail is null then try to get it from second method.
                if (thumbnail == null) {
                    thumbnail = generateThumbnail(videoPath, quality);
                }
                result.success(thumbnail);
            } else {
                result.notImplemented();
            }
        }
    }

    /// Generate Video Thumbnail Using `MediaMetadataRetriever`
    private fun getVideoThumbnail(videoPath: String?, quality: Int?): ByteArray? {
        val retriever: MediaMetadataRetriever = MediaMetadataRetriever()

        try {
            println("getVideoThumbnail File Received: $videoPath")
            // Set the data source to the video path
            retriever.setDataSource(this, Uri.parse(videoPath))
            println("getVideoThumbnail File Source is Set")
            // Get the duration of the video in microseconds
            val durationUs: Long =
                retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)?.toLong()
                    ?: 0
            println("getVideoThumbnail Got File Duration: $durationUs")
            // Calculate the timestamp for the midpoint (adjust this based on your requirements)
            val timeUs: Long = durationUs / 2
            println("getVideoThumbnail Got Thumbnail Duration: $timeUs")
            // Get the frame at the calculated timestamp
            val bitmap: Bitmap? = retriever.getFrameAtTime(timeUs * 1000)
            println("getVideoThumbnail Got Bitmap")
            val stream: ByteArrayOutputStream = ByteArrayOutputStream();
            println("getVideoThumbnail File Compress Starting")
            bitmap?.compress(Bitmap.CompressFormat.JPEG, quality ?: 30, stream)
            println("getVideoThumbnail File Compress Completed")
            return stream.toByteArray()
        } catch (e: Exception) {
            println("getVideoThumbnail Error: ${e.message}")
            e.printStackTrace()
        } finally {
            println("getVideoThumbnail Released")
            retriever.release()
        }

        return null
    }

    /// Generate Video Thumbnail Using `ThumbnailUtils`
    private fun generateThumbnail(videoPath: String?, quality: Int?): ByteArray? {

        return try {
            println("generateThumbnail File Received: $videoPath")
            val bitmap: Bitmap? = ThumbnailUtils.createVideoThumbnail(
                videoPath!!, MediaStore.Images.Thumbnails.MINI_KIND
            )
            println("generateThumbnail Got Video Bitmap")
            val stream: ByteArrayOutputStream = ByteArrayOutputStream()
            println("generateThumbnail Starting Compress Function")
            bitmap?.compress(Bitmap.CompressFormat.JPEG, quality ?: 25, stream)
            println("generateThumbnail Completed Compress Function")
            stream.toByteArray()
        } catch (e: Exception) {
            println("generateThumbnail Error: ${e.message}")
            e.printStackTrace()
            null
        }

    }


}
