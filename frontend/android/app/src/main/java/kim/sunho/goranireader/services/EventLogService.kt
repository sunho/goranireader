package kim.sunho.goranireader.services

import android.os.Bundle
import com.google.firebase.analytics.FirebaseAnalytics
import io.realm.Realm
import io.realm.kotlin.createObject
import kim.sunho.goranireader.extensions.JsonDefault
import kim.sunho.goranireader.models.*
import java.util.*

object EventLogService {
    fun paginate(bookId: String,
                 chapterId: String,
                 time: Int,
                 sids: List<String>,
                 wordUnknowns: List<PaginateWordUnknown>,
                 sentenceUnknowns: List<PaginateSentenceUnknown>) {
        val payload = ELPaginatePayload(bookId, chapterId, time, sids, wordUnknowns, sentenceUnknowns)
        postEventLog("paginate", JsonDefault().stringify(ELPaginatePayload.serializer(), payload))
    }

    fun unknownWord(bookId: String, chapterId: String, sentenceId: String, wordIndex: Int, word: String, def: String) {
        val payload = ELUnknownWord(bookId, chapterId, sentenceId, wordIndex, word, def)
        postEventLog("unknown_word", JsonDefault().stringify(ELUnknownWord.serializer(), payload))
    }

    fun unknownSentence(bookId: String, chapterId: String, sentenceId: String) {
        val payload = ELUnknownSentence(bookId, chapterId, sentenceId)
        postEventLog("unknown_sentence", JsonDefault().stringify(ELUnknownSentence.serializer(), payload))
    }

    private fun postEventLog(type: String, payload: String) {
        Realm.getDefaultInstance().use {
            it.executeTransaction {
                val ev = it.createObject(EventLog::class.java)
                ev.time = Date()
                ev.type = type
                ev.payload = payload
            }
        }
    }

    fun sync() {
        if ()
        Realm.getDefaultInstance().use {
            it.executeTransaction {realm ->
                val evs = realm.where(EventLog::class.java).findAll()
                evs.forEach {  }
                val bookReads = realm.where(BookRead::class.java).findAll()
                bookReads.forEach { if (bookReads.) }
            }
        }
    }
}