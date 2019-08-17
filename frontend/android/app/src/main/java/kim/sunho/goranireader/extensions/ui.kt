package kim.sunho.goranireader.extensions

import android.app.Activity
import android.view.animation.Interpolator
import androidx.core.view.animation.PathInterpolatorCompat
import kim.sunho.goranireader.MainActivity
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlin.coroutines.CoroutineContext

// https://matthewlein.com/tools/ceaser

class Easing {
    companion object {
        @JvmStatic
        fun default() : Interpolator = PathInterpolatorCompat.create(0.250f, 0.100f, 0.250f, 1.000f)
    }
}

fun Activity?.main(): MainActivity = this as MainActivity

suspend fun<T> onUi(block: suspend CoroutineScope.() -> T): T =  withContext(Dispatchers.Main, block)