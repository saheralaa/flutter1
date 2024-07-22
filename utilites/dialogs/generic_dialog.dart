import 'package:flutter/material.dart';

typedef DialogOptionBulider<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext contex,
  required String title,
  required String content,
  required DialogOptionBulider optionsBulider,
}) {
  final options = optionsBulider();
  return showDialog<T>(
    context: contex,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionstitle) {
          final value = options[optionstitle];
          return TextButton(
            onPressed: () {
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(optionstitle),
          );
        }).toList(),
      );
    },
  );
}
