
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/global_error_handling/app_init.dart';
import 'package:motogen/core/global_error_handling/connectivity_watcher.dart';
import 'package:motogen/core/global_error_handling/global_error_provider.dart';

class AppWithContainer extends StatefulWidget {
  static final GlobalKey<_AppWithContainerState> globalKey = GlobalKey();
  static _AppWithContainerState? of(BuildContext context) =>
      globalKey.currentState;
  static void writeGlobalError(String? error) =>
      globalKey.currentState?._container
              .read(globalErrorProvider.notifier)
              .state =
          error;

  const AppWithContainer({Key? key}) : super(key: key);

  @override
  State<AppWithContainer> createState() => _AppWithContainerState();
}

class _AppWithContainerState extends State<AppWithContainer> {
  ProviderContainer _container = ProviderContainer();

  void restart() async {
  
    _container.read(connectivityCheckCompleteProvider.notifier).state = false;

    setState(() {
      _container.dispose();
      _container = ProviderContainer();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Phoenix.rebirth(context);
      await ConnectivityWatcher.checkConnectivityNow();
      _container.read(connectivityCheckCompleteProvider.notifier).state = true;
    });
  }

 /*  void restart()  {
 setState(() {
      _container.dispose();
      _container = ProviderContainer();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Phoenix.rebirth(context);
    });
  }
 */

  @override
  void dispose() {
    _container.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UncontrolledProviderScope(
      container: _container,
      child: ScreenUtilInit(
        designSize: const Size(412, 917),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => AppInit(),
      ),
    );
  }
}
