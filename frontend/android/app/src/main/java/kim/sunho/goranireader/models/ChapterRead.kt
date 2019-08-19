package kim.sunho.goranireader.models

import io.realm.RealmList
import io.realm.RealmObject

open class ChapterRead (
    var id: String = "",
    var percent: Double = 0.0,
    var nSen: Int = 0,
    var sentences: RealmList<String> = RealmList()
) : RealmObject()