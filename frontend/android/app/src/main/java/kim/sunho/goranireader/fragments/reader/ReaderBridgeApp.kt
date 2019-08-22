package kim.sunho.goranireader.fragments.reader

import android.util.Log
import android.webkit.JavascriptInterface
import kim.sunho.goranireader.extensions.JsonDefault
import kim.sunho.goranireader.extensions.main
import kim.sunho.goranireader.extensions.onUi
import kim.sunho.goranireader.fragments.ReaderFragment
import kim.sunho.goranireader.models.DictSearchResult
import kim.sunho.goranireader.services.DictService
import kim.sunho.goranireader.services.EventLogService
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch


class ReaderBridgeApp(private val fragment: ReaderFragment) {
    @JavascriptInterface
    fun initComplete() {
        runOnUiThread {
            fragment.viewModel.inited = true
            val chapter = fragment.viewModel.currentChapter() ?: return@runOnUiThread
            fragment.bridge.start(chapter.items, fragment.viewModel.readingSentence)
        }
    }

    @JavascriptInterface
    fun setLoading(load: Boolean) {
        runOnUiThread {
            if (fragment.viewModel.inited) {
                fragment.viewModel.loaded = !load
                if (!load) {
                    fragment.viewModel.initForPage()
                }
            }
        }
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
            fragment.viewModel.wordSelect(i, sid)
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
            fragment.viewModel.sentenceSelect(sid)
        }
    }

    @JavascriptInterface
    fun readingSentenceChange(sid: String) {
        runOnUiThread {
            fragment.viewModel.readingSentence = sid
        }
    }

    @JavascriptInterface
    fun dictSearch(word: String): String {
        return JsonDefault().stringify(DictSearchResult.serializer(), DictSearchResult(DictService.search(word), false))
    }

    @JavascriptInterface
    fun addUnknownSentence(sid: String) {
        runOnUiThread {
            fragment.viewModel.addUnknownSentence(sid)
        }
    }

    @JavascriptInterface
    fun addUnknownWord(sid: String, wordIndex: Int, word: String, def: String) {
        runOnUiThread {
            fragment.viewModel.addUnknownWord(sid, wordIndex, word, def)
        }
    }

    private fun runOnUiThread(action: () -> Unit) {
        fragment.activity.main().runOnUiThread(action)
    }

    private fun initViewModel() {
        fragment.viewModel.initForPage()
    }
}

