import 'package:flutter/material.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/features/chat_screen/views/chat_screen.dart';
import 'package:motogen/features/home_screen/view/home_screen.dart';
import 'package:motogen/features/nav_bar/custom_nav_bar.dart';
import 'package:motogen/features/profile_screen/view/profile_screen.dart';
import 'package:motogen/features/reminder_screen.dart/view/reminder_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold>
    with TickerProviderStateMixin {
  int selected = 0;

  Widget? chatScreen;
  Widget? reminderScreen;
  List<Widget> get pages => [
    const HomeScreen(),
    reminderScreen ?? const SizedBox(),
    chatScreen ?? const SizedBox(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        reminderScreen = const ReminderScreen();
        chatScreen = const ChatScreen();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue50,

      extendBody: true,

      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: LazyLoadIndexedStack(index: selected, children: pages),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        selected: selected,
        onTap: (i) {
          setState(() {
            selected = i;
          });
        },
        vsync: this,
      ),

      /* bottomNavigationBar: MyNavBar(
        selected: selected,
        onTap: (i) => setState(() => selected = i),
        vsync: this,
      ), */
      /* bottomNavigationBar: CustomNavBarCurved(
        selected: selected,
        onTap: (i) => setState(() => selected = i),
        vsync: this,
      ), */
    );
  }
}
