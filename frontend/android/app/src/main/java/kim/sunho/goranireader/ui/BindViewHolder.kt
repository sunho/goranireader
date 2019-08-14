package kim.sunho.goranireader.ui

import android.util.Log
import android.view.View
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LifecycleRegistry
import androidx.recyclerview.widget.RecyclerView


abstract class BindViewHolder<T, M>
    (protected val binding: T) : RecyclerView.ViewHolder(binding.getRoot()), LifecycleOwner
    where T: ViewDataBinding {
    abstract fun bind(m: M)

    private val lifecycleRegistry = LifecycleRegistry(this)

    init {
        lifecycleRegistry.currentState = Lifecycle.State.INITIALIZED
    }

    fun markAttach() {
        Log.d("assadf", "asfsadf")
        lifecycleRegistry.currentState = Lifecycle.State.STARTED
    }

    fun markDetach() {
        Log.d("assadf", "detstory")
        lifecycleRegistry.currentState = Lifecycle.State.DESTROYED
    }

    override fun getLifecycle(): Lifecycle {
        return lifecycleRegistry
    }
}
