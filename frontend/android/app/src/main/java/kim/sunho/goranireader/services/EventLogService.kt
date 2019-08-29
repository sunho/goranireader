package kim.sunho.goranireader.services

import android.os.Bundle
import com.github.kittinunf.fuel.Fuel
import com.github.kittinunf.fuel.core.extensions.jsonBody
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.analytics.FirebaseAnalytics
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.GetTokenResult
import com.google.firebase.iid.FirebaseInstanceId
import io.realm.Realm
import io.realm.kotlin.createObject
import kim.sunho.goranireader.extensions.JsonDefault
import kim.sunho.goranireader.models.*
import kotlinx.serialization.internal.HashMapSerializer
import kotlinx.serialization.serializer
import kotlinx.serialization.stringify
import java.text.SimpleDateFormat
import java.util.*

object EventLogService {
    lateinit var auth: FirebaseAuth
    fun init(auth: FirebaseAuth) {
        this.auth = auth
    }
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
//        Realm.getDefaultInstance().use {
//            it.executeTransaction {
//                val ev = it.createObject(EventLog::class.java)
//                ev.time = Date()
//                ev.type = type
//                ev.payload = payload
//            }
//        }
        auth.currentUser!!.getIdToken(true).addOnCompleteListener {
            val token = it.result?.token ?: ""
            val obj = HashMap<String, String>()
            obj["type"] = type
            obj["payload"] = payload
            obj["time"]= SimpleDateFormat("yyyy-MM-dd'T'h:m:ssZZZZZ").format(Date())
            Fuel.post("https://asia-northeast1-gorani-reader-249509.cloudfunctions.net/addLog")
                .header("Authorization", token)
                .jsonBody(JsonDefault().stringify(HashMapSerializer(String.serializer(), String.serializer()), obj))
            .also { println(it) }
            .response { result -> }
        }

    }

    fun sync() {
//        Realm.getDefaultInstance().use {
//            it.executeTransaction {realm ->
//                val evs = realm.where(EventLog::class.java).findAll()
//                evs.forEach {  }
//                val bookReads = realm.where(BookRead::class.java).findAll()
//                bookReads.forEach { if (bookReads.) }
//            }
//        }
    }
}