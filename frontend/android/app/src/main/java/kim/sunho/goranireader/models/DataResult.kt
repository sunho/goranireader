package kim.sunho.goranireader.models

import com.google.firebase.Timestamp


data class DataResult (
    val clientBookRead: Map<String, Double> = HashMap(),
    val clientLastUpdated: Timestamp = Timestamp.now()
)