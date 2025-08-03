import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/global_error_handling/main.dart';

class TestCrash extends StatelessWidget {
  const TestCrash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crash Test")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: Text("Throw Exception!"),
              onPressed: () {
                Future.delayed(Duration.zero, () {
                  throw Exception("خودت تست کردی! (Test Exception)");
                });
              },

              /*  onPressed: () async {
                throw Exception("Your error here");
              }, */
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              child: Text("Call Bad API (DioException)"),
              onPressed: () async {
                await dio.get(
                  "https://wrong.endpoint.example.com",
                ); // Use a dead/bad URL
              },
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              child: Text("open wifi settings"),
              onPressed: () {
                AppSettings.openAppSettings(type: AppSettingsType.wifi);
              },
            ),
          ],
        ),
      ),
    );
  }
}
