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
import android.webkit.ConsoleMessage
import android.util.Log
import androidx.lifecycle.ViewModelProviders
import androidx.navigation.fragment.navArgs
import kim.sunho.goranireader.fragments.home.HomeBooksViewModel
import kim.sunho.goranireader.fragments.reader.ReaderBridgeApp
import kim.sunho.goranireader.fragments.reader.ReaderViewModel
import kim.sunho.goranireader.services.ContentService


class ReaderFragment : Fragment() {
    val args: ReaderFragmentArgs by navArgs()

    lateinit var viewModel: ReaderViewModel
    lateinit var bridge: Bridge
    lateinit var bridgeApp: ReaderBridgeApp
    lateinit var webView: WebView
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_reader, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        webView = view.findViewById(R.id.webView)
        bridge = Bridge(webView)
        bridgeApp = ReaderBridgeApp(this)
        webView.addJavascriptInterface(bridgeApp, "app")
        configureWebview()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        viewModel = ViewModelProviders.of(parentFragment!!)[ReaderViewModel::class.java]
        if (viewModel.book == null) {
            viewModel.book = ContentService.readBook(args.fileName)
        }
    }

    private fun configureWebview() {
        webView.settings.javaScriptEnabled = true
        webView.settings.javaScriptCanOpenWindowsAutomatically = true
        webView.settings.loadsImagesAutomatically = true
        webView.settings.useWideViewPort = true
        webView.settings.setSupportZoom(false)
        webView.settings.cacheMode = WebSettings.LOAD_NO_CACHE
        webView.settings.setAppCacheEnabled(false)
        webView.settings.domStorageEnabled = true
        webView.settings.allowFileAccess = true
        webView.settings.userAgentString = "app"
        webView.webChromeClient = object : WebChromeClient() {
            override fun onConsoleMessage(consoleMessage: ConsoleMessage): Boolean {
                Log.e(
                    "webView",
                    consoleMessage.message() + '\n'.toString() + consoleMessage.messageLevel() + '\n'.toString() + consoleMessage.sourceId()
                )
                return super.onConsoleMessage(consoleMessage)
            }
        }
        webView.loadUrl("file:///android_asset/reader/index.html")
    }
}

