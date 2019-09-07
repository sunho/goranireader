package kim.sunho.goranireader.fragments.reader

import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.lifecycle.MediatorLiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.google.android.gms.tasks.Tasks
import io.realm.Realm
import kim.sunho.goranireader.extensions.CoroutineViewModel
import kim.sunho.goranireader.extensions.onUi
import kim.sunho.goranireader.fragments.ReaderFragmentArgs
import kim.sunho.goranireader.models.*
import kim.sunho.goranireader.services.ContentService
import kim.sunho.goranireader.services.DBService
import kim.sunho.goranireader.services.EventLogService
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
    var stopped: Boolean = false
    var elapsedTime: Int = 0 //ms
    var book: BookyBook? = null
    var isQuiz: Boolean = false
    val timer: Timer = Timer()
    var inited: Boolean = false
    var loaded: Boolean = false
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
            book = ContentService.readBook(bookId + ".book")
            onUi {
                Realm.getDefaultInstance().use { realm ->
                    val progress = getProgress(realm)
                    if (progress != null) {
                        val i = book!!.chapters.indexOfFirst { it.id == progress.chapterId }
                        val sen = progress.sentenceId
                        readingChapter.value = if (i != -1) i else 0
                        readingSentence = sen
                    } else {
                        realm.executeTransaction {
                            it.createObject(BookRead::class.java, book!!.meta.id)
                        }
                        val sen = book!!.chapters[0].items[0].id
                        readingChapter.value = 0
                        readingSentence = sen
                    }
                }
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

    fun initForChapter() {
        loaded = false
    }

    fun initForPage() {
        elapsedTime = 0
        startTimer()
        isStart.value = false
        isEnd.value = false
        wordUnknowns.clear()
        sentenceUnknown.clear()
    }

    fun tick() {
        if (!stopped) {
            elapsedTime += 100
        }
    }

    fun startTimer() {
        stopped = false
    }

    fun paginate(sids: List<String>) {
        Realm.getDefaultInstance().use { realm ->
            val progress = getProgress(realm)!!
            var chapRead = progress.chapterReads.where()
                .equalTo("id", currentChapter()!!.id)
                .findFirst()
            if (chapRead == null) {
                realm.executeTransaction {
                    val new = it.createObject(ChapterRead::class.java)
                    new.id = currentChapter()!!.id
                    new.nSen = currentChapter()!!.items.size
                    progress.chapterReads.add(new)
                    chapRead = new
                }
            }
            realm.executeTransaction {
                chapRead!!.sentences.removeAll(sids)
                chapRead!!.sentences.addAll(sids)
                chapRead!!.percent = chapRead!!.sentences.size / ( chapRead!!.nSen.toDouble())
                val totalSen = progress.chapterReads.map {
                    it.percent * it.nSen
                }.sum()
                progress.percent = totalSen / book!!.chapters.map { it.items.size }.sum()
                Log.d("percent",  progress.percent.toString())
                progress.updatedAt = Date()
            }
        }
        EventLogService.paginate(book!!.meta.id, currentChapter()!!.id, elapsedTime, sids, wordUnknowns, sentenceUnknown)
    }


    fun stopTimer() {
        stopped = true
    }

    fun next() {
        val book = this.book!!
        val i = this.readingChapter.value!!
        if (i < book.chapters.size) {
            readingSentence = book.chapters[i + 1].items[0].id
            this.readingChapter.value = i + 1
        }
    }

    fun prev() {
        val book = this.book!!
        val i = this.readingChapter.value!!
        val chap = book.chapters[i - 1]
        if (i > 0) {
            readingSentence = book.chapters[i - 1].items[chap.items.size - 1].id
            this.readingChapter.value = i - 1
        }
    }

    fun sentenceSelect(sid: String) {
        sentenceUnknown.add(PaginateSentenceUnknown(sid, elapsedTime))
    }

    fun wordSelect(wordIndex: Int, sid: String) {
        wordUnknowns.add(PaginateWordUnknown(sid, "", wordIndex, elapsedTime))
    }

    fun addUnknownSentence(sid: String) {
        EventLogService.unknownSentence(book!!.meta.id, currentChapter()!!.id, sid)
    }

    fun addUnknownWord(sid: String, wordIndex: Int, word: String, def: String) {
        wordUnknowns.add(PaginateWordUnknown(sid, word, wordIndex, elapsedTime))
        EventLogService.unknownWord(book!!.meta.id, currentChapter()!!.id, sid, wordIndex, word, def)
    }

    private fun updateProgress() {
        Realm.getDefaultInstance().use { realm ->
            realm.executeTransactionAsync {
                val progress = getProgress(it)!!
                progress.chapterId = book!!.chapters[readingChapter.value ?: 0].id
                progress.sentenceId = readingSentence
            }
        }
    }

    private fun getProgress(realm: Realm): BookRead? {
        return realm.where(BookRead::class.java).equalTo("id", book!!.meta.id).findFirst()
    }
}