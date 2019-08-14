package kim.sunho.goranireader.fragments.reader

import android.util.Log
import android.webkit.JavascriptInterface
import android.webkit.WebView
import kim.sunho.goranireader.models.Sentence

class BridgeApp(private val readerView: ReaderView) {
    @JavascriptInterface
    fun initComplete() {

    }

    @JavascriptInterface
    fun loadComplete() {

    }
}

class Bridge(private val webView: WebView) {

}

class ReaderView(private val webView: WebView) {
    val bridge: Bridge
    init {
        webView.addJavascriptInterface(BridgeApp(this), "app")
        bridge = Bridge(webView)
    }

    fun loadSentences(sens: List<Sentence>) {

    }
}

