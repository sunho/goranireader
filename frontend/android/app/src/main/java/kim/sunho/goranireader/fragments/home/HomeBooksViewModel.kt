package kim.sunho.goranireader.fragments.home

import androidx.lifecycle.MediatorLiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import kim.sunho.goranireader.models.Book
import kim.sunho.goranireader.models.Content
import kim.sunho.goranireader.services.ContentService
import kim.sunho.goranireader.services.DBService
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch

class HomeBooksViewModel: ViewModel() {
    private val job = SupervisorJob()
    private val scope = CoroutineScope(Dispatchers.Default + job)

    val contentList: MediatorLiveData<List<Content>> = MediatorLiveData()
    private val _contentList: MutableLiveData<List<Content>> = MutableLiveData()
    lateinit var db: DBService
    init {
        contentList.addSource(_contentList, contentList::setValue)
    }
    fun fetch() {
        val newList = ContentService.fetchContents()
        scope.launch {
            val books = db.getOwnedBooks() ?: listOf()
            launch(Dispatchers.Main.immediate) {
                _contentList.value = newList + books.map { it.toContent() }
            }
        }

    }
}