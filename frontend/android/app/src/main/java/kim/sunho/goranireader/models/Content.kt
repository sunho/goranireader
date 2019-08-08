package kim.sunho.goranireader.models

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.downloader.Error
import com.downloader.OnDownloadListener
import com.downloader.OnProgressListener
import com.downloader.PRDownloader
import com.downloader.Progress
import com.downloader.request.DownloadRequest

sealed class Content private constructor(val bookId: Int, val img: String) {
    class Offline(bookId: Int, img: String, val path: String) : Content(bookId, img)
    class Online(bookId: Int, img: String, val url: String) : Content(bookId, img) {
        fun download(path: String, filename: String): Downloading {
            return Downloading(bookId, img, url, path, filename)
        }
    }
    class Downloading(bookId: Int, img: String, url: String, path: String, filename: String) : Content(bookId, img) {
        val progress: MutableLiveData<Long> = MutableLiveData()
        val complete: MutableLiveData<Boolean> = MutableLiveData()
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
                    //TODO
                    complete.value = true
                }
            })
        }
    }
}