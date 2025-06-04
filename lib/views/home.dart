import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uppgift3_new_app/repositories/notification_repository.dart';
import 'package:uppgift3_new_app/views/home_view.dart';
import 'package:uppgift3_new_app/views/list_view.dart';
import 'package:uppgift3_new_app/views/profile_view.dart';
import 'package:uppgift3_new_app/views/search_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

   @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreenContent(),
      ListScreen(),
      ProfileScreen(),
      SearchScreen(),
    ];
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

 @override
Widget build(BuildContext context) {
   final notificationRepo = context.read<NotificationRepository>();
  final isWideScreen = MediaQuery.of(context).size.width >= 600;

  return Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
      centerTitle: true,
      backgroundColor: Colors.green,
    ),
    body: Row(
      children: [
        if (isWideScreen)
          Container(
            color: Colors.grey[200],
            child: NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              labelType: NavigationRailLabelType.selected,
              selectedIconTheme: const IconThemeData(color: Colors.blue),
              unselectedIconTheme: const IconThemeData(color: Colors.amber),
              selectedLabelTextStyle: const TextStyle(color: Colors.blue),
              unselectedLabelTextStyle: const TextStyle(color: Colors.amber),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.list),
                  label: Text('List'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  label: Text('Profile'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.search),
                  label: Text('Search'),
                ),
              ],
            ),
          ),
        Expanded(child: _screens[_selectedIndex]),
      ],
    ),
    bottomNavigationBar: isWideScreen
        ? null
        : BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.green,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            ],
          ),
  );
}

}
