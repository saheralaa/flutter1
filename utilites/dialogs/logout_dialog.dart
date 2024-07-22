import 'package:flutter/material.dart';
import 'package:project1/utilites/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    contex: context,
    title: 'Log out',
    content: 'are you sure you want to log out?',
    optionsBulider: () => {
      'cancel': false,
      'Log out': true,
    },
  ).then((value) => value ?? false);
}
