package kim.sunho.goranireader.fragments

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import kim.sunho.goranireader.MainActivity
import kim.sunho.goranireader.R
import com.stepstone.stepper.StepperLayout
import kim.sunho.goranireader.fragments.start.StepperAdapter
import android.widget.Toast
import androidx.navigation.fragment.findNavController
import com.stepstone.stepper.VerificationError

class StartFragment : Fragment(), StepperLayout.StepperListener {
    private var stepperLayout: StepperLayout? = null

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        return inflater.inflate(R.layout.fragment_start, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        stepperLayout = view.findViewById(R.id.stepperLayout) as StepperLayout
        stepperLayout!!.adapter =
            StepperAdapter(childFragmentManager, this.context!!)
        stepperLayout!!.setListener(this)

    }

    override fun onResume() {
        super.onResume()
        val activity =  (activity as MainActivity)
        activity.onBackPressedListener = object:  MainActivity.OnBackPressedListener {
            override fun doBack(): Boolean {
                val layout = stepperLayout?: return true
                if (layout.currentStepPosition  == 0) {
                    return true
                }
                layout.onBackClicked()
                return false
            }
        }
    }

    override fun onStop() {
        super.onStop()
        val activity =  (activity as MainActivity)
        activity.onBackPressedListener = null
    }

    override fun onCompleted(completeButton: View) {
        findNavController().navigate(R.id.action_startFragment_to_homeFragment)
    }

    override fun onError(verificationError: VerificationError) {
    }

    override fun onStepSelected(newStepPosition: Int) {
    }

    override fun onReturn() {

    }
}
