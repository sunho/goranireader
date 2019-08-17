package kim.sunho.goranireader.extensions

import android.content.Context
import android.view.GestureDetector
import android.text.method.Touch.onTouchEvent
import android.util.AttributeSet
import android.view.MotionEvent
import android.webkit.WebView


class SwipeWebView : WebView {

    private var gestureDetector: GestureDetector? = null

    constructor(context: Context) : super(context) {}

    constructor(context: Context, attrs: AttributeSet) : super(context, attrs) {}

    constructor(context: Context, attrs: AttributeSet, defStyle: Int) : super(context, attrs, defStyle) {}

    override fun onScrollChanged(l: Int, t: Int, oldl: Int, oldt: Int) {
        super.onScrollChanged(l, t, oldl, oldt)
    }

    override fun onTouchEvent(ev: MotionEvent): Boolean {
        return super.onTouchEvent(ev) && gestureDetector!!.onTouchEvent(ev)
    }

    fun setGestureDetector(gestureDetector: GestureDetector) {
        this.gestureDetector = gestureDetector
    }
}