package kim.sunho.goranireader.fragments.reader

import android.util.EventLog
import android.util.Log
import android.webkit.JavascriptInterface
import io.realm.Realm
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
            Log.d("adsf", "initComplete")
            fragment.viewModel.inited = true
            fragment.start()
        }
    }

    @JavascriptInterface
    fun setLoading(load: Boolean) {
        runOnUiThread {
            Log.d("adsf", "setLoading $load")
            if (fragment.viewModel.inited) {
                fragment.viewModel.loaded = !load
                if (!load) {
                    fragment.viewModel.initForChapter()
                }
            }
        }
    }

    @JavascriptInterface
    fun atStart() {
        runOnUiThread {
            fragment.viewModel.isStart.value = true
        }
    }

    @JavascriptInterface
    fun atMiddle() {
        runOnUiThread {
            fragment.viewModel.isStart.value = false
            fragment.viewModel.isEnd.value = false
        }
    }

    @JavascriptInterface
    fun atEnd() {
        runOnUiThread {
            fragment.viewModel.isEnd.value = true
        }
    }

    @JavascriptInterface
    fun wordSelected(word: String, i: Int, sid: String) {
        runOnUiThread {
            fragment.viewModel.wordSelect(word, i, sid)
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
    }

    @JavascriptInterface
    fun readingSentenceChange(sid: String) {
        runOnUiThread {
            Log.d("adsf", "setReadingQuestion $sid")
            fragment.viewModel.initForPage()
            fragment.viewModel.readingSentence = sid
            fragment.viewModel.updateProgress()
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
    }

    @JavascriptInterface
    fun submitQuestion(qid: String, option: String, right: Boolean) {
        runOnUiThread {
            fragment.viewModel.submitQuestion(qid, option, right)
        }
    }

    @JavascriptInterface
    fun setReadingQuestion(qid: String) {
        runOnUiThread {
            Log.d("adsf", "setReadingQuestion $qid")
            fragment.viewModel.initForPage()
            fragment.viewModel.readingQuestion = qid
            fragment.viewModel.updateProgress()
        }
    }

    @JavascriptInterface
    fun endQuiz() {
        runOnUiThread {
            fragment.viewModel.solvedChapters.add(fragment.viewModel.currentChapter()!!.id)
            fragment.viewModel.updateProgress()
            fragment.viewModel.next()
        }

    }

    private fun runOnUiThread(action: () -> Unit) {
        fragment.activity.main().runOnUiThread(action)
    }
}

