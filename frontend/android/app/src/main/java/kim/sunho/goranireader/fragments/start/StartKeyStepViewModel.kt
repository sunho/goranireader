package kim.sunho.goranireader.fragments.start

import android.util.Log
import androidx.databinding.BindingAdapter
import androidx.databinding.InverseBindingAdapter
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import android.widget.TextView
import androidx.lifecycle.MediatorLiveData
import com.google.android.material.textfield.TextInputEditText


class StartKeyStepViewModel: ViewModel() {
    private fun updateFocus() {
        if (number.value?.length == 10) {

        } else if (word2.value?.length == 10) {
            numberFocus.value = true
        } else if (word.value?.length == 10) {
            word2Focus.value = true
        }
    }

    val word: MutableLiveData<String> by lazy {
        MutableLiveData<String>()
    }

    private val wordMeditator = MediatorLiveData<Unit>().apply {
        addSource(word) { wordValue ->
            if (wordValue.length > 10) {
                word.value = wordValue.substring(0,10)
            } else if (wordValue.length == 10) {
                updateFocus()
            }
        }
    }.also { it.observeForever { } }

    val word2: MutableLiveData<String> by lazy {
        MutableLiveData<String>()
    }

    private val word2Meditator = MediatorLiveData<Unit>().apply {
        addSource(word2) { wordValue ->
            if (wordValue.length > 10) {
                word2.value = wordValue.substring(0,10)
            } else if (wordValue.length == 10) {
                updateFocus()
            }
        }
    }.also { it.observeForever { } }

    val number: MutableLiveData<String> by lazy {
        MutableLiveData<String>()
    }

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
        fun requestFocus(view: TextInputEditText, requestFocus: Boolean) {
            if (requestFocus) {
                view.isFocusableInTouchMode = true
                view.requestFocus()
            } else {
                view.isFocusableInTouchMode = false
            }
        }
    }

}
