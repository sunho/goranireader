package kim.sunho.goranireader.extensions

import androidx.fragment.app.Fragment
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob

abstract class CoroutineFragment: Fragment() {
    private val job = SupervisorJob()
    protected val scope = CoroutineScope(Dispatchers.Default + job)
}