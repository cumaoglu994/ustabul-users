import 'package:flutter/material.dart';
import 'package:ustabuul/screens/navigation_Screens/categories_srceen.dart';
import 'package:ustabuul/screens/navigation_Screens/home_srceen.dart';
import 'package:ustabuul/screens/navigation_Screens/notification_srceen.dart';
import 'package:ustabuul/screens/navigation_Screens/tasks_screen.dart';
import 'package:ustabuul/screens/navigation_Screens/user_screen.dart';

class MainScreen extends StatefulWidget {
  static String id = 'MainScreen';

  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MainScreen> {
  int _pageindex = 0;

  // HomeScreen'i kendisiyle tekrar çağırmamak için buraya başka bir ekran ekleyin
  final List<Widget> _pages = [
    AnaSayfa(),
    CategoriesScreen(),
    TasksScreen(),
    NotificationSrceen(),
    UserScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageindex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _pageindex,
        onTap: (value) {
          setState(() {
            _pageindex = value;
          });
        },
        unselectedItemColor: Color.fromARGB(255, 127, 127, 127),
        selectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              weight: 20,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_rounded),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
