package kim.sunho.goranireader.fragments.home

import android.view.View
import android.widget.ImageView
import androidx.databinding.BindingAdapter
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.bumptech.glide.Glide
import kim.sunho.goranireader.extensions.onUi
import kim.sunho.goranireader.services.DBService
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import java.util.*



class HomeGuideTabViewModel: ViewModel() {
    private val job = SupervisorJob()
    private val scope = CoroutineScope(Dispatchers.Default + job)

    val message: MutableLiveData<String> = MutableLiveData()
    val message2: MutableLiveData<String> = MutableLiveData()
    val message3: MutableLiveData<String> = MutableLiveData()
    val img: MutableLiveData<String> = MutableLiveData()
    val title: MutableLiveData<String> = MutableLiveData()
    val username: MutableLiveData<String> = MutableLiveData()
    var isMission: MutableLiveData<Int> = MutableLiveData()
    lateinit var db: DBService
    fun fetch() {
       scope.launch {
           val clas = db.getClass() ?: return@launch
           if (clas.mission == null) {
               onUi {
                   isMission.value = View.GONE
               }
               return@launch
           }
           if (clas.mission.bookId == null) {
               onUi {
                   isMission.value = View.GONE
               }
               return@launch
           }
           val user = db.getUser() ?: return@launch
           val book = db.getBook(clas.mission.bookId) ?: return@launch
           var diff =  clas.mission.due.toDate().getTime() - Date().getTime();
           val days = diff / (24*60*60*1000)
           diff %= 24 * 60 * 60 * 1000
           val hours = diff / (60*60*1000)
           diff %= 60*60*1000
           val minutes = diff / (60*1000)

           onUi {
               img.value = book.cover ?: ""
               title.value = book.title
               message.value = clas.mission.message
               message2.value = "$days days $hours hours $minutes minutes"
               username.value = user["username"].toString()
               isMission.value = if (clas.mission.due.toDate().after(Date())) View.VISIBLE else View.GONE
           }
       }
    }

    companion object {
        @JvmStatic
        @BindingAdapter("imageUrl")
        fun imageUrl(view: ImageView, url: String?) {
            if (url != null) {
                Glide.with(view).load(url).into(view)
            }
        }
    }
}