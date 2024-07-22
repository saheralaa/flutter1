// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:project1/extentions/list/filter.dart';
// import 'package:project1/services/crud/crud_Exceptions.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' show join;

// class NotesServices {
// Database? _db;

// List<DataBaseNotes> _notes = [];
// DatabaseUser? _user;

// static final NotesServices _shared = NotesServices._sharedInstans();
// NotesServices._sharedInstans() {
//   _notesStreamController = StreamController<List<DataBaseNotes>>.broadcast(
//     onListen: () {
//       _notesStreamController.sink.add(_notes);
//     },
//   );
// }

// factory NotesServices() => _shared;
// late final StreamController<List<DataBaseNotes>> _notesStreamController;

// Stream<List<DataBaseNotes>> get allNotes =>
//     _notesStreamController.stream.filter((note) {
//       final currentUser = _user;
//       if (currentUser != null) {
//         return note.userId == currentUser.id;
//       } else {
//         throw UserShouldBeSetBeforeReadingAllNodes();
//       }
//     });

// Future<DatabaseUser> getOrCreatUser({
//   required String email,
//   bool setAcurrentUser = true,
// }) async {
//   try {
//     final user = await getUser(email: email);
//     if (setAcurrentUser) {
//       _user = user;
//     }
//     return user;
//   } on CloudNotFindeUser {
//     final createdUser = await creatUser(email: email);
//     if (setAcurrentUser) {
//       _user = createdUser;
//     }
//     return createdUser;
//   } catch (e) {
//     rethrow;
//   }
// }

// Future<void> _cachNotes() async {
//   final allNotes = await getAllNotes();
//   _notes = allNotes.toList();
//   _notesStreamController.add(_notes);
// }

// Future<DataBaseNotes> updateNote({
//   required DataBaseNotes note,
//   required String text,
// }) async {
//   await _ensureDbisOpen();
//   final db = _getDatabaseThrow();
//   await getnote(id: note.id);
//   //*tack note because do operations on notes
//   final updatesCount = await db.update(
//     noteTable,
//     {
//       textColumn: text,
//       isSyncedWithCloudcColumn: 0,
//       //*operation upgreade for notes
//     },
//     where: 'id = ?',
//     whereArgs: [note.id],
//   );
//   //*check on upgreades for notes is true or false
//   if (updatesCount == 0) {
//     throw CloudNotUpdateCount();
//   } else {
//     final updatedNote = await getnote(id: note.id);
//     _notes.removeWhere((note) => note.id == updatedNote.id);
//     _notes.add(updatedNote);
//     _notesStreamController.add(_notes);
//     return updatedNote;
//   }
// }

// Future<Iterable<DataBaseNotes>> getAllNotes() async {
//   await _ensureDbisOpen();
//   final db = _getDatabaseThrow();
//   final note = await db.query(noteTable);
//   //*tack notes because do operation on All notes
//   return note.map((noteRow) => DataBaseNotes.fromRow(noteRow));

//   //*return alaa notes of (Map)
// }

// Future<DataBaseNotes> getnote({required int id}) async {
//   await _ensureDbisOpen();
//   final db = _getDatabaseThrow();
//   final notes = await db.query(
//     noteTable,
//     limit: 1,
//     where: 'id = ?',
//     whereArgs: [id],
//     //*tack note because do opreation is the note
//   );
//   if (notes.isEmpty) {
//     throw CloudNotFindeNote();
//     //*chck note if not empty or No
//   } else {
//     //*if not not empty go to return Note.firest
//     final note = DataBaseNotes.fromRow(notes.first);
//     _notes.removeWhere((note) => note.id == id);
//     _notes.add(note);
//     _notesStreamController.add(_notes);
//     return note;
//   }
// }

// Future<int> deleteAllNotes() async {
//   await _ensureDbisOpen();
//   final db = _getDatabaseThrow();
//   final numperOfDilations = await db.delete(noteTable);
//   _notes = [];
//   _notesStreamController.add(_notes);
//   return numperOfDilations;

//   //*tack DataBase after this delet ALL notes
// }

// Future<void> deleteNote({required int id}) async {
//   await _ensureDbisOpen();
//   final db = _getDatabaseThrow();
//   final deleteCount = await db.delete(
//     noteTable,
//     where: 'id = ?',
//     whereArgs: [id],
//     //*take note because remove thim
//   );
//   if (deleteCount == 0) {
//     throw CloudNotDeleteNode();
//   } else {
//     _notes.removeWhere((note) => note.id == id);
//     _notesStreamController.add(_notes);
//   }
// }

// Future<DataBaseNotes> creatNote({required DatabaseUser owner}) async {
//   await _ensureDbisOpen();
//   //make sure owner exsist in the database with correct
//   final db = _getDatabaseThrow();
//   final dbUser = await getUser(email: owner.email);
//   if (dbUser != owner) {
//     throw CloudNotFindeUser();
//     //*chack if user is Already register from DataBase Or No
//     //*if user is not foundor No
//   }
//   const text = '';
//   //creat the note
//   final noteId = await db.insert(noteTable, {
//     userIdColumn: owner.id,
//     textColumn: text,
//     isSyncedWithCloudcColumn: 1,
//     //*Creat NOTe
//   });

//   final note = DataBaseNotes(
//     id: noteId,
//     userId: owner.id,
//     text: text,
//     isSyncedwithCloud: true,
//     //*integration note from DataBase notes
//   );
//   _notes.add(note);
//   _notesStreamController.add(_notes);
//   return note;
// }

