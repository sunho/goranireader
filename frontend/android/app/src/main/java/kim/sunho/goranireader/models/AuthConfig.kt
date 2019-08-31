package kim.sunho.goranireader.models

import io.realm.RealmObject
import io.realm.annotations.PrimaryKey

open class AuthConfig (
    @PrimaryKey
    var id: Int = 1,
    var authed: Boolean = false
) : RealmObject()