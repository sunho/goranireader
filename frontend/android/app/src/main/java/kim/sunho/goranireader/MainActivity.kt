package kim.sunho.goranireader

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.appcompat.widget.Toolbar
import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import com.google.android.material.appbar.AppBarLayout
import android.animation.ValueAnimator
import android.util.TypedValue
import androidx.fragment.app.FragmentManager
import kim.sunho.goranireader.extensions.Easing
import com.downloader.PRDownloader
import com.downloader.PRDownloaderConfig
import kim.sunho.goranireader.services.ContentService


class MainActivity : AppCompatActivity() {
    var onBackPressedListener: OnBackPressedListener? = null

    interface OnBackPressedListener {
        fun doBack(): Boolean
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val config = PRDownloaderConfig.newBuilder()
            .build()
        PRDownloader.initialize(applicationContext, config)
        ContentService.init(applicationContext)
    }

    override fun onBackPressed() {
        if (onBackPressedListener != null) {
            if (onBackPressedListener!!.doBack()) {
                super.onBackPressed()
                return
            }
        } else {
            super.onBackPressed()
        }
    }
}
