package kim.sunho.goranireader.models

import io.realm.RealmObject
import kotlinx.serialization.Serializable
import java.util.*

open class EventLog (
    var time: Date = Date(),
    var type: String = "",
    var payload: String = ""
) : RealmObject()

@Serializable
data class ELPaginatePayload (
    val bookId: String = "",
    val chapterId: String = "",
    val time: Int = 0,
    val sids: List<String> = ArrayList(),
    val wordUnknowns: List<PaginateWordUnknown> = ArrayList(),
    val sentenceUnknowns: List<PaginateSentenceUnknown> = ArrayList()
)

@Serializable
data class ELUnknownWord (
    val bookId: String = "",
    val chapterId: String = "",
    val sentenceId: String = "",
    val wordIndex: Int = 0,
    val word: String = "",
    val def: String = ""
)

@Serializable
data class ELUnknownSentence (
    val bookId: String = "",
    val chapterId: String = "",
    val sentenceId: String = ""
)