import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart';

import '../../../api/api_controller.dart';
import '../../../api/api_url.dart';
import '../model/customerListModel.dart';

extension NewsController on ApiController {
  // Fetch Customer Status List
  Future<CustomerStatusListModel> fetchCustomerStatusListApi(String uid, String status) async {
    try {
      var dio = Dio();
      // Show loading indicator
      EasyLoading.show(status: "Loading");

      // FormData for the request body
      FormData formData = FormData.fromMap({
        'uid': uid,
        'status': status,
      });

      // API request
      Response response = await dio.request(
        AppUrl.customerListDetail,
        options: Options(
          method: 'POST', // POST method
        ),
        data: formData, // Sending formData as the request body
      );

      // Dismiss loading
      EasyLoading.dismiss();

      // Check if the status code is 200
      if (response.statusCode == 200 && response.data != null) {
        print("Response Data for customer list>>>>>>>>: ${json.encode(response.data)}");

        var parsedData = customerStatusListFromJson(response.data is String
            ? response.data
            : jsonEncode(response.data));

        if (parsedData.lead == null || parsedData.lead!.isEmpty) {
          print("Lead data is null or empty");
        } else {
          print("Lead data length: ${parsedData.lead!.length}");
        }

        return parsedData;
      } else {
        print("Error: ${response.statusMessage}");
        return CustomerStatusListModel(
          success: false,
          msg: "Failed to load data. Status code: ${response.statusCode}",
        );
      }
    } on DioError catch (e) {
      // Handle Dio errors
      EasyLoading.dismiss();
      print("DioError occurred: ${e.message}, Response: ${e.response}");
      return CustomerStatusListModel(
        success: false,
        msg: "An error occurred: ${e.response?.statusCode ?? 'Unknown error'} - ${e.message}",
      );
    } catch (e) {
      // Handle general errors
      EasyLoading.dismiss();
      print("Unexpected error occurred: ${e.toString()}");
      return CustomerStatusListModel(
        success: false,
        msg: "An unexpected error occurred: ${e.toString()}",
      );
    }
  }
}

