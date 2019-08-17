package kim.sunho.goranireader.fragments.reader

import android.util.Log
import android.webkit.JavascriptInterface
import kim.sunho.goranireader.extensions.main
import kim.sunho.goranireader.extensions.onUi
import kim.sunho.goranireader.fragments.ReaderFragment
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch


class ReaderBridgeApp(private val fragment: ReaderFragment) {
    @JavascriptInterface
    fun initComplete() {
        runOnUiThread {
            val chapter = fragment.viewModel.currentChapter() ?: return@runOnUiThread;
            fragment.bridge.start(chapter.items, fragment.viewModel.readingSentence)
        }
    }

    @JavascriptInterface
    fun loadComplete() {

    }

    @JavascriptInterface
    fun atStart() {
        runOnUiThread {
            initViewModel()
            fragment.viewModel.isStart.value = true
        }
    }

    @JavascriptInterface
    fun atMiddle() {
        runOnUiThread {
            initViewModel()
            fragment.viewModel.isStart.value = false
            fragment.viewModel.isEnd.value = false
        }
    }

    @JavascriptInterface
    fun atEnd() {
        runOnUiThread {
            initViewModel()
            fragment.viewModel.isEnd.value = true
        }
    }

    @JavascriptInterface
    fun wordSelected(i: Int, sid: String) {
        runOnUiThread {
//            fragment.viewModel.wordSelect(i, sid)
        }
    }

    @JavascriptInterface
    fun paginate(sids: Array<String>) {
        runOnUiThread {
            fragment.viewModel.paginate(sids.toList())
        }
    }

    @JavascriptInterface
    fun sentenceSelected(sid: String) {
        runOnUiThread {
            //            fragment.viewModel.sentenceSelect(sid)
        }
    }

    @JavascriptInterface
    fun readingSentenceChange(sid: String) {
        runOnUiThread {
            fragment.viewModel.readingSentence = sid
        }
    }

    private fun runOnUiThread(action: () -> Unit) {
        fragment.activity.main().runOnUiThread(action)
    }

    private fun initViewModel() {
        fragment.viewModel.initForPage()
    }
}

