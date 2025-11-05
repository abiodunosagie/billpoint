import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../utils/local_storage/storage_utility.dart';
import '../utils/logging/logger.dart';

/// LOGIN CONTROLLER
/// Manages the state and logic for the login screen
///
/// WHAT IS A CONTROLLER IN GETX?
/// - It's the "brain" of your screen
/// - Handles button clicks, form validation, API calls
/// - Manages loading states, error messages
/// - Updates the UI when data changes
///
/// WHY USE GETX CONTROLLER?
/// - Reactive: When you change a variable, UI updates automatically
/// - Easy state management: No need for StatefulWidget
/// - Built-in loading and error handling
/// - Simple dependency injection

class LoginController extends GetxController {
  // ============================================================
  // DEPENDENCIES
  // ============================================================

  /// AuthService - handles API calls
  final AuthService _authService = AuthService();

  /// LocalStorage - saves user data and token
  final TLocalStorage _localStorage = TLocalStorage();

  // ============================================================
  // FORM CONTROLLERS
  // ============================================================
  //
  // TextEditingController manages the text in TextFields
  // You need one controller for each input field
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// Form key for validation
  /// This helps validate all fields at once
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ============================================================
  // REACTIVE VARIABLES (GetX State Management)
  // ============================================================
  //
  // The .obs suffix makes a variable "observable"
  // When the value changes, any widget using it will rebuild automatically
  //
  // Example:
  // - isLoading.value = true; // UI shows loading spinner
  // - isLoading.value = false; // UI hides loading spinner

  /// Loading state - true when API call is in progress
  final RxBool isLoading = false.obs;

  /// Password visibility toggle
  final RxBool hidePassword = true.obs;

  /// Current logged-in user
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  /// Error message to display
  final RxString errorMessage = ''.obs;

  // ============================================================
  // LIFECYCLE METHODS
  // ============================================================

  @override
  void onInit() {
    super.onInit();
    // This runs when controller is created
    // Check if user is already logged in
    checkLoginStatus();
  }

  @override
  void onClose() {
    // Clean up controllers when screen is disposed
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // ============================================================
  // MAIN LOGIN METHOD
  // ============================================================
  //
  /// This is called when user taps the "Login" button
  ///
  /// What it does:
  /// 1. Validates the form (checks if email and password are valid)
  /// 2. Shows loading indicator
  /// 3. Calls the API
  /// 4. Handles success (save data, navigate to home)
  /// 5. Handles errors (show error message)
  Future<void> login() async {
    // STEP 1: Validate form
    if (!formKey.currentState!.validate()) {
      TLoggerHelper.warning('Login form validation failed');
      return;
    }

    // STEP 2: Clear any previous error messages
    errorMessage.value = '';

    // STEP 3: Show loading indicator
    // When you set .value, GetX automatically updates all widgets watching this variable
    isLoading.value = true;

    try {
      TLoggerHelper.info('Starting login process');

      // STEP 4: Call the API
      final response = await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // STEP 5: Handle the response
      if (response.success && response.data != null) {
        // LOGIN SUCCESS! 🎉

        TLoggerHelper.info('Login successful');

        // Save user data to local storage (so they stay logged in)
        await _saveUserData(response.data!);

        // Update current user in controller
        currentUser.value = response.data;

        // Show success message
        Get.snackbar(
          'Success',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Navigate to home screen
        // Get.offAllNamed() removes all previous screens from stack
        // So user can't go back to login by pressing back button
        Get.offAllNamed('/home'); // Change '/home' to your home route

        // Clear form fields
        emailController.clear();
        passwordController.clear();
      } else {
        // LOGIN FAILED ❌

        TLoggerHelper.warning('Login failed: ${response.error}');

        // Store error message (UI will show it)
        errorMessage.value = response.error ?? 'Login failed';

        // Show error snackbar
        Get.snackbar(
          'Login Failed',
          response.error ?? 'Please check your credentials',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      // UNEXPECTED ERROR (network issue, etc.)
      TLoggerHelper.error('Login error: $e');

      errorMessage.value = 'An unexpected error occurred';

      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      // STEP 6: Hide loading indicator
      // This runs whether login succeeds or fails
      isLoading.value = false;
    }
  }

  // ============================================================
  // HELPER METHODS
  // ============================================================

  /// Toggle password visibility
  /// Called when user taps the eye icon
  void togglePasswordVisibility() {
    hidePassword.value = !hidePassword.value;
  }

  /// Save user data to local storage
  /// This keeps the user logged in even after closing the app
  Future<void> _saveUserData(UserModel user) async {
    try {
      // Save user data as JSON
      await _localStorage.saveData('user', user.toJson());

      // In a real app, you'd also save the authentication token here:
      // await _localStorage.saveData('auth_token', loginResponse.token);

      TLoggerHelper.info('User data saved to local storage');
    } catch (e) {
      TLoggerHelper.error('Error saving user data: $e');
    }
  }

  /// Check if user is already logged in
  /// Called when app starts
  Future<void> checkLoginStatus() async {
    try {
      // Try to read user data from local storage
      final userData = _localStorage.readData<Map<String, dynamic>>('user');

      if (userData != null) {
        // User data exists! User is logged in
        currentUser.value = UserModel.fromJson(userData);
        TLoggerHelper.info('User already logged in: ${currentUser.value?.username}');

        // Navigate to home screen
        // You might want to verify the token with backend first
        // Get.offAllNamed('/home');
      } else {
        TLoggerHelper.info('No logged-in user found');
      }
    } catch (e) {
      TLoggerHelper.error('Error checking login status: $e');
    }
  }

  /// Logout user
  /// Clears all stored data and navigates to login
  Future<void> logout() async {
    try {
      isLoading.value = true;

      // Clear local storage
      await _localStorage.removeData('user');
      await _localStorage.removeData('auth_token');

      // Clear current user
      currentUser.value = null;

      TLoggerHelper.info('User logged out successfully');

      // Show message
      Get.snackbar(
        'Logged Out',
        'You have been logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate back to login
      Get.offAllNamed('/login');
    } catch (e) {
      TLoggerHelper.error('Logout error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

/// ============================================================
/// HOW TO USE THIS CONTROLLER IN YOUR UI
/// ============================================================
///
/// 1. In your login_screen.dart, add this at the top:
///    ```dart
///    final controller = Get.put(LoginController());
///    ```
///
/// 2. Use Obx() widget to show reactive data:
///    ```dart
///    Obx(() => controller.isLoading.value
///      ? CircularProgressIndicator()
///      : ElevatedButton(
///          onPressed: controller.login,
///          child: Text('Login'),
///        )
///    )
///    ```
///
/// 3. Use TextEditingController for input fields:
///    ```dart
///    TextField(
///      controller: controller.emailController,
///      decoration: InputDecoration(labelText: 'Email'),
///    )
///    ```
///
/// That's it! GetX handles all the state management for you.
