package kim.sunho.goranireader.extensions

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob

abstract class CoroutineViewModel: ViewModel() {
    private val job = SupervisorJob()
    protected val scope = CoroutineScope(Dispatchers.Default + job)
}