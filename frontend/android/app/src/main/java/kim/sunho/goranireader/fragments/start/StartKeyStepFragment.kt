package kim.sunho.goranireader.fragments.start

import com.stepstone.stepper.VerificationError
import kim.sunho.goranireader.R
import android.os.Bundle
import android.util.Log
import android.view.ViewGroup
import android.view.LayoutInflater
import android.view.View
import androidx.fragment.app.Fragment
import com.stepstone.stepper.Step
import androidx.databinding.DataBindingUtil
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProviders
import com.google.android.material.snackbar.Snackbar
import kim.sunho.goranireader.MainActivity
import kim.sunho.goranireader.databinding.FragmentStartKeyStepBinding
import kim.sunho.goranireader.extensions.main
import kotlinx.android.synthetic.main.fragment_start_key_step.view.*
import kotlinx.coroutines.*
import kotlin.coroutines.CoroutineContext


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


        model.valid.observe(this, Observer {
            if (it) {
                activity.main().hideSoftKeyboard()
            }
        })
        return view
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        model = ViewModelProviders.of(parentFragment!!)[StartKeyStepViewModel::class.java]
        model.db = activity.main().db
    }

    override fun verifyStep(): VerificationError? {
        if (model.valid.value == true && model.full()) {
            return null
        }
        return VerificationError("Not valid secret code")
    }

    override fun onSelected() {

    }

    override fun onError(error: VerificationError) {
        Snackbar.make(activity.main().mainLayout, error.errorMessage, Snackbar.LENGTH_SHORT).show()
    }
}