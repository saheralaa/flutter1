import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/services/crud/cloud/clloud_note.dart';
import 'package:project1/services/crud/cloud/cloud_storage_constans.dart';
import 'package:project1/services/crud/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  //? Document description of the cloud storage
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CloudNotDeleteAllNotesException();
    }
  }

  Future<void> updateNote({
    required documentid,
    required text,
  }) async {
    try {
      await notes.doc(documentid).update({textFieldName: text});
    } catch (e) {
      throw CloudNotUpdateNoteException();
    }
  }

  //? getting all notes from User
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    final allnotes = notes
        .where(ownerUserIdFeildName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapShot(doc)));

    return allnotes;
  }

  //?Creat New Node
  Future<CloudNote> creatNewNote({required String owneruserId}) async {
    final document = await notes.add({
      ownerUserIdFeildName: owneruserId,
      textFieldName: '',
    });
    final fetshedNote = await document.get();
    return CloudNote(
      documentId: fetshedNote.id,
      ownerUserId: owneruserId,
      text: '',
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage.__sharedistans();
  FirebaseCloudStorage.__sharedistans();
  factory FirebaseCloudStorage() => _shared;
}
