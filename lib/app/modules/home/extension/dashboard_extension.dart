import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart' as dio;

import '../../../api/api_controller.dart';
import '../../../api/api_url.dart';
import '../model/dashboard_model.dart';

extension HomeExtension on ApiController{

  Future<DashBoardModel> dashBoardApi(String uid) async {
    var dioInstance = dio.Dio();
    try {
      EasyLoading.show(status: "Loading");
      dioInstance.options.headers = {
        'Content-Type': 'multipart/form-data',
      };
      dio.FormData formData = dio.FormData.fromMap({
        'uid': 3,
      });
      dio.Response response = await dioInstance.post(
        AppUrl.dashBoard,
        data: formData,
      );
      EasyLoading.dismiss();
      print("Response Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {

        final responseData = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        if (responseData is Map<String, dynamic> && responseData.containsKey('success')) {
          if (responseData['success'] == true) {

            return DashBoardModel.fromJson(responseData);
          } else {

            print("API returned success: false, Message: ${responseData['msg']}");
            return DashBoardModel(
              success: false,
              msg: responseData['msg'] ?? "Unknown error occurred",
            );
          }
        } else {
          return DashBoardModel(
            success: false,
            msg: "Invalid response format",
          );
        }
      } else {
        return DashBoardModel(
          success: false,
          msg: "Failed to load data. Error code: ${response.statusCode}",
        );
      }
    } on dio.DioError catch (e) {
      EasyLoading.dismiss();
      print("DioError occurred: ${e.message}, Response: ${e.response}");
      return DashBoardModel(
        success: false,
        msg: "An error occurred: ${e.response?.statusCode ?? 'Unknown error'} - ${e.message}",
      );
    } catch (e) {
      EasyLoading.dismiss();
      print("Unexpected error occurred: ${e.toString()}");
      return DashBoardModel(
        success: false,
        msg: "An unexpected error occurred: ${e.toString()}",
      );
    }
  }
}