// main_scaffold.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/features/nav_bar/custom_nav_bar.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold>
    with TickerProviderStateMixin {
  int selected = 0;

  // Example pages for IndexedStack!
  final pages = [
    Center(child: Text('Home')),
    Center(child: Text('Notifier')),
    Center(child: Text('Chatbot')),
    Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Main content
          Positioned.fill(
            child: IndexedStack(index: selected, children: pages),
          ),

          /// NavBar
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomNavBar(
              selected: selected,
              onTap: (i) => setState(() => selected = i),
              vsync: this,
            ),
          ),
        ],
      ),
    );
  }
}
