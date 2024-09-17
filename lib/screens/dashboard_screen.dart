import 'package:flutter/material.dart';
import 'package:movietime/extensions/extension_util/context_extensions.dart';
import 'package:movietime/screens/search_screen.dart';

import '../components/double_back_to_close_app.dart';
import '../extensions/text_styles.dart';
import '../utils/app_colors.dart';
import 'home_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  int mCurrentIndex = 0;
  final tab = [
    HomeScreen(),
    SearchScreen()

  ];


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  DoubleBackToCloseApp(
        snackBar: SnackBar(
          elevation: 4,
          backgroundColor: primaryOpacity,
          content: Text('Tap back again to leave', style: primaryTextStyle()),
        ),
        child: AnimatedContainer(
          color: context.cardColor,
          duration: const Duration(seconds: 1),
          child: IndexedStack(index: mCurrentIndex, children: tab),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        enableFeedback: false,
        selectedLabelStyle: secondaryTextStyle(),
        unselectedLabelStyle: secondaryTextStyle(),
        backgroundColor: context.cardColor,
        currentIndex: mCurrentIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: primaryColor,
        onTap: (index) {
          mCurrentIndex = index;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movies'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
      ),

    );
  }
}
