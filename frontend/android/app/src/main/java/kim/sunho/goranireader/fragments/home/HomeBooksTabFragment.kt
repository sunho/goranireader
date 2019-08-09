package kim.sunho.goranireader.fragments.home

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProviders
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import kim.sunho.goranireader.R
import kim.sunho.goranireader.databinding.FragmentHomeBooksTabBinding
import kim.sunho.goranireader.models.Content

class HomeBooksTabFragment: Fragment() {
    private lateinit var model: HomeBooksViewModel
    private lateinit var adapter: HomeBooksModelAdapter

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_home_books_tab, container,false)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        model = ViewModelProviders.of(parentFragment!!)[HomeBooksViewModel::class.java]
        model.fetch()
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val listView = view.findViewById<RecyclerView>(R.id.booksList)
        adapter = HomeBooksModelAdapter(context!!, listOf(), model)
        listView.layoutManager = LinearLayoutManager(context!!, RecyclerView.VERTICAL, false)
        listView.adapter = adapter
        model.contentList.observe(this, Observer<List<Content>> {
            adapter.contentList = it
            listView.post {
                adapter.notifyDataSetChanged()
            }
        })
    }
}