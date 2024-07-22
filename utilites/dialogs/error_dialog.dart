import 'package:flutter/material.dart';
import 'package:project1/utilites/dialogs/generic_dialog.dart';

Future<void> showErorrDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    contex: context,
    title: 'An error occcured ',
    content: text,
    optionsBulider: () => {
      'ok': null,
    },
  );
}
