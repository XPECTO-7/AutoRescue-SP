import 'package:AutoRescue/Colors/appcolor.dart';
import 'package:AutoRescue/Pages/View/home_page.dart';
import 'package:AutoRescue/Pages/View/req_service.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:AutoRescue/Pages/View/account.dart';


class BottomNavPage extends StatefulWidget {
  const BottomNavPage({Key? key}) : super(key: key);

  @override
  State<BottomNavPage> createState() => _HomePageState();
}

class _HomePageState extends State<BottomNavPage> {
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    ReqServicePage(),
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
          TabItem(icon: Icons.settings_suggest_rounded, title: 'SERVICE'),
          TabItem(icon: Icons.home_rounded, title: 'HOME'),
          TabItem(
            icon: Icons.person,
            title: 'ACCOUNT',
          ),
        ],
        style: TabStyle.reactCircle,
        color: Colors.black,
        activeColor: Colors.black,
        backgroundColor: AppColors.appTertiary,
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
