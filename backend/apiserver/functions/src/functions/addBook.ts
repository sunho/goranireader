import * as functions from 'firebase-functions';
import { admin, db } from '../config/admin';
import * as path from 'path';
import * as os from 'os';
import mkdirp = require('mkdirp-promise');
import { readFileSync, writeFileSync } from 'fs';


const getPublicUrl = (bucketName: string, fileName: string) => `https://storage.googleapis.com/${bucketName}/${fileName}`;


export default functions.region('asia-northeast1').storage.object().onFinalize(async (object) => {
    const filePath = object.name;
    if (!filePath) {
        console.error('invalid file path');
        return null;
    }
    if (path.dirname(filePath) !== 'books') {
        return null;
    }
    const tempLocalFile = path.join(os.tmpdir(), filePath);
    const tempLocalFile2 = path.join(os.tmpdir(), filePath+'2');
    const tempLocalDir = path.dirname(tempLocalFile);
    const bucket = admin.storage().bucket(object.bucket);
    const baseFileName = path.basename(filePath, path.extname(filePath));

    await mkdirp(tempLocalDir);
    await bucket.file(filePath).download({destination: tempLocalFile});
    await bucket.file(filePath).makePublic();

    const data = readFileSync(tempLocalFile);
    const book = JSON.parse(data.toString());
    let url;
    if (book.meta.cover && book.meta.cover.length !== 0) {
        const coverName = 'images/' + baseFileName;
        writeFileSync(tempLocalFile2, new Buffer(book.meta.cover, 'base64'));
        await bucket.upload(tempLocalFile2, {destination: coverName, contentType: book.meta.coverType});
        await bucket.file(coverName).makePublic();
        url = getPublicUrl(bucket.name, coverName);
    }
    
    const bookRef = db.collection('books').doc(book.meta.id);
    const chapters: any = {};
    book.chapters.forEach((chap:any) => {
        if (chap.title) {
            chapters[chap.title as string] = chap.id;
        }
    });
    await bookRef.set({
        title: book.meta.title,
        id: book.meta.id,
        author: book.meta.author,
        chapters: chapters,
        coverType: book.meta.coverType,
        downloadLink: getPublicUrl(bucket.name, filePath),
        cover: url
    });

    return null;
});