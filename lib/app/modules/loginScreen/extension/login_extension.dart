import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../api/api_controller.dart';
import '../../../api/api_url.dart';
import '../model/login_model.dart';

extension LoginExtension on ApiController {


  Future<LoginApi> loginWithUserName(String username, String password) async {
    var dioInstance = dio.Dio();
    try {
      EasyLoading.show(status: "Loading");

      dio.FormData formData = dio.FormData.fromMap({
        'username': username,
        'password': password,
      });

      dio.Response response = await dioInstance.post(
        AppUrl.loginUrl,
        data: formData,
      );

      EasyLoading.dismiss(); // Dismiss loading after getting the response

      if (response.statusCode == 200) {
        final responseData = response.data is String
            ? jsonDecode(response.data)
            : response.data;
        return LoginApi.fromJson(responseData);
      } else {
        return LoginApi(
          success: false,
          msg: "Failed to login. Error code: ${response.statusCode}",
        );
      }
    } on dio.DioError catch (e) {
      EasyLoading.dismiss(); // Ensure loading is dismissed on error
      return LoginApi(success: false, msg: "An error occurred: ${e.message}");
    }
  }



}







