package kim.sunho.goranireader.fragments.reader

import android.util.Log
import android.webkit.JavascriptInterface
import android.webkit.WebView
import kim.sunho.goranireader.extensions.JsonDefault
import kim.sunho.goranireader.models.Sentence
import kotlinx.serialization.list

class Bridge(private val webView: WebView) {
    fun start(sentences: List<Sentence>, readingSentenceId: String?) {
        val input1 = JsonDefault().stringify(Sentence.serializer().list, sentences)
        val input2 = "'" + (readingSentenceId ?: "") + "'"
        Log.d("asdfaf", input1)
        webView.loadUrl("javascript:window.webapp.start($input1, $input2)")
    }
}