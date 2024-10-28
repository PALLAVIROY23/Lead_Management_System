import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart';

import '../../../api/api_controller.dart';
import '../../../api/api_url.dart';
import '../model/citiesModel.dart';
import '../model/customerListModel.dart';
import '../model/serviceModel.dart';
import '../model/sourceModel.dart';

extension NewsController on ApiController {
  // Fetch Customer Status List
  Future<CustomerStatusListModel> fetchCustomerStatusListApi(
      String uid, String status) async {
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
        print(
            "Response Data for customer list>>>>>>>>: ${json.encode(response.data)}");

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
    } on DioException catch (e) {
      // Handle Dio errors
      EasyLoading.dismiss();
      print("DioError occurred: ${e.message}, Response: ${e.response}");
      return CustomerStatusListModel(
        success: false,
        msg:
            "An error occurred: ${e.response?.statusCode ?? 'Unknown error'} - ${e.message}",
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


// In ApiController

  Future<CustomerServiceModel> fetchServiceListApi() async {
    try {
      Response response = await Dio().get(AppUrl.services);

      // Check if the response body is a JSON-encoded string
      if (response.data is String) {
        // Decode the JSON string
        final Map<String, dynamic> jsonData = json.decode(response.data);
        return CustomerServiceModel.fromJson(jsonData);
      } else if (response.data is Map<String, dynamic>) {
        // If it's already a Map, directly parse it
        return CustomerServiceModel.fromJson(response.data);
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      // Handle any exceptions during the request
      print("Error fetching service list: $e");
      throw Exception("Failed to fetch service list");
    }
  }

  Future<CustomerCitiesModel> fetchCitiesListApi() async {
    try {
      Response response = await Dio().get(AppUrl.cities);
      if (response.data is String) {
        print("CITY DATA>>>>>>${response.data}");
        final Map<String, dynamic> jsonData = json.decode(response.data);
        return CustomerCitiesModel.fromJson(jsonData);
      } else if (response.data is Map<String, dynamic>) {
        return CustomerCitiesModel.fromJson(response.data);
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      print("Error fetching service list: $e");
      throw Exception("Failed to fetch service list");
    }
  }


  Future<CustomerSourceModel> fetchSourceListApi() async {
    try {
      // Create Dio instance
      var dio = Dio();

      // Make the request
      Response response = await dio.request(
        AppUrl.source,
        options: Options(
          method: 'GET',
        ),
      );

      // Check response status
      if (response.statusCode == 200) {
        // Handle the response data
        if (response.data is String) {
          final Map<String, dynamic> jsonData = json.decode(response.data);
          print("SOURCE DATA >>>>>> ${response.data}");
          return CustomerSourceModel.fromJson(jsonData);
        } else if (response.data is Map<String, dynamic>) {
          return CustomerSourceModel.fromJson(response.data);
        } else {
          throw Exception("Unexpected response format");
        }
      } else {
        // Handle non-200 responses
        throw Exception("Failed to fetch source list: ${response.statusMessage}");
      }
    } catch (e) {
      // Catch any errors during the request
      throw Exception("Failed to fetch sources list: $e");
    }
  }
}
