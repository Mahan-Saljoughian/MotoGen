import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motogen/core/global_error_handling/app.dart';

import 'package:motogen/core/global_error_handling/viewmodel/global_error_provider.dart';

class AppWithContainer extends StatefulWidget {
  static final GlobalKey<_AppWithContainerState> globalKey = GlobalKey();
  static _AppWithContainerState? of(BuildContext context) =>
      globalKey.currentState;
  static void writeGlobalError(GlobalErrorState? error) {
    globalKey.currentState?._container
            .read(globalErrorProvider.notifier)
            .state =
        error;
  }

  const AppWithContainer({Key? key}) : super(key: key);

  @override
  State<AppWithContainer> createState() => _AppWithContainerState();
}

class _AppWithContainerState extends State<AppWithContainer> {
  ProviderContainer _container = ProviderContainer();

  /*  void restart() {
    setState(() {
      _container.dispose();
      _container = ProviderContainer();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Phoenix.rebirth(context);
    });
  }
 */

  void restart() async {
    setState(() {
      _container.dispose();
      _container = ProviderContainer();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Phoenix.rebirth(context);
    });
  }

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
        builder: (context, child) => App(),
      ),
    );
  }
}
