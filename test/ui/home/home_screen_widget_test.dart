import 'package:alertify/features/friendship/presentation/view/friends_tab.dart';
import 'package:alertify/features/profile/presentation/view/profile_tab.dart';
import 'package:alertify/ui/screens/home/home_screen.dart';
import 'package:alertify/ui/screens/home/tabs/home/home_tab.dart';
import 'package:alertify/ui/screens/home/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const Widget homeScreen = ProviderScope(
    child: MaterialApp(
      home: HomeScreen(),
    ),
  );

  testWidgets(
    'Should show HomeTab when HomeScreen initializes',
    (tester) async {
      await tester.pumpWidget(homeScreen);

      final homeTabFinder = find.byType(HomeTab);

      expect(homeTabFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Should show HomeBottomNavBar when HomeScreen initializes',
    (tester) async {
      await tester.pumpWidget(homeScreen);

      final homeBottomNavigationBarFinder =
          find.byType(HomeBottomNavigationBar);

      expect(homeBottomNavigationBarFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Should find 4 Icons inside homeBottomNavigationBar',
    (tester) async {
      await tester.pumpWidget(homeScreen);

      final homeIconFinder = find.byIcon(Icons.home);
      final peopleIconFinder = find.byIcon(Icons.people);
      final notificationsIconFinder = find.byIcon(Icons.notifications);
      final personIconFinder = find.byIcon(Icons.person);

      expect(homeIconFinder, findsOneWidget);
      expect(peopleIconFinder, findsOneWidget);
      expect(notificationsIconFinder, findsOneWidget);
      expect(personIconFinder, findsOneWidget);
    },
  );

  testWidgets(
    'When tap on home icon should show HomeTab',
    (tester) async {
      await tester.pumpWidget(homeScreen);

      final peopleIconFinder = find.byIcon(Icons.people);
      final homeIconFinder = find.byIcon(Icons.home);
      final homeTabFinder = find.byType(HomeTab);
      final friendsTabFinder = find.byType(FriendsTab);

      expect(peopleIconFinder, findsOneWidget);
      expect(homeTabFinder, findsOneWidget);
      expect(friendsTabFinder, findsNothing);

      await tester.tap(peopleIconFinder);
      await tester.pumpAndSettle();

      expect(friendsTabFinder, findsOneWidget);
      expect(homeTabFinder, findsNothing);

      await tester.tap(homeIconFinder);
      await tester.pumpAndSettle();

      expect(friendsTabFinder, findsNothing);
      expect(homeTabFinder, findsOneWidget);
    },
  );

  testWidgets(
    'When tap on people icon should show FriendsTab',
    (tester) async {
      await tester.pumpWidget(homeScreen);

      final peopleIconFinder = find.byIcon(Icons.people);
      final homeTabFinder = find.byType(HomeTab);
      final friendsTabFinder = find.byType(FriendsTab);

      expect(peopleIconFinder, findsOneWidget);
      expect(homeTabFinder, findsOneWidget);
      expect(friendsTabFinder, findsNothing);

      await tester.tap(peopleIconFinder);
      await tester.pumpAndSettle();

      expect(friendsTabFinder, findsOneWidget);
      expect(homeTabFinder, findsNothing);
    },
  );

  testWidgets(
    'When tap on person icon should show ProfileTab',
    (tester) async {
      await tester.pumpWidget(homeScreen);

      final personIconFinder = find.byIcon(Icons.person);
      final homeTabFinder = find.byType(HomeTab);
      final profileTabFinder = find.byType(ProfileTab);

      expect(personIconFinder, findsOneWidget);
      expect(homeTabFinder, findsOneWidget);
      expect(profileTabFinder, findsNothing);

      await tester.tap(personIconFinder);
      await tester.pumpAndSettle();

      expect(profileTabFinder, findsOneWidget);
      expect(homeTabFinder, findsNothing);
    },
  );

  testWidgets(
    'When swipe from middle to left, should change to FriendsTab',
    (tester) async {
      await tester.pumpWidget(homeScreen);

      final homeTabFinder = find.byType(HomeTab);
      final friendsTabFinder = find.byType(FriendsTab);

      expect(homeTabFinder, findsOneWidget);
      expect(friendsTabFinder, findsNothing);

      await tester.drag(
        homeTabFinder,
        const Offset(-500, 0),
      );
      await tester.pumpAndSettle();

      expect(homeTabFinder, findsNothing);
      expect(friendsTabFinder, findsOneWidget);
    },
  );
}
