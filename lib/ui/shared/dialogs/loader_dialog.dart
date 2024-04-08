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