// Future<DatabaseUser> getUser({required String email}) async {
//   await _ensureDbisOpen();
//   final db = _getDatabaseThrow();

//   final result = await db.query(
//     userTable,
//     limit: 1,
//     where: 'email = ?',
//     whereArgs: [email.toLowerCase()],
//   );
//   //*check if THe user is Already in DataBase or NO
//   if (result.isEmpty) {
//     throw CloudNotFindeUser();
//   } else {
//     //*return information From user
//     return DatabaseUser.fromRow(result.first);
//   }
// }

// Future<DatabaseUser> creatUser({required String email}) async {
//   await _ensureDbisOpen();
//   final db = _getDatabaseThrow();
//   //*Take DataBase
//   final result = await db.query(
//     userTable,
//     limit: 1,
//     where: 'email = ?',
//     whereArgs: [email.toLowerCase()],
//   );
//   //*check if user is alarady created in DataBase or No

//   if (result.isNotEmpty) {
//     throw UserAlreadyExsist();
//     //*check from  user if exsist or No
//   }
//   final userId =
//       await db.insert(userTable, {emailColumn: email.toLowerCase()});
//   //* configer user in  DataBase
//   return DatabaseUser(id: userId, email: email);
//   //*return information from user
// }

// Future<void> deletUser({required String email}) async {
//   await _ensureDbisOpen();
//   final db = _getDatabaseThrow();
//   //*take the Database
//   final deletedcount = await db.delete(
//     userTable,
//     where: 'email = ?',
//     whereArgs: [email.toLowerCase()],
//   );
//   //* tack information of user

//   if (deletedcount != 1) {
//     throw CloudNotDELetUserException();
//   }
// }

// Database _getDatabaseThrow() {
//   final db = _db;
//   if (db == null) {
//     //*check Database opened or No
//     throw DataBaseIsNotOpenException();
//   } else {
//     //*return Database
//     return db;
//   }
// }

// Future<void> close() async {
//   final db = _db;
//   if (db == null) {
//     //*chekc Database is equal to null ?
//     throw DataBaseIsNotOpenException();
//   } else {
//     //*close Database
//     await db.close();
//     _db = null;
//   }
// }

// Future<void> _ensureDbisOpen() async {
//   try {
//     await open();
//   } on DataBaseISAlreadyOpenExeption {
//     //empty
//   }
// }

// Future<void> open() async {
//   if (_db != null) {
//     throw DataBaseISAlreadyOpenExeption();
//     //*check operation of database is opened or NO
//   }
//   //*opened Database
//   try {
//     final docsPath = await getApplicationDocumentsDirectory();
//     final dbPath = join(docsPath.path, dbName);
//     final db = await openDatabase(dbPath);
//     _db = db;
//     //**********creat USER tABLE*************************/
//     await db.execute(creatUserTable);
//     //*********CEREAT NOTES TABLE************ */
//     await db.execute(creatNotesTable);
//     await _cachNotes();
//   } on MissingPlatformDirectoryException {
//     throw UnableTogetDecumentsDirectlyException();
//   }
// }
// }

// @immutable
// class DatabaseUser {
// final int id;
// final String email;

// const DatabaseUser({
//   required this.id,
//   required this.email,
// });
// DatabaseUser.fromRow(Map<String, Object?> map)
//     : id = map[idColumn] as int,
//       email = map[emailColumn] as String;

// @override
// String toString() => 'Person , Id = $id , email = $email';

// @override
// bool operator ==(covariant DatabaseUser other) => id == other.id;

// @override
// int get hashCode => id.hashCode;
// }

// class DataBaseNotes {
// final int id;
// final int userId;
// final String text;
// final bool isSyncedwithCloud;

// DataBaseNotes({
//   required this.id,
//   required this.userId,
//   required this.text,
//   required this.isSyncedwithCloud,
// });
// DataBaseNotes.fromRow(Map<String, Object?> map)
//     : id = map[idColumn] as int,
//       userId = map[userIdColumn] as int,
//       text = map[textColumn] as String,
//       isSyncedwithCloud =
//           (map[isSyncedWithCloudcColumn] as int) == 1 ? true : false;

// @override
// String toString() =>
//     'Note, Id = $id, UserId = $userId,isSyncedWithcloud = $isSyncedwithCloud,text = $text';

// @override
// bool operator ==(covariant DataBaseNotes other) => id == other.id;

// @override
// int get hashCode => id.hashCode;
// }

// const dbName = 'notes.db';
// const noteTable = 'note';
// const userTable = 'user';
// const idColumn = 'id';
// const emailColumn = 'email';
// const userIdColumn = 'user_id';
// const textColumn = 'text';
// const isSyncedWithCloudcColumn = 'is_synced_with_cloud';

// const creatUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
//   "id"	INTEGER NOT NULL,
//   "email"	TEXT NOT NULL UNIQUE,
//   PRIMARY KEY("id" AUTOINCREMENT)
//     );''';

// const creatNotesTable = '''CREATE TABLE IF NOT EXISTS "note" (
// "id"	INTEGER NOT NULL,
// "user_id"	INTEGER NOT NULL,
// "text"	TEXT,
// "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
// PRIMARY KEY("id" AUTOINCREMENT),
// FOREIGN KEY("user_id") REFERENCES "user"("id")
// );''';
