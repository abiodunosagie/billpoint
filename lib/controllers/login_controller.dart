import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/features/home/homescreen.dart';
import '../screens/features/login/login_screen.dart';
import '../utils/api_endpoints.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginHidePassword = true.obs;
  final loginFormKey = GlobalKey<FormState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var isLogin = false.obs;

  Future<void> loginWithEmail() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.loginUrl);
      Map<String, dynamic> body = {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      };

      http.Response response =
          await http.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['token'] != null) {
          final SharedPreferences prefs = await _prefs;
          await prefs.setString('token', json['token']);
          emailController.clear();
          passwordController.clear();
          isLogin.value = true;
          // Navigate to HomeScreen or any other screen upon successful login
          Get.off(const HomeScreen());
        } else {
          throw Exception('Invalid email or password');
        }
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      // Handle errors
      print('Login Error: $e');
      // Show error dialog or snackbar
    }
  }

  // Function to clear user token and navigate to login screen
  Future<void> logout() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove('token'); // Remove token from SharedPreferences
    isLogin.value = false; // Update login state
    Get.offAll(LoginScreen()); // Navigate to LoginScreen
  }
}
