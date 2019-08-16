package kim.sunho.goranireader.models

import kotlinx.serialization.Serializable

@Serializable
data class BookyBook(
    val meta: Metadata = Metadata(),
    val chapters: List<Chapter> = ArrayList()
)

@Serializable
data class Chapter(
    val items: List<Sentence> = ArrayList(),
    val title: String = "",
    val fileName: String = ""
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