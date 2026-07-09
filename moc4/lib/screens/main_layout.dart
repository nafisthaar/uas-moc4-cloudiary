import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'archive_screen.dart';
import 'insights_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
  HomeScreen(), 
  const ArchiveScreen(),
  const InsightsScreen(),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: CloudiaryTheme.lightBorder, width: 1.0),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index; 
            });
          },
          backgroundColor: CloudiaryTheme.lightCardBg,
          selectedItemColor: CloudiaryTheme.moodStyles['Calm']?['text'], 
          unselectedItemColor: CloudiaryTheme.lightMutedText, 
          selectedLabelStyle: const TextStyle(fontFamily: 'DMSans', fontSize: 12, fontWeight: FontWeight.w500),
          unselectedLabelStyle: const TextStyle(fontFamily: 'DMSans', fontSize: 12),
          type: BottomNavigationBarType.fixed, 
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined),
              activeIcon: Icon(Icons.archive_rounded),
              label: 'Archive',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart_rounded),
              label: 'Insights',
            ),
          ],
        ),
      ),
    );
  }
}