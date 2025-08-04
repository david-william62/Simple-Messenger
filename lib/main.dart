import 'package:flutter/material.dart';
import 'pages/chats_screen.dart';
import 'pages/groups_screen.dart';
import 'pages/friends_screen.dart';
import 'pages/account_screen.dart';

void main() {
  runApp(const WhatsAppClone());
}

class WhatsAppClone extends StatelessWidget {
  const WhatsAppClone({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp Clone',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 76, 175, 80))
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ChatsScreen(),
    const GroupsScreen(),
    const FriendsScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        
        if (isMobile) {
          return Scaffold(
            body: _screens[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: 'Groups',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Friends',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'Account',
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) => setState(() => _currentIndex = index),
                  labelType: NavigationRailLabelType.all,
                  selectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
                  selectedLabelTextStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.chat),
                      label: Text('Chats'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.group),
                      label: Text('Groups'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.people),
                      label: Text('Friends'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.account_circle),
                      label: Text('Account'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: _screens[_currentIndex]),
              ],
            ),
          );
        }
      },
    );
  }
}
