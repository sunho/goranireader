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
    val timer: Timer = Timer()
    var inited: Boolean = false
    var loaded: Boolean = false
    var tt: TimerTask? = null
    var quiz: Boolean = false
    var readingSentence: String = ""
    var readingQuestion: String = ""
    var solvedChapters: MutableList<String> = ArrayList()
    val readingChapter: MutableLiveData<Int> = MutableLiveData()
    val needStart: MutableLiveData<Unit> = MutableLiveData()

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
                        readingQuestion = progress.questionId
                        readingSentence = progress.sentenceId
                        quiz = progress.quiz
                        solvedChapters = progress.solvedChapters.toMutableList()
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
        initForPage()
        isStart.value = false
        isEnd.value = false
    }

    fun initForPage() {
        startTimer()
        elapsedTime = 0
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
       EventLogService.paginate(book!!.meta.id, currentChapter()!!.id, elapsedTime, sids, wordUnknowns, sentenceUnknown)
    }

    fun submitQuestion(qid: String, option: String, right: Boolean) {
        EventLogService.submitQuestion(book!!.meta.id, currentChapter()!!.id, qid, option, right, elapsedTime)
    }

    fun stopTimer() {
        stopped = true
    }

    fun next() {
        val book = this.book!!
        val i = this.readingChapter.value!!
        val chap = currentChapter()!!
//        chap.questions = ArrayList(listOf(
//            Question("word", "1", "hello world", 0, ArrayList(listOf("hoi", "He")), 0),
//            Question("summary", "2", null, null, ArrayList(listOf("hoi", "He")), 0)
//        ))

        if (chap.questions != null &&
            chap.questions!!.isNotEmpty() &&
            !solvedChapters.contains(chap.id)) {
            quiz = true
            readingSentence = ""
            readingQuestion = chap.questions!![0].id
            updateProgress()
            needStart.value = Unit
        } else {
            if (quiz && i == book.chapters.size - 1) {
                quiz = false
                readingSentence = book.chapters[i].items.getOrNull(chap.items.size - 1)?.id ?: ""
                readingQuestion = ""
                readingChapter.value = i + 1
                updateProgress()
                needStart.value = Unit
            } else if (i < book.chapters.size - 1) {
                quiz = false
                readingSentence = book.chapters[i + 1].items[0].id
                readingQuestion = ""
                readingChapter.value = i + 1
                updateProgress()
                needStart.value = Unit
            }
        }
    }

    fun prev() {
        val book = this.book!!
        val i = this.readingChapter.value!!
        val chap = book.chapters[i - 1]
        if (i > 0) {
            quiz = false
            readingSentence = book.chapters[i - 1].items.getOrNull(chap.items.size - 1)?.id ?: ""
            readingChapter.value = i - 1
            needStart.value = Unit
        }
    }


    fun wordSelect(word: String, wordIndex: Int, sid: String) {
        wordUnknowns.add(PaginateWordUnknown(sid, word, wordIndex, elapsedTime))
    }

    fun addUnknownSentence(sid: String) {
        sentenceUnknown.add(PaginateSentenceUnknown(sid, elapsedTime))
        EventLogService.unknownSentence(book!!.meta.id, currentChapter()!!.id, sid)
    }

    fun updateProgress() {
        Realm.getDefaultInstance().use { realm ->
            realm.executeTransactionAsync {
                val progress = getProgress(it)!!
                progress.chapterId = book!!.chapters[readingChapter.value ?: 0].id
                progress.sentenceId = readingSentence
                progress.questionId = readingQuestion
                progress.quiz = quiz
                progress.solvedChapters.clear()
                progress.solvedChapters.addAll(solvedChapters)
            }
        }
    }

    private fun getProgress(realm: Realm): BookRead? {
        return realm.where(BookRead::class.java).equalTo("id", book!!.meta.id).findFirst()
    }
}