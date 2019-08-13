package kim.sunho.goranireader.models

import com.google.firebase.Timestamp

data class Userdata(
    val userId: String = "",
    val ownedBooks: MutableList<String> = ArrayList(),
    val bookCheck: Timestamp = Timestamp.now()
)