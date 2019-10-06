package kim.sunho.goranireader.fragments

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.webkit.WebView
import kim.sunho.goranireader.R
import android.webkit.WebChromeClient
import android.webkit.WebSettings
import kim.sunho.goranireader.fragments.reader.Bridge
import android.webkit.ConsoleMessage
import android.util.Log
import android.view.*
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProviders
import androidx.navigation.fragment.findNavController
import androidx.navigation.fragment.navArgs
import kim.sunho.goranireader.extensions.*
import kim.sunho.goranireader.fragments.home.HomeBooksViewModel
import kim.sunho.goranireader.fragments.reader.ReaderBridgeApp
import kim.sunho.goranireader.fragments.reader.ReaderViewModel
import kim.sunho.goranireader.models.Question
import kim.sunho.goranireader.services.ContentService
import kotlinx.coroutines.launch
import java.lang.IllegalStateException
import java.util.*
import android.content.DialogInterface
import androidx.appcompat.app.AlertDialog
import kim.sunho.goranireader.models.Chapter
import kotlinx.android.synthetic.main.fragment_reader.view.*



class ReaderFragment: CoroutineFragment() {
    val args: ReaderFragmentArgs by navArgs()
    lateinit var timer: Timer
    lateinit var viewModel: ReaderViewModel
    lateinit var bridge: Bridge
    lateinit var bridgeApp: ReaderBridgeApp
    lateinit var webView: SwipeWebView
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_reader, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        scope.launch {
            viewModel.initIfNot(activity.main().db, args.bookId)
            onUi {
                configureWebview()
            }
        }
        webView = view.findViewById(R.id.webView)
        webView.setLayerType(View.LAYER_TYPE_SOFTWARE, null);
        bridge = Bridge(webView)
        bridgeApp = ReaderBridgeApp(this)
        WebView.setWebContentsDebuggingEnabled(true)
        webView.addJavascriptInterface(bridgeApp, "app")
        timer = Timer()
        timer.scheduleAtFixedRate(
            object : TimerTask() {
                override fun run() {
                    viewModel.tick()
                }
            },
            0, 100
        )
        view.movebutton.setOnClickListener { view ->
            if (viewModel.inited && viewModel.loaded && !viewModel.quiz) {
                openDialog()
            }
        }

    }

    fun openDialog() {
        val chapters = viewModel.book!!.chapters
        val builder = AlertDialog.Builder(this.context!!)
        builder.setTitle("Pick a chapter")
        val ci = chapters.indexOfFirst { it.id == viewModel.currentChapter()?.id }
        builder.setSingleChoiceItems(chapters.map { it.title }.toTypedArray(), ci,
            DialogInterface.OnClickListener { dialog, which ->
                val i = viewModel.book!!.chapters.indexOfFirst { it.id ==  chapters[which].id }
                viewModel.readingSentence = ""
                viewModel.quiz = false
                this.viewModel.readingChapter.value = if (i != -1) i else 0
                viewModel.updateProgress()
                start()
                dialog.dismiss()
            }).setNegativeButton("Cancel",
            DialogInterface.OnClickListener { dialog, whichButton ->
                dialog.dismiss()
            }).setCancelable(true);
        builder.show()
    }


    fun start() {
        viewModel.loaded = false
        val chapter = viewModel.currentChapter() ?: throw IllegalStateException("no chapter")
        if (!viewModel.quiz) {
            bridge.startReader(chapter.items, viewModel.readingSentence)
            return
        }
//        chapter.questions = ArrayList(listOf(
//            Question("word", "1", "hello world", 0, ArrayList(listOf("hoi", "He")), 0),
//            Question("summary", "2", null, null, ArrayList(listOf("hoi", "He")), 0)
//        ))
        if (chapter.questions == null) {
            viewModel.quiz = false
            viewModel.updateProgress()
            throw IllegalStateException("no chapter")
        }
        bridge.startQuiz(chapter.questions!!, viewModel.readingQuestion)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        viewModel = ViewModelProviders.of(this)[ReaderViewModel::class.java]
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
        webView.setGestureDetector(GestureDetector(object: SwipeGestureListener() {
            override fun onSwipeLeft() {
                if (viewModel.isEnd.value == true && viewModel.inited && viewModel.loaded) {
                    viewModel.next()
                }
            }

            override fun onSwipeRight() {
                if (viewModel.isStart.value == true && viewModel.inited && viewModel.loaded) {
                    viewModel.prev()
                }
            }
        }))
        viewModel.needStart.observe(this, Observer {
            this.start()
        })
        webView.loadUrl("file:///android_asset/reader/index.html")
    }

    override fun onDetach() {
        super.onDetach()
        Log.d("hello", "detach")
        viewModel.loaded = false
        viewModel.inited = false
        timer.cancel()
    }
}

