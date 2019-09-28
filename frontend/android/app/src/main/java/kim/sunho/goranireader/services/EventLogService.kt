package kim.sunho.goranireader.services

import android.os.Bundle
import android.util.Log
import androidx.lifecycle.MutableLiveData
import com.github.kittinunf.fuel.Fuel
import com.github.kittinunf.fuel.core.extensions.jsonBody
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.analytics.FirebaseAnalytics
import com.google.firebase.auth.FirebaseAuth
import com.github.kittinunf.result.Result
import com.google.android.gms.tasks.Tasks
import com.google.firebase.auth.GetTokenResult
import com.google.firebase.iid.FirebaseInstanceId
import io.realm.Realm
import io.realm.kotlin.createObject
import kim.sunho.goranireader.extensions.JsonDefault
import kim.sunho.goranireader.extensions.onUi
import kim.sunho.goranireader.models.*
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import kotlinx.serialization.internal.HashMapSerializer
import kotlinx.serialization.serializer
import kotlinx.serialization.stringify
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.HashMap

object EventLogService {
    lateinit var auth: FirebaseAuth
    private val job = SupervisorJob()
    private val scope = CoroutineScope(Dispatchers.Default + job)
    val onNeedFetch: MutableLiveData<Unit> = MutableLiveData()
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

    fun submitQuestion(bookId: String, chapterId: String, questionId: String, option: String, right: Boolean, time: Int) {
        val payload = ELSubmitQuestionPayload(bookId, chapterId, questionId, option, right, time)
        postEventLog("submit_question", JsonDefault().stringify(ELSubmitQuestionPayload.serializer(), payload))
    }

    fun unknownSentence(bookId: String, chapterId: String, sentenceId: String) {
        val payload = ELUnknownSentence(bookId, chapterId, sentenceId)
        postEventLog("unknown_sentence", JsonDefault().stringify(ELUnknownSentence.serializer(), payload))
    }

    private fun postEventLog(type: String, payload: String) {
        val obj = HashMap<String, String>()
        obj["type"] = type
        obj["payload"] = payload
        obj["time"]= SimpleDateFormat("yyyy-MM-dd'T'h:m:ssZZZZZ").format(Date())
        addToRealm(obj)
    }

    private fun addToRealm(obj: HashMap<String, String>) {
        Realm.getDefaultInstance().use {
            it.executeTransaction {
                val ev = it.createObject(EventLog::class.java, UUID.randomUUID().toString())
                ev.time = obj["time"]!!
                ev.type = obj["type"]!!
                ev.payload = obj["payload"]!!
                Log.d("EventLog", "time: ${ev.time} type: ${ev.type} payload: ${ev.payload}")
            }
        }
    }

    private fun sendToServer(obj: HashMap<String, String>, success: () -> Unit) {
        val res = Tasks.await(auth.currentUser!!.getIdToken(true))
        val token = res.token ?: return
        Fuel.post("https://asia-northeast1-gorani-reader-249509.cloudfunctions.net/addLog")
            .header("Authorization", token)
            .timeout(4000)
            .jsonBody(JsonDefault().stringify(HashMapSerializer(String.serializer(), String.serializer()), obj))
            .responseString { request, response, result ->
                when (result) {
                    is Result.Success -> {
                        if (response.statusCode == 200) {
                            success()
                        }
                    }
                }
            }
    }

    fun sync() {
        val objs = Realm.getDefaultInstance().use {
            val evs = it.where(EventLog::class.java).findAll()
            Log.d("size", evs.size.toString())
            evs.map {
                val obj = HashMap<String, String>()
                obj["id"] = it.id
                obj["type"] = it.type
                obj["payload"] = it.payload
                obj["time"]= it.time
                obj
            }
        }
        scope.launch {
            objs.forEach { obj ->
                try {
                    sendToServer(obj) {
                        Realm.getDefaultInstance().use {
                            it.executeTransaction { realm ->
                                realm.where(EventLog::class.java)
                                    .equalTo("id", obj["id"]!!)
                                    .findAll()
                                    .deleteAllFromRealm()
                            }
                        }
                        onNeedFetch.value = Unit
                    }
                } catch (e: Exception) {
                    Log.d("error", e.message)
                }
            }
        }
    }
}