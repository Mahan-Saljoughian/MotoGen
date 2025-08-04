import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motogen/core/global_error_handling/app_with_container.dart';

class GlobalErrorScreen extends StatelessWidget {
  final String error;

  const GlobalErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 72),
              const SizedBox(height: 24),
              const Text(
                "خطای برنامه",
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text("بستن برنامه"),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  AppWithContainer.of(context)?.restart();
                },
                child: const Text("ریستارت برنامه"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
