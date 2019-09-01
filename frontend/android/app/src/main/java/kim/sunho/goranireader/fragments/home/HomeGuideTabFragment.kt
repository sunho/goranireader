package kim.sunho.goranireader.fragments.home

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProviders
import kim.sunho.goranireader.R
import kim.sunho.goranireader.databinding.FragmentHomeGuideTabBinding
import kim.sunho.goranireader.extensions.main

class HomeGuideTabFragment: Fragment() {
    private lateinit var viewModel: HomeGuideTabViewModel

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val binding: FragmentHomeGuideTabBinding = DataBindingUtil.inflate(
            inflater, R.layout.fragment_home_guide_tab, container, false
        )
        val view = binding.root
        binding.model = viewModel
        binding.lifecycleOwner = this
        return view
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        viewModel = ViewModelProviders.of(parentFragment!!)[HomeGuideTabViewModel::class.java]
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        viewModel.db = activity.main().db
        viewModel.fetch()
    }
}