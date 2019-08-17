package kim.sunho.goranireader.fragments.reader

import android.util.Log
import androidx.lifecycle.MediatorLiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.google.android.gms.tasks.Tasks
import kim.sunho.goranireader.extensions.CoroutineViewModel
import kim.sunho.goranireader.extensions.onUi
import kim.sunho.goranireader.fragments.ReaderFragmentArgs
import kim.sunho.goranireader.models.*
import kim.sunho.goranireader.services.ContentService
import kim.sunho.goranireader.services.DBService
import kotlinx.coroutines.Deferred
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import java.util.*
import java.util.concurrent.Future
import kotlin.collections.HashMap

class ReaderViewModel: CoroutineViewModel() {
    val isStart: MutableLiveData<Boolean> = MutableLiveData()
    val isEnd: MutableLiveData<Boolean> = MutableLiveData()
    val wordUnknowns = ArrayList<PaginateWordUnknown>()
    val sentenceUnknown = ArrayList<PaginateSentenceUnknown>()
    var elapsedTime: Int = 0 //ms
    var book: BookyBook? = null
    val timer: Timer = Timer()
    var tt: TimerTask? = null
    var readingSentence: String = ""
        set(value) {
            if (value == "") {
                return
            }
            field = value
            updateProgress()
        }
    val readingChapter: MutableLiveData<Int> = MutableLiveData()

    private val readingChapterMediator = MediatorLiveData<Unit>().apply {
        addSource(readingChapter) { value ->
            updateProgress()
        }
    }.also { it.observeForever { } }

    lateinit var db: DBService

    suspend fun initIfNot(db: DBService, bookId: String) {
        this.db = db
        if (book == null) {
            val (sen, chap) = scope.async {
                book = ContentService.readBook(bookId + ".book")
                val doc = db.bookProgressDoc(bookId)
                val progress = Tasks.await(doc.get())
                if (progress.exists()) {
                    Pair(progress["readingSentence"].toString(), progress["readingChapter"].toString())
                } else {
                    Pair("", "")
                }
            }.await()

            onUi {
                readingSentence = sen
                val i = book!!.chapters.indexOfFirst { it.id == chap }
                readingChapter.value = if (i != -1) i else 0
            }
        }
    }

    fun currentChapter(): Chapter? {
        val i = readingChapter.value
        val book = this.book
        if (i != null && book != null)  {
            return book.chapters[i]
        }
        return null
    }

    fun initForPage() {
        elapsedTime = 0
        startTimer()
        isStart.value = false
        isEnd.value = false
        wordUnknowns.clear()
        sentenceUnknown.clear()
    }

    fun startTimer() {
        if (tt != null) {
            tt!!.cancel()
        }
        tt = object: TimerTask() {
            override fun run() {
                elapsedTime += 100
            }
        }
        timer.schedule(tt, 100)
    }

    fun paginate(sids: List<String>) {

    }


    fun stopTimer() {
        if (tt != null) {
            tt!!.cancel()
        }
    }

    fun next() {
        val book = this.book!!
        val i = this.readingChapter.value!!
        if (i < book.chapters.size) {
            readingSentence = book.chapters[i+1].items[0].id
            this.readingChapter.value = i + 1
        }
    }

    fun prev() {

    }

    private fun updateProgress() {
        val obj = HashMap<String, String>()
        obj["readingSentence"] = readingSentence
        obj["readingChapter"] = book!!.chapters[readingChapter.value ?: 0].id
        db.bookProgressDoc(book!!.meta.id).set(obj)
    }
}