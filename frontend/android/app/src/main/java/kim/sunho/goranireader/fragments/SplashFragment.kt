package kim.sunho.goranireader.fragments

import android.content.Context
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.navigation.fragment.findNavController
import kim.sunho.goranireader.MainActivity
import kim.sunho.goranireader.R

class SplashFragment : Fragment() {
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? =
        inflater.inflate(R.layout.fragment_splash, container, false)

    override fun onResume() {
        super.onResume()
        Log.d("asdfas","asdfasfs")
        context?.let {
            if ((activity as MainActivity).auth.currentUser == null) {
                findNavController().navigate(R.id.action_splashFragment_to_homeFragment)
            } else {
                findNavController().navigate(R.id.action_splashFragment_to_setupFragment)
            }
        }
    }
}
