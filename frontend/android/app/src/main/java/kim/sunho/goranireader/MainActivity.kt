package kim.sunho.goranireader

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.appcompat.widget.Toolbar
import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import com.google.android.material.appbar.AppBarLayout
import android.animation.ValueAnimator
import android.app.Activity
import android.content.Intent
import android.util.Log
import android.util.TypedValue
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.InputMethodManager
import android.widget.EditText
import androidx.core.view.children
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
import com.google.android.gms.tasks.Tasks
import com.google.android.material.snackbar.Snackbar
import com.google.android.material.textfield.TextInputEditText
import com.google.api.client.extensions.android.http.AndroidHttp
import com.google.api.client.googleapis.extensions.android.gms.auth.GoogleAccountCredential
import com.google.api.client.json.jackson2.JacksonFactory
import com.google.api.services.books.Books
import com.google.firebase.Timestamp
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.google.firebase.auth.GoogleAuthProvider
import kim.sunho.goranireader.services.DBService
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import java.util.*
import kotlin.collections.HashSet


class MainActivity : AppCompatActivity() {
    lateinit var db: DBService
    lateinit var fdb: FirebaseFirestore
    lateinit var auth: FirebaseAuth
    lateinit var mainLayout: View

    val currentUser: MediatorLiveData<FirebaseUser> = MediatorLiveData()
    private val _currentUser: MutableLiveData<FirebaseUser> = MutableLiveData()

    private val RC_SIGN_IN: Int = 7
    private lateinit var oauth: GoogleSignInClient

    private val job = SupervisorJob()
    private val scope = CoroutineScope(Dispatchers.Default + job)

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

    fun hideSoftKeyboard() {
        val inputMethodManager = getSystemService(Activity.INPUT_METHOD_SERVICE) as InputMethodManager;
        inputMethodManager.hideSoftInputFromWindow(currentFocus?.windowToken, 0)
    }

    private fun initServices() {
        val config = PRDownloaderConfig.newBuilder()
            .build()
        PRDownloader.initialize(applicationContext, config)
        ContentService.init(applicationContext)
        db = DBService(fdb, auth)
    }

    private fun initFirebase() {
        val scopeBook = Scope("https://www.googleapis.com/auth/books")
        val gso = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
            .requestIdToken(getString(R.string.default_web_client_id))
            .requestEmail()
            .requestScopes(scopeBook)
            .build()
        fdb = FirebaseFirestore.getInstance()
        auth = FirebaseAuth.getInstance()
        oauth = GoogleSignIn.getClient(this, gso)
    }

    public override fun onStart() {
        super.onStart()
        if (auth.currentUser == null) {
            return
        }
        _currentUser.value = auth.currentUser
    }

    fun reloadOwnedBooks() {
        val account = GoogleSignIn.getLastSignedInAccount(this) ?: return
        val credential = GoogleAccountCredential.usingOAuth2(this,
            Collections.singleton("https://www.googleapis.com/auth/books")
        )
        credential.selectedAccount = account?.account
        //TODO separate
        val books = Books.Builder(AndroidHttp.newCompatibleTransport(), JacksonFactory.getDefaultInstance(), credential)
            .setApplicationName("Gorani Reader Android App")
            .build()
        scope.launch {
            val out = HashSet<String>()
            val shelves = books.Mylibrary().Bookshelves().list().execute()
            val udata = db.getUserdata() ?: return@launch
            for (shelf in shelves.items) {
                if (shelf.title != "Purchased") continue
                if (udata.bookCheck == Timestamp(Date(shelf.volumesLastUpdated.value))) continue
                val vols = books.Mylibrary().Bookshelves().Volumes()
                    .list(shelf.id.toString()).execute()
                Tasks.await(fdb.collection("userdata")
                    .document(auth.currentUser!!.uid)
                    .update("bookCheck", Timestamp(Date(shelf.volumesLastUpdated.value))))
                if (vols.size == 0) continue
                for (vol in vols.items) {
                    if (vol.userInfo.isPurchased) {
                        out.add(vol.id)
                    }
                }
            }
            if (HashSet(udata.ownedBooks) != out) {
                Tasks.await(fdb.collection("userdata")
                    .document(auth.currentUser!!.uid)
                    .update("ownedBooks", ArrayList(out)))
            }
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
