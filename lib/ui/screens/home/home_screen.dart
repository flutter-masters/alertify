import 'package:flutter/material.dart';

import 'tabs/friends/friends_tab.dart';
import 'tabs/home/home_tab.dart';
import 'tabs/profile/profile_tab.dart';
import 'tabs/requests/requests_tab.dart';
import 'widgets/bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String route = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 4, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: const [
          HomeTab(),
          FriendsTab(),
          RequestsTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: _tabController,
        builder: (_, __) => HomeBottomNavigationBar(
          currentIndex: _tabController.index,
          onTap: (index) => _tabController.animateTo(index),
        ),
      ),
    );
  }
}
