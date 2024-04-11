import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/Pages/View/account.dart';
import 'package:provider/Pages/View/home_page_view.dart';
import 'package:provider/Pages/View/manage.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({Key? key}) : super(key: key);

  @override
  State<BottomNavPage> createState() => _HomePageState();
}

class _HomePageState extends State<BottomNavPage> {
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    ManagePage(),
    HomePageView(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: ConvexAppBar(
        items: const [
          TabItem(icon: Icons.check_circle_rounded, title: 'Log'),
          TabItem(icon: Icons.notifications_rounded, title: 'Home'),
          TabItem(icon: Icons.person, title: 'Account'),
        ],
        style: TabStyle.textIn,
        color: Colors.black54,
        activeColor: Colors.black,
        backgroundColor: Colors.white,
        height: 50,
        initialActiveIndex: 1,
        elevation: 5,
        onTap: (int index) => setState(() {
          _selectedIndex = index;
        }),
      ),
    );
  }
}