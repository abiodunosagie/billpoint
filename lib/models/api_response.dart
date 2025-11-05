/// API RESPONSE MODEL
/// A standardized way to handle ALL API responses in your app
///
/// WHY IS THIS HELPFUL?
/// - All APIs return data in a similar structure
/// - This helps you handle success, errors, and messages consistently
/// - You don't have to write different code for each API call

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final String? error;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  /// Create a successful response
  /// Use this when API call succeeds
  ///
  /// Example:
  /// ```
  /// return ApiResponse.success(
  ///   data: userObject,
  ///   message: "Login successful"
  /// );
  /// ```
  factory ApiResponse.success({
    required T data,
    String message = 'Success',
  }) {
    return ApiResponse(
      success: true,
      message: message,
      data: data,
    );
  }

  /// Create a failed response
  /// Use this when API call fails
  ///
  /// Example:
  /// ```
  /// return ApiResponse.failure(
  ///   error: "Invalid email or password"
  /// );
  /// ```
  factory ApiResponse.failure({
    required String error,
    String message = 'Failed',
  }) {
    return ApiResponse(
      success: false,
      message: message,
      error: error,
    );
  }

  /// Convert API JSON response to ApiResponse object
  /// This handles the standard response format from your backend
  ///
  /// Expected API format:
  /// {
  ///   "success": true,
  ///   "message": "Login successful",
  ///   "data": { ...user data... }
  /// }
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      error: json['error'],
    );
  }
}

/// LOGIN RESPONSE MODEL
/// Specifically for login/signup responses that include a token
///
/// Most authentication APIs return:
/// {
///   "token": "eyJhbGciOiJIUzI1...",  // JWT token for authentication
///   "user": { ...user data... }
/// }
class LoginResponse {
  final String token;
  final dynamic user; // Will be converted to UserModel

  LoginResponse({
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? json['accessToken'] ?? '',
      user: json['user'] ?? json['data'],
    );
  }
}
