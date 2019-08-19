package kim.sunho.goranireader.models

import io.realm.RealmList
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import java.util.*

open class BookRead (
    @PrimaryKey
    var id: String = "",
    var percent: Double = 0.0,
    var updatedAt: Date = Date(),
    var chapterId: String = "",
    var sentenceId: String = "",
    var chapterReads: RealmList<ChapterRead> = RealmList()
) : RealmObject()