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
import com.bumptech.glide.Glide
import kim.sunho.goranireader.R
import kim.sunho.goranireader.databinding.HomeBooksItemBinding
import kim.sunho.goranireader.fragments.HomeFragmentDirections
import kim.sunho.goranireader.models.Content
import kim.sunho.goranireader.services.ContentService
import kim.sunho.goranireader.ui.BindBaseAdapter
import kim.sunho.goranireader.ui.BindViewHolder
import kim.sunho.goranireader.ui.ErrorToaster
import kim.sunho.goranireader.ui.SingleLayoutAdapter
import android.graphics.BitmapFactory
import android.graphics.Bitmap
import android.util.Base64
import android.widget.ImageView


class HomeBooksViewHolder(binding: HomeBooksItemBinding, private val viewModel: HomeBooksViewModel, private val context: Context): BindViewHolder<HomeBooksItemBinding, Content>(binding) {
    override fun bind(m: Content) {
        binding.model = m
        binding.root.tag = m
        val view = binding.root
        val model = view.tag as Content
        if (m is Content.Online) {
            if (model.img != null) {
                Glide.with(view).load(model.img).into(view.findViewById(R.id.imageView))
            }
        } else if (m is Content.Offline) {
            if (model.img != null) {
                val decodedString = Base64.decode(model.img, Base64.DEFAULT)
                val decodedByte = BitmapFactory.decodeByteArray(decodedString, 0, decodedString.size)
                (view.findViewById(R.id.imageView) as ImageView).setImageBitmap(decodedByte)
            }
        } else if (m is Content.Downloading) {
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