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


class MainActivity : AppCompatActivity() {
    var onBackPressedListener: OnBackPressedListener? = null

    interface OnBackPressedListener {
        fun doBack(): Boolean
    }

    private val toolBarAnimDuration = 200
    private var toolbarHeight: Int = 0
    private var toolBar: Toolbar? = null
    private var vaActionBar: ValueAnimator? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        this.toolBar = findViewById(R.id.toolbar)
        setSupportActionBar(this.toolBar)

        val tv = TypedValue()
        if (theme.resolveAttribute(android.R.attr.actionBarSize, tv, true)) {
            toolbarHeight = TypedValue.complexToDimensionPixelSize(tv.data, resources.displayMetrics)
        }

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

    fun hideActionBar() {
        if (vaActionBar != null && vaActionBar!!.isRunning) {
            return
        }

        vaActionBar = ValueAnimator.ofInt(toolbarHeight, 0)
        vaActionBar!!.interpolator = Easing.default()
        vaActionBar!!.addUpdateListener { animation ->
            (toolBar!!.layoutParams as AppBarLayout.LayoutParams).height = animation.animatedValue as Int
            toolBar!!.requestLayout()
        }

        vaActionBar!!.addListener(object : AnimatorListenerAdapter() {
            override fun onAnimationEnd(animation: Animator) {
                super.onAnimationEnd(animation)

                if (supportActionBar != null) {
                    supportActionBar!!.hide()
                }
            }
        })

        vaActionBar!!.duration = toolBarAnimDuration.toLong()
        vaActionBar!!.start()
    }

    fun showActionBar() {
        if (vaActionBar != null && vaActionBar!!.isRunning) {
            return
        }

        vaActionBar = ValueAnimator.ofInt(0, toolbarHeight)
        vaActionBar!!.interpolator = Easing.default()
        vaActionBar!!.addUpdateListener { animation ->
            (toolBar!!.layoutParams as AppBarLayout.LayoutParams).height = animation.animatedValue as Int
            toolBar!!.requestLayout()
        }

        vaActionBar!!.addListener(object : AnimatorListenerAdapter() {
            override fun onAnimationStart(animation: Animator) {
                super.onAnimationStart(animation)

                if (supportActionBar != null) {
                    supportActionBar!!.show()
                }
            }
        })

        vaActionBar!!.duration = toolBarAnimDuration.toLong()
        vaActionBar!!.start()
    }
}
