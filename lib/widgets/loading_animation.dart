import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingAnimation extends StatefulWidget {
  final double size;

  const LoadingAnimation({
    super.key,
    this.size = 200, // default size, can override
  });

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> {
  late final Future<LottieComposition> _loadingComposition;

  @override
  void initState() {
    super.initState();
    _loadingComposition = AssetLottie('assets/animations/loading.json').load();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: FutureBuilder<LottieComposition>(
          future: _loadingComposition,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              // While parsing
              return const SizedBox.shrink();
            }
            return Lottie(
              composition: snapshot.data!,
              fit: BoxFit.contain,
              repeat: true,
            );
          },
        ),
      ),
    );
  }
}
