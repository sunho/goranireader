package kim.sunho.goranireader.fragments

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.webkit.WebView
import kim.sunho.goranireader.R
import android.webkit.WebChromeClient
import android.webkit.WebSettings
import kim.sunho.goranireader.fragments.reader.Bridge
import kim.sunho.goranireader.fragments.reader.ReaderView
import android.R.id.message
import android.webkit.ConsoleMessage
import android.util.Log


class ReaderFragment : Fragment() {
    lateinit var readerView: ReaderView
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_reader, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val webView: WebView = view.findViewById(R.id.webView)
        webView.settings.javaScriptEnabled = true
        webView.settings.javaScriptCanOpenWindowsAutomatically = true
        webView.settings.loadsImagesAutomatically = true
        webView.settings.useWideViewPort = true
        webView.settings.setSupportZoom(false)
        webView.settings.cacheMode = WebSettings.LOAD_NO_CACHE
        webView.settings.setAppCacheEnabled(false)
        webView.settings.domStorageEnabled = true
        webView.settings.allowFileAccess = true
        webView.webChromeClient = WebChromeClient()
        webView.settings.userAgentString = "app"
        webView.webChromeClient = object : WebChromeClient() {
            override fun onConsoleMessage(consoleMessage: ConsoleMessage): Boolean {
                Log.e(
                    "asdfasf",
                    consoleMessage.message() + '\n'.toString() + consoleMessage.messageLevel() + '\n'.toString() + consoleMessage.sourceId()
                )
                return super.onConsoleMessage(consoleMessage)
            }
        }
        readerView = ReaderView(webView)
        webView.loadUrl("file:///android_asset/reader/index.html")
    }

}

