package kim.sunho.goranireader.services

import com.google.android.gms.tasks.Tasks
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.google.firebase.firestore.*
import io.realm.Realm
import kim.sunho.goranireader.models.Book
import kim.sunho.goranireader.models.StudentClass
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

    fun getBooks(): List<Book> {
        val res = Tasks.await(db.collection("books").get())
        return res.documents.map {
            it.toObject(Book::class.java)!!
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

    fun dataResult(): DocumentReference? {
        val user = getUser() ?: return null
        val raw = user["classId"] ?: return null
        val classId = raw.toString()
        return db.collection("dataResult").document(classId)
            .collection("clientComputed").document(user.id)
    }

    fun userdataDoc(): DocumentReference? {
        val user = getUser() ?: return null
        return db.collection("userdata").document(user.id)
    }

    fun getUserdata(): Userdata? {
        val userDoc = userdataDoc() ?: return null
        val doc = Tasks.await(userDoc.get())
        if (!doc.exists()) {
            Tasks.await(userDoc.set(Userdata()))
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

    fun getUser(): DocumentSnapshot? {
        val user = authorize()
        val res = Tasks.await(db.collection("users").whereEqualTo("fireId", user.uid).get())
        if (res.size() == 0) {
            return null
        }
        return res.documents[0]
    }

    fun getClass(): StudentClass? {
        val user = getUser() ?: return null
        val raw = user["classId"] ?: return null
        val classId = raw.toString()
        val out = Tasks.await(db.collection("classes").document(classId).get())
        return out.toObject(StudentClass::class.java)
    }

    fun login(word: String, word2: String, number: String): Pair<String, Boolean>? {
        val user = authorize()
        val docs = Tasks.await(db.collection("users")
            .whereEqualTo("secretCode", "$word-$word2-$number")
            .get()
        )
        if (docs.size() == 0) {
            return null
        }
        val doc = docs.documents[0]
        val new = doc["fireId"] == null || doc["fireId"].toString() == user.uid
        val obj = HashMap<String, String>();
        obj["userId"] = doc.id
        Tasks.await(db.collection("fireUsers").document(user.uid).set(obj))
        Tasks.await(db.collection("users").document(doc.id).update("fireId", user.uid))
        return Pair(doc.id, new)
    }
}