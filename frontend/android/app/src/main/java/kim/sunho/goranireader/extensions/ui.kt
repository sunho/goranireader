package kim.sunho.goranireader.extensions

import android.view.animation.Interpolator
import androidx.core.view.animation.PathInterpolatorCompat

// https://matthewlein.com/tools/ceaser

class Easing {
    companion object {
        @JvmStatic
        fun default() : Interpolator = PathInterpolatorCompat.create(0.250f, 0.100f, 0.250f, 1.000f)
    }
}