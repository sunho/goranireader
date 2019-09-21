package kim.sunho.goranireader.models

import kotlinx.serialization.Serializable

@Serializable
data class BookyBook(
    val meta: Metadata = Metadata(),
    val chapters: List<Chapter> = ArrayList()
)

@Serializable
data class Chapter(
    val id: String = "",
    val items: List<Sentence> = ArrayList(),
    val title: String = "",
    val fileName: String = "",
    var questions: List<Question>? = null //TODO
)

@Serializable
data class Sentence(
    val start: Boolean = false,
    val content: String = "",
    val id: String = ""
)

@Serializable
data class Metadata(
    val title: String = "",
    val cover: String = "",
    val coverType: String = "",
    val author: String = "",
    val id: String = ""
)

@Serializable
data class Question(
    val type: String = "",
    val id: String = "",
    val sentence: String? = null,
    val wordIndex: Int? = null,
    val options: List<String> = ArrayList(),
    val answer: Int = 0
)