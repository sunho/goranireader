package kim.sunho.goranireader.models

data class Book(
    val id: String = "",
    val title: String = "",
    val author: String = "",
    val downloadLink: String = "",
    val cover: String? = null,
    val coverType: String? = null,
    val chapters: Map<String, String> = HashMap()
) {
    fun toContent(): Content {
        return Content.Online(id, cover, title, author, downloadLink)
    }
}
