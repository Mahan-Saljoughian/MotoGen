import 'package:flutter/material.dart';

class BannedPage extends StatelessWidget {
  const BannedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Your account is inactive or banned.")),
    );
  }
}
