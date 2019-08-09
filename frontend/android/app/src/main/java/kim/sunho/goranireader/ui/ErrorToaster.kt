package kim.sunho.goranireader.ui

import android.content.Context
import android.widget.Toast
import com.downloader.Error as DError

object ErrorToaster {
    fun toast(context: Context, error: DError?) {
        Toast.makeText(context, error?.connectionException.toString(), Toast.LENGTH_SHORT).show()
    }
}