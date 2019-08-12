package kim.sunho.goranireader.models

import com.google.firebase.Timestamp
import java.util.*
import kotlin.collections.HashMap

data class WordMemory(
    val memories: MutableMap<String, Memory> = HashMap()
)

data class Memory(
    val createdAt: Timestamp = Timestamp(Date()),
    val sentence: String = ""
)