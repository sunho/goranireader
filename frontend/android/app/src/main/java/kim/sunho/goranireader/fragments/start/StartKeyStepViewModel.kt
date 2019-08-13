package kim.sunho.goranireader.fragments.start

import android.util.Log
import android.view.View
import androidx.databinding.BindingAdapter
import androidx.databinding.InverseBindingAdapter
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import android.widget.TextView
import androidx.lifecycle.MediatorLiveData
import androidx.lifecycle.viewModelScope
import com.google.android.material.textfield.TextInputEditText
import kim.sunho.goranireader.services.DBService
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch


class StartKeyStepViewModel: ViewModel() {
    private val job = SupervisorJob()
    private val scope = CoroutineScope(Dispatchers.Default + job)
    lateinit var db: DBService

    val keylength = 10

    val valid: MutableLiveData<Boolean> = MutableLiveData()

    fun full(): Boolean {
        return word.value?.length == keylength &&
                word2.value?.length == keylength &&
                number.value?.length == keylength
    }

    private fun updateFocus() {
        if (number.value?.length == keylength) {
            validate()
            return
        } else if (word2.value?.length == keylength) {
            numberFocus.value = true
        } else if (word.value?.length == keylength) {
            word2Focus.value = true
        }
    }

    private fun validate() {
        valid.value = false
        scope.launch {
            val ok = db.loginable(word.value ?: "", word2.value ?: "", number.value ?: "")
            launch(Dispatchers.Main.immediate) {
                valid.value = ok
            }
        }
    }

    val word: MutableLiveData<String> by lazy {
        MutableLiveData<String>()
    }

    private val wordMeditator = MediatorLiveData<Unit>().apply {
        addSource(word) { wordValue ->
            if (wordValue.length > keylength) {
                word.value = wordValue.substring(0,keylength)
            } else if (wordValue.length == keylength) {
                updateFocus()
            }
        }
    }.also { it.observeForever { } }

    val word2: MutableLiveData<String> by lazy {
        MutableLiveData<String>()
    }

    private val word2Meditator = MediatorLiveData<Unit>().apply {
        addSource(word2) { wordValue ->
            if (wordValue.length > keylength) {
                word2.value = wordValue.substring(0,keylength)
            } else if (wordValue.length == keylength) {
                updateFocus()
            }
        }
    }.also { it.observeForever { } }

    val number: MutableLiveData<String> by lazy {
        MutableLiveData<String>()
    }

    private val numberMeditator = MediatorLiveData<Unit>().apply {
        addSource(number) { numberValue ->
            if (numberValue.length > keylength) {
                number.value = numberValue.substring(0,keylength)
            } else if (numberValue.length == keylength) {
                updateFocus()
            }
        }
    }.also { it.observeForever { } }

    val wordFocus: MutableLiveData<Boolean> by lazy {
        MutableLiveData<Boolean>()
    }

    val word2Focus: MutableLiveData<Boolean> by lazy {
        MutableLiveData<Boolean>()
    }

    val numberFocus: MutableLiveData<Boolean> by lazy {
        MutableLiveData<Boolean>()
    }

    companion object {
        @JvmStatic
        @BindingAdapter("requestFocus")
        fun requestFocus(view: View, requestFocus: Boolean) {
            if (requestFocus) {
                view.isFocusableInTouchMode = true
                view.requestFocus()
            } else {
                view.isFocusableInTouchMode = false
            }
        }
    }

}
