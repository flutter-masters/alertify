import 'package:alertify/features/auth/presentation/view/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const Widget authScreen = ProviderScope(
    child: MaterialApp(
      home: AuthScreen(),
    ),
  );

  testWidgets(
    'Auth screen',
    (tester) async {
      // arrange
      TestWidgetsFlutterBinding.ensureInitialized();
      await tester.pumpWidget(
        authScreen,
      );

      // act
      final image = find.byType(Image);
      final buttons = find.byType(ElevatedButton);

      final headerText = find.text('By Flutter Dev, To Flutter Dev');
      final mainIcon = find.byIcon(Icons.arrow_back);

      // assert
      expect(image, findsOneWidget);
      expect(buttons, findsNWidgets(2));

      expect(headerText, findsOneWidget);
      expect(mainIcon, findsNothing);
    },
  );
}
