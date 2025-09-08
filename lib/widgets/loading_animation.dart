import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingAnimation extends StatelessWidget {
  final double size;

  const LoadingAnimation({
    super.key,
    this.size = 200, // default size, can override
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Lottie.asset(
          'assets/animations/loading.json',
          fit: BoxFit.contain,
          repeat: true,
        ),
      ),
    );
  }
}
