import 'package:flutter/material.dart' show immutable;

typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String text);

@immutable
class LoadingScreenControlar {
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;

  const LoadingScreenControlar({
    required this.close,
    required this.update,
  });
}

