package kim.sunho.goranireader.models

data class Book(
    val id: String = "",
    val title: String = "",
    val author: String = "",
    val cover: String? = null,
    val coverType: String? = null
)
