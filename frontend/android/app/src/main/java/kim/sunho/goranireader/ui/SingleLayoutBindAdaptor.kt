package kim.sunho.goranireader.ui

import androidx.databinding.ViewDataBinding

abstract class SingleLayoutAdapter<T, M, H>
    (private val layoutId: Int, factory: (binding: T) -> H)
    : BindBaseAdapter<T, M, H>(factory)
    where T: ViewDataBinding,
          H: BindViewHolder<T, M> {
    override fun getLayoutIdForPosition(position: Int): Int {
        return layoutId
    }
}