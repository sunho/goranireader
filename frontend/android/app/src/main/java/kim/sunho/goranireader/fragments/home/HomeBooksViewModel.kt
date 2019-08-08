package kim.sunho.goranireader.fragments.home

import androidx.lifecycle.MediatorLiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import kim.sunho.goranireader.models.Content
import kim.sunho.goranireader.services.ContentService

class HomeBooksViewModel: ViewModel() {
    val contentList: MediatorLiveData<List<Content>> = MediatorLiveData()
    private val _contentList: MutableLiveData<List<Content>> = MutableLiveData()
    init {
        contentList.addSource(_contentList, contentList::setValue)
    }
    fun fetch() {
        _contentList.value = ContentService.fetchContents()
    }
}
