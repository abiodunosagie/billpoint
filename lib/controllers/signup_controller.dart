import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../screens/features/login/login_screen.dart';
import '../utils/api_endpoints.dart';

class SignupController extends GetxController {
  final username = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();
  final address = TextEditingController();
  final hidePassword = true.obs;
  final signupFormKey = GlobalKey<FormState>();

  Future<void> signup() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.registerUrl);
      Map<String, dynamic> body = {
        'email': email.text.trim(),
        'password': 'pistol', // Use the specific password provided by ReqRes.in
      };

      http.Response response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Registration successful
        // Navigate to login screen or any other screen
        Get.off(
          const LoginScreen(),
        );
      } else {
        throw Exception('Failed to register');
      }
    } catch (e) {
      // Handle errors
      print('Registration Error: $e');
      // Show error dialog or snack-bar
    }
  }
}
