import 'package:flutter/material.dart';
import 'package:project1/auth/bloc/auth_bloc.dart';
import 'package:project1/auth/bloc/auth_event.dart';
import 'package:project1/constans/routes.dart';
import 'package:project1/enums/menu_action.dart';
import 'package:project1/auth/auth_service.dart';
import 'package:project1/services/crud/cloud/clloud_note.dart';
import 'package:project1/services/crud/cloud/firebase_cloud_storage.dart';
import 'package:project1/utilites/dialogs/logout_dialog.dart';
import 'package:project1/views/notes/notes_list_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesServices;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesServices = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(' Your Notes '),

          //*Button list for sign out and anther option
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(creatOrUpdateNoteRoute);
              },
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogoutDialog(context);
                    if (shouldLogout) {
                      // ignore: use_build_context_synchronously
                      context.read<AuthBloc>().add(
                            const AuthEventLogout(),
                          );
                    }
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text('Log out'),
                  ),
               ];
              },
            ),
          ],
        ),
        //*هنا بنهيء الصفحه الرءيسيه للنوتس
        body: StreamBuilder(
          stream: _notesServices.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allnotes = snapshot.data as Iterable<CloudNote>;
                  return NotesListView(
                    notes: allnotes,
                    onDeleteNote: (note) async {
                      await _notesServices.deleteNote(
                          documentId: note.documentId);
                    },
                    onTap: (note) {
                      Navigator.of(context).pushNamed(
                        creatOrUpdateNoteRoute,
                        arguments: note,
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}

//*Function to Sign out The user