package kim.sunho.goranireader.fragments.reader

import android.util.Log
import android.webkit.JavascriptInterface
import android.webkit.WebView
import kim.sunho.goranireader.extensions.JsonDefault
import kim.sunho.goranireader.models.Question
import kim.sunho.goranireader.models.Sentence
import kotlinx.serialization.list

class Bridge(private val webView: WebView) {
    fun startReader(sentences: List<Sentence>, readingSentenceId: String?) {
        val input1 = JsonDefault().stringify(Sentence.serializer().list, sentences)
        val input2 = "'" + (readingSentenceId ?: "") + "'"
        Log.d("asdfaf", input1)
        webView.loadUrl("javascript:window.webapp.startReader($input1, $input2)")
    }

    fun startQuiz(questions: List<Question>, readingQuestionId: String?) {
        val input1 = JsonDefault().stringify(Question.serializer().list, questions)
        val input2 = "'" + (readingQuestionId ?: "") + "'"
        Log.d("asdfaf", input1)
        webView.loadUrl("javascript:window.webapp.startQuiz($input1, $input2)")
    }
}