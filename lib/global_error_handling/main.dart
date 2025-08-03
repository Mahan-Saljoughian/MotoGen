import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:logger/logger.dart';
import 'package:motogen/global_error_handling/app_with_container.dart';

final logger = Logger();
final dio = Dio();
void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(Phoenix(child: AppWithContainer(key: AppWithContainer.globalKey)));
    },
    (error, stack) {
      logger.e('Uncaught error: $error');
      AppWithContainer.writeGlobalError(error.toString());
    },
  );
}
