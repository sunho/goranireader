package kim.sunho.goranireader.models

import android.util.Log
import android.view.View
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.downloader.Error
import com.downloader.OnDownloadListener
import com.downloader.OnProgressListener
import com.downloader.PRDownloader
import com.downloader.Progress
import com.downloader.request.DownloadRequest

sealed class Content constructor(val bookId: String, val img: String?, val title: String, val author: String) {
    class Offline(bookId: String, img: String?, title: String, author: String, val path: String) : Content(bookId, img, title, author)
    class Online(bookId: String, img: String?, title: String, author: String, val url: String) : Content(bookId, img, title, author) {
        fun download(path: String, filename: String): Downloading {
            return Downloading(bookId, img,title, author, url, path, filename)
        }
    }
    class Downloading(bookId: String, img: String?, title: String, author: String, url: String, path: String, filename: String) : Content(bookId, img, title, author) {
        val progress: MutableLiveData<Long> = MutableLiveData()
        val complete: MutableLiveData<Boolean> = MutableLiveData()
        var currentError: Error? = null
        init {
            val request = PRDownloader.download(url, path, filename).build()
            request.onProgressListener = OnProgressListener { progress2 ->
                progress.value = progress2.currentBytes * 100 / progress2.totalBytes
            }
            request.start(object: OnDownloadListener {
                override fun onDownloadComplete() {
                    complete.value = true
                }

                override fun onError(error: Error?) {
                    currentError = error
                    complete.value = true
                }
            })
        }
    }
    fun isOnline(): Int {
        if (this is Online) {
            return View.VISIBLE
        }
        return View.GONE
    }
}