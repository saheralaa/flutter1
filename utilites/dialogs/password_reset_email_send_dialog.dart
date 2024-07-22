import 'package:flutter/material.dart';
import 'package:project1/utilites/dialogs/generic_dialog.dart';

Future<void> showDialogPasswordResetEmailSending(BuildContext context) {
  return showGenericDialog<void>(
    contex: context,
    title: 'Password Reset',
    content:
        'We have now send you a Password Reset  link. please  check your email for more information.',
    optionsBulider: () => {'ok': null},
  );
}
