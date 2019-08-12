package kim.sunho.goranireader

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.appcompat.widget.Toolbar
import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import com.google.android.material.appbar.AppBarLayout
import android.animation.ValueAnimator
import android.content.Intent
import android.util.Log
import android.util.TypedValue
import android.view.View
import androidx.fragment.app.FragmentManager
import androidx.lifecycle.MediatorLiveData
import androidx.lifecycle.MutableLiveData
import kim.sunho.goranireader.extensions.Easing
import com.downloader.PRDownloader
import com.downloader.PRDownloaderConfig
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInAccount
import com.google.android.gms.auth.api.signin.GoogleSignInClient
import com.google.firebase.firestore.FirebaseFirestore
import kim.sunho.goranireader.services.ContentService
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.common.api.Scope
import com.google.android.material.snackbar.Snackbar
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.google.firebase.auth.GoogleAuthProvider


class MainActivity : AppCompatActivity() {
    lateinit var db: FirebaseFirestore
    lateinit var auth: FirebaseAuth
    lateinit var mainLayout: View

    val currentUser: MediatorLiveData<FirebaseUser> = MediatorLiveData()
    private val _currentUser: MutableLiveData<FirebaseUser> = MutableLiveData()

    private val RC_SIGN_IN: Int = 7
    private lateinit var oauth: GoogleSignInClient

    var onBackPressedListener: OnBackPressedListener? = null

    interface OnBackPressedListener {
        fun doBack(): Boolean
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_main)
        mainLayout = window.decorView.rootView

        currentUser.addSource(_currentUser, currentUser::setValue)

        initFirebase()
        initServices()
    }


    private fun initServices() {
        val config = PRDownloaderConfig.newBuilder()
            .build()
        PRDownloader.initialize(applicationContext, config)
        ContentService.init(applicationContext)
    }

    private fun initFirebase() {
        val scopeBook = Scope("https://www.googleapis.com/auth/books")
        val gso = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
            .requestIdToken(getString(R.string.default_web_client_id))
            .requestEmail()
            .requestScopes(scopeBook)
            .build()
        db = FirebaseFirestore.getInstance()
        auth = FirebaseAuth.getInstance()
        oauth = GoogleSignIn.getClient(this, gso)
    }

    public override fun onStart() {
        super.onStart()
        Log.d("asfasdf", "Asdfasdfs1.5")
        if (auth.currentUser != null) {
            Log.d("asfasdf", "Asdfasdfs2")
            _currentUser.value = auth.currentUser
        }
    }

    public override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == RC_SIGN_IN) {
            val task = GoogleSignIn.getSignedInAccountFromIntent(data)
            try {
                val account = task.getResult(ApiException::class.java)
                firebaseAuthWithGoogle(account!!)
            } catch (e: ApiException) {
                Log.e("MYAPP", "exception", e)
                Snackbar.make(mainLayout, "Authentication Failed.", Snackbar.LENGTH_SHORT).show()
            }
        }
    }

    fun googleSignIn() {
        val signInIntent = oauth.signInIntent
        startActivityForResult(signInIntent, RC_SIGN_IN)
    }

    private fun firebaseAuthWithGoogle(acct: GoogleSignInAccount) {
        val credential = GoogleAuthProvider.getCredential(acct.idToken, null)
        auth.signInWithCredential(credential)
            .addOnCompleteListener(this) { task ->
                if (task.isSuccessful) {
                    currentUser.value = auth.currentUser
                } else {
                    Snackbar.make(mainLayout, "Authentication Failed.", Snackbar.LENGTH_SHORT).show()
                }
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
}
