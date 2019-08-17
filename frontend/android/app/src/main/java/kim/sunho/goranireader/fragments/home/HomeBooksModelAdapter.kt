package kim.sunho.goranireader.fragments.home

import android.content.Context
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import androidx.databinding.DataBindingUtil
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.Observer
import androidx.navigation.fragment.NavHostFragment.findNavController
import androidx.navigation.fragment.findNavController
import kim.sunho.goranireader.R
import kim.sunho.goranireader.databinding.HomeBooksItemBinding
import kim.sunho.goranireader.fragments.HomeFragmentDirections
import kim.sunho.goranireader.models.Content
import kim.sunho.goranireader.services.ContentService
import kim.sunho.goranireader.ui.BindBaseAdapter
import kim.sunho.goranireader.ui.BindViewHolder
import kim.sunho.goranireader.ui.ErrorToaster
import kim.sunho.goranireader.ui.SingleLayoutAdapter



class HomeBooksViewHolder(binding: HomeBooksItemBinding, private val viewModel: HomeBooksViewModel, private val context: Context): BindViewHolder<HomeBooksItemBinding, Content>(binding) {
    override fun bind(m: Content) {
        binding.model = m
        binding.root.tag = m
        if (m is Content.Downloading) {
            m.complete.observe(this, Observer {
                if (m.currentError != null) {
                    ErrorToaster.toast(context, m.currentError)
                }
                viewModel.fetch()
            })
        }
    }
}

class HomeBooksModelAdapter(val context: Context, var contentList: List<Content>, private val viewModel: HomeBooksViewModel, private var fragment: HomeBooksTabFragment?)
    : BindBaseAdapter<HomeBooksItemBinding, Content, HomeBooksViewHolder>
    ({ binding -> HomeBooksViewHolder(binding, viewModel, context)}) {
    override fun getModelForPosition(position: Int): Content {
       return contentList[position]
    }

    override fun getItemCount(): Int {
        return contentList.count()
    }

    override fun getLayoutIdForPosition(position: Int): Int {
        return when(contentList[position]) {
            is Content.Online -> R.layout.home_books_item
            is Content.Offline -> R.layout.home_books_item
            is Content.Downloading -> R.layout.home_books_item
        }
    }

    override fun setupView(viewType: Int, view: View) {
        view.setOnClickListener {
            val model = it.tag as Content
            if (model is Content.Online) {
                Log.d("aassfaf", model.url)
                ContentService.download(model)
                viewModel.fetch()
            } else if (model is Content.Offline) {
                context.let {
                    val action = HomeFragmentDirections.actionHomeFragmentToReaderFragment(model.bookId)
                    findNavController(fragment!!).navigate(action)
                }
            }
        }
    }

    fun destroy() {
        fragment = null
    }
}