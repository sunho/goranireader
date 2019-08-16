package kim.sunho.goranireader.services

import android.content.Context
import android.util.Log
import androidx.lifecycle.Observer
import kim.sunho.goranireader.extensions.JsonDefault
import kim.sunho.goranireader.models.BookyBook
import kim.sunho.goranireader.models.Content
import java.io.File
import java.lang.IllegalStateException

object ContentService {
    private const val DIR = "books"
    private lateinit var DOWNLOAD_PATH: File
    private var downloadingMap: HashMap<String, Content.Downloading> = HashMap()

    fun init(context: Context) {
        DOWNLOAD_PATH = context.filesDir.resolve(DIR)
        DOWNLOAD_PATH.mkdir()
    }

    fun download(content: Content.Online) {
        val new = content.download(DOWNLOAD_PATH.path, content.bookId+".book")
        downloadingMap[content.bookId] = new
    }

    fun fetchContents(): List<Content> {
        for ((k, v) in downloadingMap) {
            if (v.complete.value ?: false) {
                downloadingMap.remove(k)
            }
        }
        return (fetchLocalContents().map {
            Content.Offline(it, "asdfadfs", "asdf,", "asdf", it + ".book")
        } + downloadingMap.map {
            it.value
        })
    }

    private fun fetchLocalContents(): List<String> {
        val files = DOWNLOAD_PATH.listFiles() ?: throw IllegalStateException("failed to list files")
        return files.flatMap {
            Log.d("asdfa", it.path)
            val res = "([^.]+)\\.book$".toRegex().find(it.name) ?: return@flatMap listOf<String>()
            val (id) = res.destructured
            listOf(id)
        }
    }

    fun readBook(fileName: String): BookyBook {
        val buf = DOWNLOAD_PATH.resolve(fileName).readText()
        return JsonDefault().parse(BookyBook.serializer(), buf)
    }
}