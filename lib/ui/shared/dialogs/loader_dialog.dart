import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../extensions/build_context.dart';

Future<T> showLoader<T>(BuildContext context, Future<T> future) async {
  showDialog(
    context: context,
    builder: (_) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    ),
  );
  final result = await future;
  if (context.mounted) {
    context.pop();
  }
  return result;
}

(Completer<void>, Future<T?>) showLoaderComplete<T>(BuildContext context) {
  Completer<void> completer = Completer();

  final future = showDialog<T>(
    context: context,
    builder: (_) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    ),
  );

  completer.future.then((_) {
    if (context.mounted) {
      context.pop();
    }
  });

  return (completer, future);
}
