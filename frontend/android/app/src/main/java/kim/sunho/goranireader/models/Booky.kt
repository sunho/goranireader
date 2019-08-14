package kim.sunho.goranireader.models

data class BookyBook(
    val meta: Metadata = Metadata(),
    val chapters: List<Chapter> = ArrayList()
)

data class Chapter(
    val items: List<Sentence> = ArrayList(),
    val title: String = ""
)

data class Sentence(
    val start: Boolean = false,
    val content: String = "",
    val id: String = ""
)

data class Metadata(
    val title: String = "",
    val cover: String = "",
    val coverType: String = "",
    val author: String = "",
    val id: String = ""
)