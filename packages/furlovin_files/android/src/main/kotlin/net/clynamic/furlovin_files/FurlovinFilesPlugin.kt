package net.clynamic.furlovin_files

import android.annotation.TargetApi
import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.ContentResolver
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.os.Handler
import android.os.Looper
import android.provider.DocumentsContract
import android.provider.MediaStore
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.io.File
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

private const val PICK_FOLDER = 0x6675

private val playlistTypes = setOf("audio/x-mpegurl", "audio/mpegurl", "audio/x-scpls")

private fun partialName(name: String): String {
    val dot = name.lastIndexOf('.')
    return if (dot > 0) "${name.substring(0, dot)}.partial${name.substring(dot)}" else "$name.partial"
}

class FurlovinFilesPlugin :
    FlutterPlugin,
    ActivityAware,
    MethodChannel.MethodCallHandler,
    PluginRegistry.ActivityResultListener {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var activity: ActivityPluginBinding? = null
    private var picking: MethodChannel.Result? = null
    private val worker: ExecutorService = Executors.newSingleThreadExecutor()
    private val main = Handler(Looper.getMainLooper())

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "furlovin_files")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        worker.shutdown()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() = onDetachedFromActivity()

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) =
        onAttachedToActivity(binding)

    override fun onDetachedFromActivity() {
        activity?.removeActivityResultListener(this)
        activity = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "sharesMedia" -> result.success(Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q)
            "saveToMedia" -> {
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
                    result.error("unsupported", "Shared media folders need Android 10", null)
                    return
                }
                val source = call.argument<String>("source")!!
                val name = call.argument<String>("name")!!
                val mime = call.argument<String>("mime")!!
                val folder = call.argument<String>("folder")!!
                work(result) { saveToMedia(File(source), name, mime, folder) }
            }
            "pickFolder" -> pickFolder(call.argument<String>("initial"), result)
            "canWrite" -> {
                val folder = call.argument<String>("folder")!!
                work(result) { canWrite(Uri.parse(folder)) }
            }
            "writeToFolder" -> {
                val folder = call.argument<String>("folder")!!
                val source = call.argument<String>("source")!!
                val name = call.argument<String>("name")!!
                val mime = call.argument<String>("mime")!!
                work(result) {
                    writeToFolder(Uri.parse(folder), File(source), name, mime)
                    null
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun work(result: MethodChannel.Result, task: () -> Any?) {
        worker.execute {
            try {
                val value = task()
                main.post { result.success(value) }
            } catch (error: Exception) {
                main.post { result.error("failed", error.message, null) }
            }
        }
    }

    @TargetApi(Build.VERSION_CODES.Q)
    private fun saveToMedia(source: File, name: String, mime: String, folder: String): String {
        val volume = MediaStore.VOLUME_EXTERNAL_PRIMARY
        val (collection: Uri, root: String) = when {
            mime.startsWith("image/") ->
                MediaStore.Images.Media.getContentUri(volume) to Environment.DIRECTORY_PICTURES
            mime.startsWith("audio/") && mime !in playlistTypes ->
                MediaStore.Audio.Media.getContentUri(volume) to Environment.DIRECTORY_MUSIC
            mime.startsWith("video/") ->
                MediaStore.Video.Media.getContentUri(volume) to Environment.DIRECTORY_MOVIES
            else ->
                MediaStore.Downloads.getContentUri(volume) to Environment.DIRECTORY_DOWNLOADS
        }
        val path = "$root/$folder"
        val resolver = context.contentResolver
        val existing = findMedia(resolver, collection, "$path/", name)
        val values = ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, partialName(name))
            put(MediaStore.MediaColumns.MIME_TYPE, mime)
            put(MediaStore.MediaColumns.RELATIVE_PATH, path)
            put(MediaStore.MediaColumns.IS_PENDING, 1)
        }
        val uri = resolver.insert(collection, values)
            ?: throw IllegalStateException("The media store refused $name")
        try {
            copy(resolver, source, uri)
            if (existing != null) resolver.delete(existing, null, null)
            values.clear()
            values.put(MediaStore.MediaColumns.DISPLAY_NAME, name)
            values.put(MediaStore.MediaColumns.IS_PENDING, 0)
            if (resolver.update(uri, values, null, null) == 0) {
                throw IllegalStateException("The media store did not publish $name")
            }
        } catch (error: Exception) {
            runCatching { resolver.delete(uri, null, null) }
            throw error
        }
        return path
    }

    private fun findMedia(resolver: ContentResolver, collection: Uri, path: String, name: String): Uri? {
        val columns = arrayOf(MediaStore.MediaColumns._ID)
        val selection =
            "${MediaStore.MediaColumns.RELATIVE_PATH} = ? AND ${MediaStore.MediaColumns.DISPLAY_NAME} = ?"
        resolver.query(collection, columns, selection, arrayOf(path, name), null)?.use { cursor ->
            if (cursor.moveToFirst()) {
                return Uri.withAppendedPath(collection, cursor.getLong(0).toString())
            }
        }
        return null
    }

    private fun pickFolder(initial: String?, result: MethodChannel.Result) {
        val host: Activity = activity?.activity
            ?: return result.error("no_activity", "No activity to pick a folder from", null)
        if (picking != null) {
            result.error("busy", "A folder is already being picked", null)
            return
        }
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE)
        if (initial != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            runCatching {
                val tree = Uri.parse(initial)
                DocumentsContract.buildDocumentUriUsingTree(
                    tree,
                    DocumentsContract.getTreeDocumentId(tree),
                )
            }.getOrNull()?.let { intent.putExtra(DocumentsContract.EXTRA_INITIAL_URI, it) }
        }
        picking = result
        try {
            host.startActivityForResult(intent, PICK_FOLDER)
        } catch (error: ActivityNotFoundException) {
            picking = null
            result.error("no_picker", "This device has no folder picker", null)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != PICK_FOLDER) return false
        val result = picking ?: return true
        picking = null
        val folder = data?.data
        if (resultCode != Activity.RESULT_OK || folder == null) {
            result.success(null)
            return true
        }
        val access = Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
        try {
            val resolver = context.contentResolver
            resolver.takePersistableUriPermission(folder, access)
            for (grant in resolver.persistedUriPermissions) {
                if (grant.uri != folder) {
                    runCatching { resolver.releasePersistableUriPermission(grant.uri, access) }
                }
            }
            result.success(folder.toString())
        } catch (error: SecurityException) {
            result.error("no_access", "The picked folder cannot be kept", null)
        }
        return true
    }

    private fun canWrite(folder: Uri): Boolean {
        val resolver = context.contentResolver
        val granted = resolver.persistedUriPermissions.any {
            it.uri == folder && it.isWritePermission
        }
        if (!granted) return false
        return runCatching {
            val root = DocumentsContract.buildDocumentUriUsingTree(
                folder,
                DocumentsContract.getTreeDocumentId(folder),
            )
            val columns = arrayOf(DocumentsContract.Document.COLUMN_MIME_TYPE)
            resolver.query(root, columns, null, null, null)?.use { cursor ->
                cursor.moveToFirst() &&
                    cursor.getString(0) == DocumentsContract.Document.MIME_TYPE_DIR
            } ?: false
        }.getOrDefault(false)
    }

    private fun writeToFolder(folder: Uri, source: File, name: String, mime: String) {
        val resolver = context.contentResolver
        val parent = DocumentsContract.buildDocumentUriUsingTree(
            folder,
            DocumentsContract.getTreeDocumentId(folder),
        )
        val partial = DocumentsContract.createDocument(resolver, parent, mime, partialName(name))
            ?: throw IllegalStateException("The folder refused $name")
        try {
            copy(resolver, source, partial)
            findChild(resolver, folder, name)?.let {
                DocumentsContract.deleteDocument(resolver, it)
            }
            DocumentsContract.renameDocument(resolver, partial, name)
                ?: throw IllegalStateException("The folder did not rename $name")
        } catch (error: Exception) {
            runCatching { DocumentsContract.deleteDocument(resolver, partial) }
            throw error
        }
    }

    private fun findChild(resolver: ContentResolver, folder: Uri, name: String): Uri? {
        val children = DocumentsContract.buildChildDocumentsUriUsingTree(
            folder,
            DocumentsContract.getTreeDocumentId(folder),
        )
        val columns = arrayOf(
            DocumentsContract.Document.COLUMN_DOCUMENT_ID,
            DocumentsContract.Document.COLUMN_DISPLAY_NAME,
            DocumentsContract.Document.COLUMN_MIME_TYPE,
        )
        resolver.query(children, columns, null, null, null)?.use { cursor ->
            while (cursor.moveToNext()) {
                if (cursor.getString(2) == DocumentsContract.Document.MIME_TYPE_DIR) continue
                if (cursor.getString(1).equals(name, ignoreCase = true)) {
                    return DocumentsContract.buildDocumentUriUsingTree(folder, cursor.getString(0))
                }
            }
        }
        return null
    }

    private fun copy(resolver: ContentResolver, source: File, target: Uri) {
        val output = resolver.openOutputStream(target, "wt")
            ?: throw IllegalStateException("No stream to write $target")
        output.use { sink -> source.inputStream().use { it.copyTo(sink) } }
    }
}
