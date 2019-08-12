package kim.sunho.goranireader.models

import com.google.firebase.Timestamp
import java.util.*
import kotlin.collections.HashMap

data class UserUnknownWord(
    val words: MutableMap<String, UnknownWord> = HashMap()
)

data class UnknownWord(
    val definitions: MutableMap<String, UnknownDefinition> = HashMap(),
    val ef: Double = 2.5,
    val nextReview: Timestamp = Timestamp(Date()),
    val repetitions: Int = 0,
    val createdAt: Timestamp = Timestamp(Date())
)

data class UnknownDefinition(
    val examples: MutableMap<String, UnknownExample> = HashMap(),
    val createdAt: Timestamp = Timestamp(Date())
)

data class UnknownExample(
    val sentence: String = "",
    val bookId: String = "",
    val sentenceId: String = "",
    val createdAt: Timestamp = Timestamp(Date())
)