import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/api_response.dart';
import '../utils/logging/logger.dart';

/// AUTHENTICATION SERVICE
/// This is where ALL API calls related to authentication happen
///
/// WHAT DOES A SERVICE DO?
/// - Makes HTTP requests to your backend API
/// - Handles the response (success or error)
/// - Converts JSON to Dart objects
/// - Returns data in a consistent format
///
/// WHY SEPARATE SERVICE CLASS?
/// - Keeps API logic separate from UI
/// - Easy to test
/// - Easy to modify API endpoints without touching UI code
/// - Reusable across different screens

class AuthService {
  /// BASE URL - Your backend API address
  /// IMPORTANT: Change this to your actual API URL!
  ///
  /// Examples:
  /// - Local development: 'http://localhost:3000/api'
  /// - Production: 'https://api.billpoint.com'
  static const String _baseUrl = 'https://your-api-base-url.com/api';

  /// API ENDPOINTS
  /// Define all your authentication endpoints here
  static const String _loginEndpoint = '/auth/login';
  static const String _signupEndpoint = '/auth/signup';
  static const String _logoutEndpoint = '/auth/logout';

  /// ============================================================
  /// LOGIN METHOD - Step by step breakdown
  /// ============================================================
  ///
  /// This method:
  /// 1. Takes email and password from user
  /// 2. Sends POST request to backend
  /// 3. Receives response
  /// 4. Converts response to UserModel
  /// 5. Returns success or error
  Future<ApiResponse<UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      // STEP 1: Log what we're doing (helpful for debugging)
      TLoggerHelper.info('Attempting login for email: $email');

      // STEP 2: Prepare the data to send to API
      // This is the "body" of your POST request
      final Map<String, dynamic> requestBody = {
        'email': email,
        'password': password,
      };

      TLoggerHelper.debug('Request body: ${jsonEncode(requestBody)}');

      // STEP 3: Make the HTTP POST request
      //
      // What's happening here:
      // - Uri.parse(): Converts string URL to Uri object
      // - http.post(): Sends POST request to the server
      // - headers: Tells server we're sending JSON data
      // - body: The actual data (email + password) converted to JSON string
      final response = await http.post(
        Uri.parse('$_baseUrl$_loginEndpoint'),
        headers: {
          'Content-Type': 'application/json', // We're sending JSON
          'Accept': 'application/json', // We expect JSON back
        },
        body: jsonEncode(requestBody), // Convert Map to JSON string
      );

      TLoggerHelper.debug('Response status code: ${response.statusCode}');
      TLoggerHelper.debug('Response body: ${response.body}');

      // STEP 4: Handle the response based on status code
      //
      // HTTP Status Codes:
      // - 200-299: Success
      // - 400-499: Client errors (wrong email/password, validation errors)
      // - 500-599: Server errors (backend problem)
      if (response.statusCode == 200 || response.statusCode == 201) {
        // SUCCESS! Convert the JSON response to Dart object
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // Extract login response (token + user data)
        final loginResponse = LoginResponse.fromJson(jsonResponse);

        // Convert user data to UserModel
        final user = UserModel.fromJson(loginResponse.user);

        TLoggerHelper.info('Login successful for user: ${user.username}');

        // Return success response with user data
        return ApiResponse.success(
          data: user,
          message: jsonResponse['message'] ?? 'Login successful',
        );
      } else if (response.statusCode == 401) {
        // 401 = Unauthorized (wrong email or password)
        TLoggerHelper.warning('Login failed: Invalid credentials');

        return ApiResponse.failure(
          error: 'Invalid email or password',
        );
      } else if (response.statusCode == 400) {
        // 400 = Bad request (validation error)
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Invalid request';

        TLoggerHelper.warning('Login failed: $errorMessage');

        return ApiResponse.failure(
          error: errorMessage,
        );
      } else {
        // Other errors
        TLoggerHelper.error('Login failed with status: ${response.statusCode}');

        return ApiResponse.failure(
          error: 'Login failed. Please try again.',
        );
      }
    } catch (e) {
      // STEP 5: Handle any unexpected errors
      // This catches network errors, JSON parsing errors, etc.
      TLoggerHelper.error('Login error: $e');

      return ApiResponse.failure(
        error: 'An error occurred. Please check your internet connection.',
      );
    }
  }

  /// ============================================================
  /// SIGNUP METHOD
  /// ============================================================
  ///
  /// Similar to login, but with more fields
  Future<ApiResponse<UserModel>> signup({
    required String username,
    required String email,
    required String password,
    String? phoneNumber,
    String? address,
  }) async {
    try {
      TLoggerHelper.info('Attempting signup for email: $email');

      // Prepare request body with all signup fields
      final Map<String, dynamic> requestBody = {
        'username': username,
        'email': email,
        'password': password,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
        if (address != null) 'address': address,
      };

      final response = await http.post(
        Uri.parse('$_baseUrl$_signupEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      TLoggerHelper.debug('Signup response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(jsonResponse);
        final user = UserModel.fromJson(loginResponse.user);

        TLoggerHelper.info('Signup successful for user: ${user.username}');

        return ApiResponse.success(
          data: user,
          message: jsonResponse['message'] ?? 'Account created successfully',
        );
      } else if (response.statusCode == 409) {
        // 409 = Conflict (email already exists)
        return ApiResponse.failure(
          error: 'Email already exists',
        );
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        return ApiResponse.failure(
          error: errorData['message'] ?? 'Invalid request',
        );
      } else {
        return ApiResponse.failure(
          error: 'Signup failed. Please try again.',
        );
      }
    } catch (e) {
      TLoggerHelper.error('Signup error: $e');
      return ApiResponse.failure(
        error: 'An error occurred. Please check your internet connection.',
      );
    }
  }

  /// ============================================================
  /// LOGOUT METHOD
  /// ============================================================
  ///
  /// If your API requires logout (to invalidate tokens), use this
  /// Otherwise, you can just clear local storage
  Future<ApiResponse<void>> logout(String token) async {
    try {
      TLoggerHelper.info('Attempting logout');

      final response = await http.post(
        Uri.parse('$_baseUrl$_logoutEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Send auth token
        },
      );

      if (response.statusCode == 200) {
        TLoggerHelper.info('Logout successful');
        return ApiResponse.success(
          data: null,
          message: 'Logged out successfully',
        );
      } else {
        return ApiResponse.failure(
          error: 'Logout failed',
        );
      }
    } catch (e) {
      TLoggerHelper.error('Logout error: $e');
      return ApiResponse.failure(
        error: 'An error occurred during logout',
      );
    }
  }
}

/// ============================================================
/// TESTING YOUR API CALLS
/// ============================================================
///
/// How to test if your API integration works:
///
/// 1. Update _baseUrl with your actual API URL
/// 2. In your main.dart or a test screen, try:
///
/// ```dart
/// final authService = AuthService();
/// final response = await authService.login(
///   email: 'test@example.com',
///   password: 'password123',
/// );
///
/// if (response.success) {
///   print('Login successful!');
///   print('User: ${response.data?.username}');
/// } else {
///   print('Login failed: ${response.error}');
/// }
/// ```
///
/// 3. Check the logs to see what's happening
/// 4. If it fails, check:
///    - Is the API URL correct?
///    - Is the endpoint correct?
///    - Is your backend running?
///    - Check the response body in logs to see what error the API returned
