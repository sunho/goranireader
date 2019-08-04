package kim.sunho.goranireader.fragments.start

import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.activity.OnBackPressedCallback
import kim.sunho.goranireader.MainActivity
import kim.sunho.goranireader.R
import com.stepstone.stepper.StepperLayout



class StartFragment : Fragment() {
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
        stepperLayout!!.adapter = StepperAdapter(childFragmentManager, this.context!!)
    }


    override fun onResume() {
        super.onResume()
        val activity =  (activity as MainActivity)
        activity.hideActionBar()
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
        activity.showActionBar()
        activity.onBackPressedListener = null
    }
}
