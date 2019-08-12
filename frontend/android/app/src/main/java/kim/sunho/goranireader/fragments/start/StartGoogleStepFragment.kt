package kim.sunho.goranireader.fragments.start

import com.stepstone.stepper.VerificationError
import kim.sunho.goranireader.R;
import android.os.Bundle
import android.util.Log
import android.view.ViewGroup
import android.view.LayoutInflater
import android.view.View
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import com.stepstone.stepper.Step
import kim.sunho.goranireader.MainActivity
import kotlinx.android.synthetic.main.fragment_start_google_step.view.*


class StartGoogleStepFragment : Fragment(), Step {
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val mainActivity = activity as MainActivity
        val view = inflater.inflate(R.layout.fragment_start_google_step, container, false)
        view.sign_in_button.setOnClickListener {
            mainActivity.googleSignIn()
        }
        mainActivity.currentUser.observe(this, Observer {

        })
        return view
    }

    override fun verifyStep(): VerificationError? {
        return null
    }

    override fun onSelected() {
        //update UI when selected
    }

    override fun onError(error: VerificationError) {
        //handle error inside of the fragment, e.g. show error on EditText

    }
}