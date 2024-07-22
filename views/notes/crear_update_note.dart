import 'package:flutter/material.dart';
import 'package:project1/auth/auth_service.dart';
import 'package:project1/utilites/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:project1/utilites/generics/get_arguments.dart';
import 'package:project1/services/crud/cloud/clloud_note.dart';
import 'package:project1/services/crud/cloud/firebase_cloud_storage.dart';
import 'package:share_plus/share_plus.dart';

class CreatUpdateNoteView extends StatefulWidget {
  const CreatUpdateNoteView({super.key});

  @override
  State<CreatUpdateNoteView> createState() => _CreatUpdateNoteViewState();
}

class _CreatUpdateNoteViewState extends State<CreatUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesServices;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesServices = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  //*function Future because creat note
  Future<CloudNote> creatOrGetExsistingNote(BuildContext context) async {
    final wedgetsNote = context.getArgument<CloudNote>();

    if (wedgetsNote != null) {
      _note = wedgetsNote;
      _textController.text = wedgetsNote.text;
      return wedgetsNote;
    }

    final exsitingNote = _note;
    if (exsitingNote != null) {
      return exsitingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote = await _notesServices.creatNewNote(owneruserId: userId);
    _note = newNote;
    return newNote;
    //***Logic from owner users because take user INformation
    //*because creat note in DataBase
  }

  //**Function to delete note if Text is empty
  void _deleteNoteIfTextISempty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesServices.deleteNote(documentId: note.documentId);
    }
  }

  //*function to update note if text is not empty
  void _saveNotesIFtEXtISNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesServices.updateNote(
        documentid: note.documentId,
        text: text,
      );
    }
  }

  //*function lisner to updates notes and update notes in DataBase
  void _textControllerLisner() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesServices.updateNote(
      documentid: note.documentId,
      text: text,
    );
  }

  //*function by control textControllerLisner remove and add (Lisner)
  void _setupTextControllerLisner() {
    _textController.removeListener(_textControllerLisner);
    _textController.addListener(_textControllerLisner);
  }

  //*dispose is action by default
  @override
  void dispose() {
    _deleteNoteIfTextISempty();
    _saveNotesIFtEXtISNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(' New note '),
        actions: [
          IconButton(
            onPressed: () async {
              final text = _textController.text;
              if (_note == null || text.isEmpty) {
                await showCannotSHaringEMptyNote(context);
              } else {
                Share.share(text);
              }
            },
            icon: const Icon(Icons.share),
          )
        ],
      ),
      body: FutureBuilder(
        future: creatOrGetExsistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerLisner();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                    hintText: 'Start Typing Your Notes...'),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
