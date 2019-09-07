package kim.sunho.goranireader.fragments

import android.content.Context
import android.net.Uri
import android.os.Bundle
import android.text.Html
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import androidx.navigation.fragment.findNavController
import kim.sunho.goranireader.R

class QuizFragment : Fragment() {
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_quiz, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val textView: TextView = view.findViewById(R.id.textView10)
        textView.setText(Html.fromHtml("When she got to the door, she found she had forgotten the little golden key, and when she went back to the table for it, she found she could not possibly <b>reach</b> it: she could see it quite plainly through the glass and she tried her best to climb up one of the legs of the table, but it was too slippery, and when she had tired herself out with trying, the poor little thing sat down and cried."))
        val button: Button = view.findViewById(R.id.submit_button)
        button.setOnClickListener {
            context?.let {
                findNavController().navigateUp()
            }
        }
    }
}
