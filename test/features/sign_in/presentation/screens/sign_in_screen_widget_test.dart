import 'package:alertify/features/sign_in/presentation/view/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const Widget signInScreen = ProviderScope(
    child: MaterialApp(
      home: SignInScreen(),
    ),
  );

  testWidgets(
    'Screen should have 2 TextFormField',
    (tester) async {
      // Arrange
      await tester.pumpWidget(signInScreen);

      // Act
      final textFormFieldFinder = find.byType(TextFormField);

      // Assert
      expect(textFormFieldFinder, findsNWidgets(2));
    },
  );

  testWidgets(
    'Screen should have 1 ElevatedButton',
    (tester) async {
      // Arrange
      await tester.pumpWidget(signInScreen);

      // Act
      final elevatedButtonFinder = find.byType(ElevatedButton);

      // Assert
      expect(elevatedButtonFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Should show error message validation when TextFormFields are empty',
    (tester) async {
      await tester.pumpWidget(signInScreen);

      final textFormFieldFinder = find.byType(TextFormField);
      final elevatedButtonFinder = find.byType(ElevatedButton);

      expect(textFormFieldFinder, findsNWidgets(2));
      expect(elevatedButtonFinder, findsOneWidget);

      await tester.tap(elevatedButtonFinder);
      await tester.pumpAndSettle();

      final emailErrorTextFinder = find.text('Email is required.');
      final passwordErrorTextFinder = find.text('Password is required.');

      expect(emailErrorTextFinder, findsOne);
      expect(passwordErrorTextFinder, findsOne);
    },
  );
}
