package kim.sunho.goranireader.fragments

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.widget.Toolbar
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentStatePagerAdapter
import androidx.viewpager.widget.ViewPager
import com.google.android.material.tabs.TabLayout
import kim.sunho.goranireader.MainActivity
import kim.sunho.goranireader.R
import kim.sunho.goranireader.fragments.home.HomeBooksTabFragment
import kim.sunho.goranireader.fragments.home.HomeConfigTabFragment
import kim.sunho.goranireader.fragments.home.HomeGuideTabFragment
import java.lang.IllegalArgumentException

class HomeFragment: Fragment() {
    private lateinit var toolbar: Toolbar
    private lateinit var adapter: HomeCollectionAddapter
    private lateinit var viewPager: ViewPager

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_home, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        adapter = HomeCollectionAddapter(childFragmentManager)
        toolbar = view.findViewById(R.id.toolbar)
        toolbar.title = "Gorani Reader"
        (activity as MainActivity).setSupportActionBar(toolbar);
        viewPager = view.findViewById(R.id.pager)
        viewPager.adapter = adapter
        val tabLayout: TabLayout = view.findViewById(R.id.tab_layout)
        tabLayout.setupWithViewPager(viewPager)
    }

    class HomeCollectionAddapter(fm: FragmentManager) : FragmentStatePagerAdapter(fm) {

        override fun getCount(): Int  = 3

        override fun getItem(i: Int): Fragment {
            return when (i) {
                0 -> HomeGuideTabFragment()
                1 -> HomeBooksTabFragment()
                2 -> HomeConfigTabFragment()
                else -> throw IllegalArgumentException("wtf")
            }
        }

        override fun getPageTitle(position: Int): CharSequence {
            return when (position) {
                0 -> "Guide"
                1 -> "Books"
                2 -> "Settings"
                else -> throw IllegalArgumentException("wtf")
            }
        }
    }

}