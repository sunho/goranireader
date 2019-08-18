package kim.sunho.goranireader.extensions

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

class AssetDatabase(private val context: Context, private val dbName: String) {
    fun openDatabase(): SQLiteDatabase {
        val dbFile = context.getDatabasePath(dbName)


        if (!dbFile.exists()) {
            try {
                val checkDB = context.openOrCreateDatabase(dbName, Context.MODE_PRIVATE, null)

                checkDB?.close()
                copyDatabase(dbFile)
            } catch (e: IOException) {
                throw RuntimeException("Error creating source database", e)
            }

        }
        return SQLiteDatabase.openDatabase(dbFile.path, null, SQLiteDatabase.OPEN_READWRITE)
    }

    private fun copyDatabase(dbFile: File) {
        val f = context.assets.open(dbName)
        val os = FileOutputStream(dbFile)

        val buffer = ByteArray(1024)
        while (f.read(buffer) > 0) {
            os.write(buffer)
        }

        os.flush()
        os.close()
        f.close()
    }
}