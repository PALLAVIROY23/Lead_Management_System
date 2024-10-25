import 'package:dio/dio.dart';
import 'package:lms/app/api/api_url.dart';

import '../../../api/api_controller.dart';

extension ViewScreenExtension on ApiController {
  Future<Response> updateDetails({
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

      // Check the response and return it
      if (response.statusCode == 200) {
        return response; // Return the response on success
      } else {
        throw Exception('Failed to update details: ${response.statusMessage}');
      }
    } on DioError catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      // Handle other exceptions
      throw Exception('Unexpected error: $e');
    }
  }
}
