package kim.sunho.goranireader.fragments.start

import com.stepstone.stepper.VerificationError
import kim.sunho.goranireader.R
import android.os.Bundle
import android.view.ViewGroup
import android.view.LayoutInflater
import android.view.View
import androidx.fragment.app.Fragment
import com.stepstone.stepper.Step
import androidx.databinding.DataBindingUtil
import androidx.lifecycle.ViewModelProviders
import kim.sunho.goranireader.databinding.FragmentStartKeyStepBinding


class StartKeyStepFragment : Fragment(), Step {
    private lateinit var model: StartKeyStepViewModel

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val binding: FragmentStartKeyStepBinding = DataBindingUtil.inflate(
            inflater, R.layout.fragment_start_key_step, container, false
        )
        val view = binding.root
        binding.model = model
        binding.lifecycleOwner = this
        return view
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        model = ViewModelProviders.of(parentFragment!!)[StartKeyStepViewModel::class.java]
    }

    override fun verifyStep(): VerificationError? {
        //return null if the user can go to the next step, create a new VerificationError instance otherwise
        return null
    }

    override fun onSelected() {
        //update UI when selected
    }

    override fun onError(error: VerificationError) {
        //handle error inside of the fragment, e.g. show error on EditText

    }
}