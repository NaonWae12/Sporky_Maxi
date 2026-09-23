package com.sporky.maxi.app

import android.content.ActivityNotFoundException
import android.content.ContentValues
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    private val shareChannel = "sporky_maxi/share_moment"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, shareChannel).setMethodCallHandler { call, result ->
            when (call.method) {
                "shareImage" -> {
                    val path = call.argument<String>("path")
                    val target = call.argument<String>("target")
                    val text = call.argument<String>("text") ?: ""

                    if (path.isNullOrBlank() || target.isNullOrBlank()) {
                        result.error("INVALID_ARGS", "Image path and target are required.", null)
                        return@setMethodCallHandler
                    }

                    try {
                        shareImage(path, target, text)
                        result.success(null)
                    } catch (_: ActivityNotFoundException) {
                        result.error("APP_NOT_FOUND", "Target app is not installed.", null)
                    } catch (error: Exception) {
                        result.error("SHARE_FAILED", error.message, null)
                    }
                }
                "saveToGallery" -> {
                    val path = call.argument<String>("path")
                    if (path.isNullOrBlank()) {
                        result.error("INVALID_ARGS", "Image path is required.", null)
                        return@setMethodCallHandler
                    }

                    try {
                        saveImageToGallery(path)
                        result.success(null)
                    } catch (error: Exception) {
                        result.error("SAVE_FAILED", error.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun shareImage(path: String, target: String, text: String) {
        val imageFile = File(path)
        if (!imageFile.exists()) throw IllegalArgumentException("Image file does not exist.")

        val uri = FileProvider.getUriForFile(
            this,
            "${applicationContext.packageName}.share_file_provider",
            imageFile,
        )
        val packages = when (target) {
            "whatsapp" -> listOf("com.whatsapp", "com.whatsapp.w4b")
            "instagram" -> listOf("com.instagram.android")
            else -> emptyList()
        }

        var lastError: ActivityNotFoundException? = null
        for (packageName in packages) {
            val intent = Intent(Intent.ACTION_SEND).apply {
                type = "image/*"
                setPackage(packageName)
                putExtra(Intent.EXTRA_STREAM, uri)
                putExtra(Intent.EXTRA_TEXT, text)
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }

            try {
                startActivity(intent)
                return
            } catch (error: ActivityNotFoundException) {
                lastError = error
            }
        }

        throw lastError ?: ActivityNotFoundException()
    }

    private fun saveImageToGallery(path: String) {
        val source = File(path)
        if (!source.exists()) throw IllegalArgumentException("Image file does not exist.")

        val fileName = "sporky_maxi_${System.currentTimeMillis()}.jpg"
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val values = ContentValues().apply {
                put(MediaStore.Images.Media.DISPLAY_NAME, fileName)
                put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg")
                put(MediaStore.Images.Media.RELATIVE_PATH, "${Environment.DIRECTORY_PICTURES}/Sporky Maxi")
                put(MediaStore.Images.Media.IS_PENDING, 1)
            }

            val resolver = applicationContext.contentResolver
            val uri = resolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)
                ?: throw IllegalStateException("Cannot create gallery item.")

            resolver.openOutputStream(uri)?.use { output ->
                FileInputStream(source).use { input -> input.copyTo(output) }
            } ?: throw IllegalStateException("Cannot open gallery item.")

            values.clear()
            values.put(MediaStore.Images.Media.IS_PENDING, 0)
            resolver.update(uri, values, null, null)
            return
        }

        val directory = File(
            Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES),
            "Sporky Maxi",
        )
        if (!directory.exists()) directory.mkdirs()

        val destination = File(directory, fileName)
        FileInputStream(source).use { input ->
            FileOutputStream(destination).use { output -> input.copyTo(output) }
        }
        sendBroadcast(Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.fromFile(destination)))
    }
}
