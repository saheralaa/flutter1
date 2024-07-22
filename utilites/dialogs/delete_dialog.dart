import 'package:flutter/material.dart';
import 'package:project1/utilites/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    contex: context,
    title: 'Delete',
    content: 'are you sure you want to delete this item?',
    optionsBulider: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
