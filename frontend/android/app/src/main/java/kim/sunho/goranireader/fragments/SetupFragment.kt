package kim.sunho.goranireader.fragments

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import kim.sunho.goranireader.R
import androidx.appcompat.app.AppCompatActivity
import androidx.navigation.fragment.findNavController
import kim.sunho.goranireader.MainActivity
import kotlinx.android.synthetic.main.fragment_setup.view.*


class SetupFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_setup, container, false)
        view.startButton.setOnClickListener { view ->
            findNavController().navigate(R.id.action_setupFragment_to_startFragment)
        }
        return view
    }

    override fun onResume() {
        super.onResume()
        (activity as MainActivity).hideActionBar()
    }

    override fun onStop() {
        super.onStop()
        (activity as MainActivity).showActionBar()
    }
}
