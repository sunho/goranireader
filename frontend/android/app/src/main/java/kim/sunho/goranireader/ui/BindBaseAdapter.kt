package kim.sunho.goranireader.ui

import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView


abstract class BindBaseAdapter<T, M, H>(private val factory: (binding: T) -> H) : RecyclerView.Adapter<H>()
    where T: ViewDataBinding,
          H: BindViewHolder<T, M> {
    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): H {
        val layoutInflater = LayoutInflater.from(parent.context)
        val binding = DataBindingUtil.inflate<ViewDataBinding>(
            layoutInflater, viewType, parent, false
        ) as T
        val out = factory(binding)
        binding.lifecycleOwner = out
        setupView(viewType, binding.root)
        return out
    }

    override fun onBindViewHolder(
        holder: H,
        position: Int
    ) {
        val obj = getModelForPosition(position)
        holder.bind(obj)
    }

    override fun getItemViewType(position: Int): Int {
        return getLayoutIdForPosition(position)
    }

    override fun onViewAttachedToWindow(holder: H) {
        super.onViewAttachedToWindow(holder)
        holder.markAttach()
    }

    override fun onViewDetachedFromWindow(holder: H) {
        super.onViewDetachedFromWindow(holder)
        holder.markDetach()
    }

    open fun setupView(viewType: Int, view: View) {}

    protected abstract fun getModelForPosition(position: Int): M

    protected abstract fun getLayoutIdForPosition(position: Int): Int
}