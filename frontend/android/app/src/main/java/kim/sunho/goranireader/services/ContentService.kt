package kim.sunho.goranireader.services

import android.content.Context
import android.util.Log
import androidx.lifecycle.Observer
import kim.sunho.goranireader.models.Content
import java.io.File
import java.lang.IllegalStateException

object ContentService {
    private const val DIR = "books"
    private lateinit var DOWNLOAD_PATH: File
    private var downloadingMap: HashMap<Int, Content.Downloading> = HashMap()

    fun init(context: Context) {
        DOWNLOAD_PATH = context.filesDir.resolve(DIR)
        DOWNLOAD_PATH.mkdir()
    }

    fun download(bookId: Int, url: String) {
        val content = Content.Online(bookId, "asdf", url)
            .download(DOWNLOAD_PATH.path, bookId.toString() + ".epub")
        downloadingMap[bookId] = content
    }

    fun fetchContents(): List<Content> {
        for ((k, v) in downloadingMap) {
            if (v.complete.value ?: false) {
                Log.d("asdf", "Asdf")
                downloadingMap.remove(k)
            }
        }
        return (fetchLocalContents().map {
            Content.Offline(it, "asdfadfs", DOWNLOAD_PATH.resolve(it.toString() + ".epub").path)
        } + downloadingMap.map {
            it.value
        } + listOf(Content.Online(1, "Asdf", "https://www.gutenberg.org/ebooks/28885.epub.images"))).sortedBy { it.bookId }
    }

    private fun fetchLocalContents(): List<Int> {
        val files = DOWNLOAD_PATH.listFiles() ?: throw IllegalStateException("failed to list files")
        return files.flatMap {
            val res = "([0-9]+)\\.epub".toRegex().find(it.name) ?: return listOf()
            val (id) = res.destructured
            intArrayOf(id.toInt()).toList()
        }
    }
}