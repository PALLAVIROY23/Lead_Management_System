import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lms/app/api/api_url.dart';

import '../../../api/api_controller.dart';
import '../model/updateModel.dart';
extension ViewScreenExtension on ApiController {
  Future<UpdateDetailModel> updateDetails({
    String? status,
    String? followupdate,
    String? lastupdate,
    String? oldcomments,
    String? comments,
    String? id,
  }) async {
    const String apiUrl = AppUrl.updateDetails; // Define your API URL

    try {
      // Prepare the form data, adding only non-null values
      final formData = FormData.fromMap({
        if (status != null) 'status': status,
        if (followupdate != null) 'followupdate': followupdate,
        if (lastupdate != null) 'lastupdate': lastupdate,
        if (oldcomments != null) 'oldcomments': oldcomments,
        if (comments != null) 'comments': comments,
        if (id != null) 'id': id,
      });

      // Make the POST request
      final response = await Dio().post(apiUrl, data: formData);

      if (response.statusCode == 200) {
        // If response.data is a String, decode it
        final dynamic responseData = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        // Ensure responseData is a Map before parsing
        if (responseData is Map<String, dynamic>) {
          final data = UpdateDetailModel.fromJson(responseData);
          if (data.success == true) {
            return data; // Return the parsed model on success
          } else {
            throw Exception('Update failed: ${data.msg}');
          }
        } else {
          throw Exception('Unexpected response format: ${response.data}');
        }
      } else {
        throw Exception('Failed to update details: ${response.statusMessage}');
      }
    }catch(e){
      throw Exception('Failed to update details: ');

    }
  }
}
