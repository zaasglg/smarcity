import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smartcity/pages/ai_assistant_page.dart';
import 'package:smartcity/pages/home_page.dart';
import 'package:smartcity/pages/news_page.dart';
import 'package:smartcity/pages/notifications_page.dart';
import 'package:smartcity/pages/profile_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    NewsPage(),
    AIAssistantPage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color.fromARGB(255, 241, 238, 238),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          enableFeedback: false,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(HugeIcons.strokeRoundedHome03),
              label: 'Главная',
            ),
            const BottomNavigationBarItem(
              icon: Icon(HugeIcons.strokeRoundedNews01),
              label: 'Новости',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFDB5B2B), // Main orange color
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  HugeIcons.strokeRoundedRobot01,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              label: 'AI Помощник',
            ),
            const BottomNavigationBarItem(
              icon: Icon(HugeIcons.strokeRoundedNotification03),
              label: 'Уведемление',
            ),
            const BottomNavigationBarItem(
              icon: Icon(HugeIcons.strokeRoundedUser),
              label: 'Профиль',
            ),
          ],
        ),
      ),
    );
  }
}
