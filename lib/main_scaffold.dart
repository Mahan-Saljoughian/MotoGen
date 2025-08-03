import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/features/chat_screen/views/chat_screen.dart';
import 'package:motogen/features/nav_bar/custom_nav_bar.dart';
import 'package:motogen/widgets/custom_app_bar.dart';

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
    ChatScreen(),
    Center(child: Text('Profile')),
  ];

  final appBarLabels = ["خانه", "یادآور", "چت‌بات", "پروفایل"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      /* appBar: CustomAppBar(label: appBarLabels[selected]), */
      body: SafeArea(
        child: Stack(
          children: [
            /// Main content
            Positioned.fill(
              child: IndexedStack(index: selected, children: pages),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        selected: selected,
        onTap: (i) => setState(() => selected = i),
        vsync: this,
      ),
    );
  }
}
