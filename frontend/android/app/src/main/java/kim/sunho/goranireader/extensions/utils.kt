package kim.sunho.goranireader.extensions

import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonConfiguration

fun JsonDefault(): Json {
    return Json(JsonConfiguration.Stable)
}