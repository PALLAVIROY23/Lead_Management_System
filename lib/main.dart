import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart'; // Import this for SystemChrome
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/api/globle_binding.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  // Ensure that Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Lock the app to portrait mode only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize GetStorage
  await GetStorage.init();

  // Run the app
  runApp(
    ScreenUtilInit(
      designSize: const Size(393, 879),
      minTextAdapt: true,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Application",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        initialBinding: GlobalBindings(),
        builder: EasyLoading.init(),
      ),
    ),
  );

  // EasyLoading configuration
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false // Prevent repeated hits while loading
    ..dismissOnTap = false;
}
