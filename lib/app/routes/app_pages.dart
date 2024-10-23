import 'package:get/get.dart';

import '../modules/add_customer/bindings/add_customer_binding.dart';
import '../modules/add_customer/views/add_customer_view.dart';
import '../modules/customerListScreen/bindings/customer_list_screen_binding.dart';
import '../modules/customerListScreen/views/customer_list_screen_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/loginScreen/bindings/login_screen_binding.dart';
import '../modules/loginScreen/views/login_screen_view.dart';
import '../modules/splashScreen/bindings/splash_screen_binding.dart';
import '../modules/splashScreen/views/splash_screen_view.dart';
import '../modules/update_Customer_Details/bindings/update_customer_details_binding.dart';
import '../modules/update_Customer_Details/views/update_customer_details_view.dart';
import '../modules/viewScreen/bindings/view_screen_binding.dart';
import '../modules/viewScreen/views/view_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_SCREEN,
      page: () => const LoginScreenView(),
      binding: LoginScreenBinding(),
    ),
    GetPage(
      name: _Paths.CUSTOMER_LIST_SCREEN,
      page: () =>  CustomerListScreenView(),
      binding: CustomerListScreenBinding(),
    ),
    GetPage(
      name: _Paths.VIEW_SCREEN,
      page: () =>  ViewScreenView(),
      binding: ViewScreenBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_CUSTOMER_DETAILS,
      page: () => const UpdateCustomerDetailsView(),
      binding: UpdateCustomerDetailsBinding(),
    ),
    GetPage(
      name: _Paths.ADD_CUSTOMER,
      page: () => const AddCustomerView(),
      binding: AddCustomerBinding(),
    ),

  ];
}
