import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get_storage/get_storage.dart';
import '../data/constants.dart';
import '../data/constants.dart';
import '../routes/app_pages.dart';

class ApiController extends GetConnect implements GetxService {
  final GetStorage getStorage = GetStorage();

  @override
  void onInit() async {
    // Initialize storage
    await getStorage.initStorage;

    // Configure HTTP client
    httpClient.timeout = const Duration(seconds: 60);

    // Add request modifier to include authorization header
    httpClient.addRequestModifier((Request request) async {
      // Fetch token from Constants class instead of directly from storage
      final token = Constants.userDetails.isNotEmpty ? Constants.userDetails[0] : "";

      print("token>>>>>$token");

      // Add Authorization header
      request.headers['Authorization'] = 'Bearer $token';
      return request;
    });

    // Add response modifier to handle responses and log request details
    httpClient.addResponseModifier((request, response) async {
      if (kDebugMode) {
        // Log request details in debug mode
        final List<int> bodyBytes = await request.bodyBytes.fold<List<int>>(
          <int>[],
              (List<int> previous, List<int> element) => previous..addAll(element),
        );

        // Convert List<int> to String
        final requestBody = utf8.decode(bodyBytes);
        print("Request URL: ${request.url}");
        print("Request Body: $requestBody");
      }

      // Handle unauthorized responses
      if (response.statusCode == 401) {
        Get.offAllNamed(Routes.LOGIN_SCREEN);
      }

      return response;
    });

    super.onInit();
  }
}
