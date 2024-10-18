import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../api/api_controller.dart';
import '../../../api/api_url.dart';

extension UpdateCustomerExtension on ApiController {

  Future<Map<String, dynamic>> updateCustomer({
    required String name,
    required String email,
    required String mobile,
    required String alternatemobile,
    required String companyname,
    required String websiteurl,
    required String address,
    required String userassigned,
    required String status,
    required String followupdate,
    required String lastupdate,
    required String comments,
    required String industry,
    required String city,
    required String source,
    required String service,

  }) async {
    try {
      var dio = Dio();
      // Show loading indicator
      EasyLoading.show(status: "Updating Customer...");

      // FormData for the request body
      FormData formData = FormData.fromMap({
        'name': name,
        'email': email,
        'mobile': mobile,
        'alternatemobile': alternatemobile,
        'companyname': companyname,
        'websiteurl': websiteurl,
        'address': address,
        'userassigned': userassigned,
        'status': status,
        'followupdate': followupdate,
        'lastupdate': lastupdate,
        'comments': comments,
        'industry': industry,
        'city': city,
        'source': source,
        'service': service,
        // Include the ID for the customer being updated
      });

      // API request
      Response response = await dio.post(
        AppUrl.updateCustomer, // Replace this with your actual API URL
        data: formData,
      );

      // Dismiss loading
      EasyLoading.dismiss();

      // Check if the response is successful
      if (response.statusCode == 200 && response.data != null) {
        print("Customer updated successfully: ${json.encode(response.data)}");

        // Return the response data as a Map
        return response.data is String
            ? jsonDecode(response.data)
            : response.data;
      } else {
        print("Error: ${response.statusMessage}");
        return {
          'success': false,
          'message': "Failed to update customer. Status code: ${response.statusCode}",
        };
      }
    } on DioError catch (e) {
      // Handle Dio errors
      EasyLoading.dismiss();
      print("DioError occurred: ${e.message}, Response: ${e.response}");
      return {
        'success': false,
        'message': "An error occurred: ${e.response?.statusCode ?? 'Unknown error'} - ${e.message}",
      };
    } catch (e) {
      // Handle general errors
      EasyLoading.dismiss();
      print("Unexpected error occurred: ${e.toString()}");
      return {
        'success': false,
        'message': "An unexpected error occurred: ${e.toString()}",
      };
    }
  }
}
