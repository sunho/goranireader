package kim.sunho.goranireader.models

import kotlinx.serialization.Serializable

@Serializable
data class PaginateWordUnknown(
    val sentenceId: String = "",
    val word: String = "",
    val wordIndex: Int = 0,
    val time: Int = 0
)

@Serializable
data class PaginateSentenceUnknown(
    val sentenceId: String = "",
    val time: Int = 0
)