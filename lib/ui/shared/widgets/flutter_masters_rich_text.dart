import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../extensions/build_context.dart';

class FlutterMastersRichText extends StatelessWidget {
  const FlutterMastersRichText({
    super.key,
    required this.onTap,
    required this.text,
    required this.secondaryText,
  });
  final VoidCallback onTap;
  final String text;
  final String secondaryText;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: '$text\n',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(
            text: secondaryText,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: context.colorScheme.primary,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
