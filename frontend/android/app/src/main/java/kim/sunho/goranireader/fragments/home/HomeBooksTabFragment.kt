package kim.sunho.goranireader.fragments.home

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProviders
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import kim.sunho.goranireader.R
import kim.sunho.goranireader.extensions.main
import kim.sunho.goranireader.models.Content

class HomeBooksTabFragment: Fragment() {
    private lateinit var viewModel: HomeBooksViewModel
    private lateinit var adapter: HomeBooksModelAdapter

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_home_books_tab, container,false)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        viewModel = ViewModelProviders.of(parentFragment!!)[HomeBooksViewModel::class.java]
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        viewModel.db = activity.main().db
        viewModel.fetch()
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val listView = view.findViewById<RecyclerView>(R.id.booksList)
        adapter = HomeBooksModelAdapter(context!!, listOf(), viewModel, this)
        listView.layoutManager = LinearLayoutManager(context!!, RecyclerView.VERTICAL, false)
        listView.adapter = adapter
        viewModel.contentList.observe(this, Observer<List<Content>> {
            adapter.contentList = it
            listView.post {
                adapter.notifyDataSetChanged()
            }
        })
    }

    override fun onDestroyView() {
        super.onDestroyView()
        adapter.destroy()
    }
}