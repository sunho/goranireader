package kim.sunho.goranireader.models

import kotlinx.serialization.Serializable

@Serializable
data class DictSearchResult(
    val words: List<DictWord> = ArrayList(),
    val addable: Boolean = false
)

@Serializable
data class DictWord(
    val word: String = "",
    val pron: String = "",
    val defs: List<DictDefinition> = ArrayList()
)

@Serializable
data class DictDefinition(
    val id: Int = 0,
    val pos: String? = null,
    val def: String = ""
)

