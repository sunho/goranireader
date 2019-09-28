package kim.sunho.goranireader.models

import com.google.firebase.Timestamp
import java.util.*


data class StudentClass(
    val name: String = "",
    val mission: Mission? = null
)

data class Mission(
    val bookId: String? = "",
    val id: String = "",
    val message: String = "",
    val due: Timestamp = Timestamp.now(),
    val chapters: List<String> = ArrayList()
)