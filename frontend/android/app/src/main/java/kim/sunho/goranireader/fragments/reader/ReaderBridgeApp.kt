package kim.sunho.goranireader.fragments.reader

import android.webkit.JavascriptInterface
import kim.sunho.goranireader.fragments.ReaderFragment
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch


class ReaderBridgeApp(private val fragment: ReaderFragment) {
    private val job = SupervisorJob()
    private val scope = CoroutineScope(Dispatchers.Main + job)

    @JavascriptInterface
    fun initComplete() {
        scope.launch {
            val book  = fragment.viewModel.book!!
            fragment.bridge.start(book.chapters[fragment.viewModel.readingChapter].items, "")
        }
    }

    @JavascriptInterface
    fun loadComplete() {

    }

    @JavascriptInterface
    fun atStart() {

    }

    @JavascriptInterface
    fun atMiddle() {

    }

    @JavascriptInterface
    fun atEnd() {

    }

    @JavascriptInterface
    fun wordSelected(i: Int, sid: String) {

    }

    @JavascriptInterface
    fun paginate(sids: List<String>) {

    }

    @JavascriptInterface
    fun sentenceSelected(sid: String) {

    }
}

