import 'package:flutter/material.dart';
import 'package:project1/utilites/dialogs/generic_dialog.dart';

Future<void> showCannotSHaringEMptyNote(BuildContext context) {
  return showGenericDialog<void>(
    contex: context,
    title: 'Sharing',
    content: 'You Cannot share an empty note!',
    optionsBulider: () => {
      'OK': null,
    },
  );
}
