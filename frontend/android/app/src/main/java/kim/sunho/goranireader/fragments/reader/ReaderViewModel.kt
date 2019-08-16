package kim.sunho.goranireader.fragments.reader

import androidx.lifecycle.ViewModel
import kim.sunho.goranireader.models.BookyBook
import kim.sunho.goranireader.models.Sentence

class ReaderViewModel: ViewModel() {
    var book: BookyBook? = null
    var readingChapter: Int = 0
}