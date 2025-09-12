import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:motogen/core/global_error_handling/app_with_container.dart';
import 'package:motogen/core/global_error_handling/viewmodel/global_error_provider.dart';
import 'package:motogen/core/services/logger.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      );

      await dotenv.load(fileName: ".env");

      runApp(Phoenix(child: AppWithContainer(key: AppWithContainer.globalKey)));
    },
    (error, stack) {
      appLogger.e('Uncaught error: $error');
      AppWithContainer.writeGlobalError(
        GlobalErrorState(message: error.toString()),
      );
    },
  );
}
