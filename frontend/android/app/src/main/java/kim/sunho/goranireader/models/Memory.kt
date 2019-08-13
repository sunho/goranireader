package kim.sunho.goranireader.models

import com.google.firebase.Timestamp
import java.util.*

data class Memory(
    val createdAt: Timestamp = Timestamp(Date()),
    val sentence: String = ""
)