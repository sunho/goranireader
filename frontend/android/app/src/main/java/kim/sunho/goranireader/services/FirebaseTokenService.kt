package kim.sunho.goranireader.services

import android.content.Context
import android.content.Context.MODE_PRIVATE
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage


class FirebaseTokenService : FirebaseMessagingService() {
    override fun onNewToken(s: String) {
        super.onNewToken(s)
        getSharedPreferences("_", MODE_PRIVATE).edit().putString("fb", s).apply()
    }

    companion object {

        fun getToken(context: Context): String? {
            return context.getSharedPreferences("_", MODE_PRIVATE).getString("fb", "empty")
        }
    }
}
