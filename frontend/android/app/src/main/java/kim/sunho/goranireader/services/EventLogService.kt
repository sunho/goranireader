package kim.sunho.goranireader.services

import android.os.Bundle
import com.google.firebase.analytics.FirebaseAnalytics
import kim.sunho.goranireader.extensions.JsonDefault
import kim.sunho.goranireader.models.PaginateSentenceUnknown
import kim.sunho.goranireader.models.PaginateWordUnknown

class EventLogService(private val analytics: FirebaseAnalytics) {
    val BOOK_ID = "book_id"
    val TIME = "time"
    val SENTENCE_IDS = "sentence_ids"
    val CHAPTER_ID = "chapter_id"
    val WORD_UNKNOWNS = "word_unknowns"
    val SENTENCE_UNKNOWNS = "sentence_unknowns"
    val EVENT_PAGINATE = "paginate"


    fun openBook(bookId: String, name: String) {
        val bundle = Bundle()
        bundle.putString(FirebaseAnalytics.Param.ITEM_ID, bookId)
        bundle.putString(FirebaseAnalytics.Param.ITEM_NAME, name)
        bundle.putString(FirebaseAnalytics.Param.CONTENT_TYPE, "book")
        analytics.logEvent(FirebaseAnalytics.Event.SELECT_CONTENT, bundle)
    }

    fun paginate(bookId: String,
                 chapterId: String,
                 time: Int,
                 sids: List<String>,
                 wordUnknowns: List<PaginateWordUnknown>,
                 sentenceUnknowns: List<PaginateSentenceUnknown>) {
        val bundle = Bundle()
        bundle.putString(BOOK_ID, bookId)
        bundle.putInt(TIME, time)
        bundle.putStringArrayList(SENTENCE_IDS, ArrayList(sids))
        bundle.putString(CHAPTER_ID, chapterId)
        bundle.putStringArrayList(WORD_UNKNOWNS, ArrayList(wordUnknowns.map{
            JsonDefault().stringify(PaginateWordUnknown.serializer(), it)
        }))
        bundle.putStringArrayList(SENTENCE_UNKNOWNS, ArrayList(sentenceUnknowns.map{
            JsonDefault().stringify(PaginateSentenceUnknown.serializer(), it)
        }))
        analytics.logEvent(EVENT_PAGINATE, bundle)
    }

    fun unknownWord(bookId: String, word: String) {

    }

    fun unknownSentence(bookId: String, sentenceId: String) {

    }
}