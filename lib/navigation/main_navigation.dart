import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smartcity/pages/ai_assistant_page.dart';
import 'package:smartcity/pages/chat_page.dart';
import 'package:smartcity/pages/home_page.dart';
import 'package:smartcity/pages/news_page.dart';
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
    ChatPage(),
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
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A8A), // Dark blue color
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
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
              icon: Icon(HugeIcons.strokeRoundedBubbleChat),
              label: 'Чат',
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
