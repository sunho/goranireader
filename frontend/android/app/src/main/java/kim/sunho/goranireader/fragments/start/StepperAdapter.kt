package kim.sunho.goranireader.fragments.start

import android.content.Context
import android.util.Log
import androidx.annotation.IntRange
import androidx.fragment.app.FragmentManager
import com.stepstone.stepper.Step
import com.stepstone.stepper.adapter.AbstractFragmentStepAdapter
import com.stepstone.stepper.viewmodel.StepViewModel
import java.lang.IllegalArgumentException


class StepperAdapter(fm: FragmentManager, context: Context) : AbstractFragmentStepAdapter(fm, context) {
    override fun createStep(@IntRange(from=0, to=3) position: Int): Step {
        return when (position) {
            0 -> StartMainStepFragement()
            1 -> StartGoogleStepFragment()
            2 -> StartPrepareStepFragment()
            3 -> StartKeyStepFragment()
            else -> throw IllegalArgumentException("wtf")
        }
    }

    override fun getCount(): Int {
        return 4
    }

    override fun getViewModel(@IntRange(from=0) position: Int): StepViewModel {
        return StepViewModel.Builder(context)
            .create()
    }
}