import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart'; // Add if not already
import 'package:motogen/core/constants/app_colors.dart';
import 'package:motogen/core/storage/hive_storage.dart'; // Add this
import 'package:motogen/core/storage/shared_prefs_storage.dart'; // Add this
import 'package:motogen/features/car_info/models/car_form_state.dart'; // Add for CarFormState

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = Logger();

    return Scaffold(
      backgroundColor: AppColors.blue50,
      body: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: Center(
          child: Column(
            children: [
              Text(
                "خانه",
                style: TextStyle(
                  color: AppColors.blue500,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 20.h),
              // Debug Button: Load and Log User Info (SharedPrefs)
              ElevatedButton(
                onPressed: () async {
                  final userInfo = await SharedPrefsStorage.loadUserInfo();
                  if (userInfo != null) {
                    logger.i('debug User Info Loaded: $userInfo');
                  } else {
                    logger.w('debug No user info found in SharedPrefs');
                  }
                },
                child: const Text('Load and Log User Info'),
              ),
              SizedBox(height: 10.h),
              // Debug Button: Load and Log Car Info (Hive)
              ElevatedButton(
                onPressed: () async {
                  final carInfo = await HiveStorage.loadCarInfo();
                  if (carInfo != null) {
                    logger.i(
                      ' debug Car Info Loaded: ${carInfo.toJson()}',
                    ); // Assuming toJson() exists
                  } else {
                    logger.w('debug No car info found in Hive');
                  }
                },
                child: const Text('Load and Log Car Info'),
              ),

              FutureBuilder(
                future: Future.wait([
                  SharedPrefsStorage.loadUserInfo(),
                  HiveStorage.loadCarInfo(),
                ]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final userInfo = snapshot.data![0]; // User info object
                  final carInfo = snapshot.data![1]; // Car info object

                  if (userInfo == null && carInfo == null) {
                    return const Text('هیچ اطلاعاتی موجود نیست');
                  }

                  return Column(
                    children: [
                      if (userInfo != null) ...[
                        Text(
                          "User Info:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...userInfo.entries
                            .map((e) => Text('${e.key}: ${e.value}'))
                            .toList(),
                        SizedBox(height: 20),
                      ],
                      if (carInfo != null) ...[
                        Text(
                          "Car Info:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...prettyPrintCarInfo(carInfo.toJson()),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> prettyPrintCarInfo(Map<String, dynamic> map) {
  List<Widget> result = [];
  map.forEach((key, value) {
    if (value is Map) {
      // e.g. value = {id: ..., title: ...}
      final subTitle = value['title'] ?? value.values.first;
      result.add(Text('$key: $subTitle'));
    } else {
      result.add(Text('$key: $value'));
    }
  });
  return result;
}
