package kim.sunho.goranireader.services

import com.google.android.gms.tasks.Tasks
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.google.firebase.firestore.CollectionReference
import com.google.firebase.firestore.DocumentReference
import com.google.firebase.firestore.FirebaseFirestore
import kim.sunho.goranireader.models.Book
import kim.sunho.goranireader.models.Userdata
import kotlinx.coroutines.awaitAll
import java.lang.Exception
import java.lang.IllegalStateException

class DBService(private val db: FirebaseFirestore, private val auth: FirebaseAuth){
    private fun authorize(): FirebaseUser {
        if (auth.currentUser == null) {
            throw IllegalStateException("not authenticated")
        }
        return auth.currentUser!!
    }

    fun getOwnedBooks(): List<Book>? {
        return getUserdata()?.ownedBooks?.flatMap {
            val out = getBook(it)
            if (out == null) {
                return listOf()
            }
            return listOf(out)
        }
    }

    fun bookDoc(id: String): DocumentReference {
        return db.collection("books").document(id)
    }

    fun getBook(id: String): Book? {
        val doc = Tasks.await(bookDoc(id).get())
        if (!doc.exists()) {
            return null
        }
        return doc.toObject(Book::class.java)
    }

    fun userdataDoc(): DocumentReference {
        val user = authorize()
        return db.collection("userdata").document(user.uid)
    }

    fun getUserdata(): Userdata? {
        val doc = Tasks.await(userdataDoc().get())
        if (!doc.exists()) {
            Tasks.await(userdataDoc().set(Userdata()))
            return Userdata()
        }
        return doc.toObject(Userdata::class.java)
    }

    fun loginable(word: String, word2: String, number: String): Boolean {
        val docs = Tasks.await(db.collection("users")
            .whereEqualTo("secretCode", "$word-$word2-$number")
            .get()
        )
        if (docs.size() == 0) {
            return false
        }
        return true
    }

    fun login(word: String, word2: String, number: String): String? {
        val user = authorize()
        val docs = Tasks.await(db.collection("users")
            .whereEqualTo("secretCode", "$word-$word2-$number")
            .get()
        )
        if (docs.size() == 0) {
            return null
        }
        val doc = docs.documents[0]
        if (doc["fireId"].toString() == user.uid) {
            return doc["id"].toString()
        } else if (doc["fireId"].toString() != "") {
            return null
        }
        Tasks.await(db.collection("users").document(doc.id).update("fireId", user.uid))
        return doc["id"].toString()
    }
}