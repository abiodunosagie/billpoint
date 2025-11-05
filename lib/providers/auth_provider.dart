import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../utils/local_storage/storage_utility.dart';
import '../utils/logging/logger.dart';

/// ============================================================
/// RIVERPOD STATE MANAGEMENT - AUTHENTICATION
/// ============================================================
///
/// WHAT IS RIVERPOD?
/// Riverpod is a modern, robust state management solution that:
/// - Eliminates runtime errors (compile-time safety)
/// - Works without BuildContext
/// - Easy to test
/// - Allows providers to depend on other providers
///
/// KEY RIVERPOD CONCEPTS:
///
/// 1. PROVIDER - Creates and manages state
/// 2. STATENOTIFIER - Class that manages mutable state
/// 3. REF - Object that lets you interact with other providers
/// 4. CONSUMER - Widget that listens to providers
///
/// ============================================================

// ============================================================
// 1. LOGIN STATE CLASS
// ============================================================
//
/// This class represents the current state of the login screen
///
/// WHY A SEPARATE STATE CLASS?
/// - In Riverpod, we separate STATE (data) from LOGIC (notifier)
/// - Makes it easy to know exactly what data the UI needs
/// - Makes state immutable (can't accidentally modify it)
///
/// Think of this as a snapshot of the login screen at any moment:
/// - Is it loading?
/// - Is there an error?
/// - Is the user logged in?
class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final UserModel? user;
  final bool hidePassword;

  const LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.user,
    this.hidePassword = true,
  });

  /// COPY WITH METHOD
  /// Since state is immutable, we create a new state with updated values
  ///
  /// Example:
  /// ```
  /// final newState = currentState.copyWith(isLoading: true);
  /// ```
  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    UserModel? user,
    bool? hidePassword,
    bool clearError = false,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      user: user ?? this.user,
      hidePassword: hidePassword ?? this.hidePassword,
    );
  }
}

// ============================================================
// 2. LOGIN NOTIFIER (The "Brain" of Login)
// ============================================================
//
/// StateNotifier manages the state and contains all the business logic
///
/// WHAT IS StateNotifier?
/// - It's a class that holds and modifies state
/// - Similar to GetX Controller, but more structured
/// - State can only be changed inside the notifier (immutable from outside)
///
/// WHY USE StateNotifier?
/// - Clear separation: UI reads state, Notifier changes state
/// - Predictable: State only changes through defined methods
/// - Testable: Easy to test without UI
class LoginNotifier extends StateNotifier<LoginState> {
  // Constructor - initializes with default state
  LoginNotifier(this._authService, this._localStorage)
      : super(const LoginState()) {
    // Check if user is already logged in when notifier is created
    checkLoginStatus();
  }

  // Dependencies (injected via providers)
  final AuthService _authService;
  final TLocalStorage _localStorage;

  // ============================================================
  // FORM CONTROLLERS
  // ============================================================
  // Note: TextEditingControllers are not part of state in Riverpod
  // They're created in the widget and passed to methods
  // This is because controllers have lifecycle (need to be disposed)

  // ============================================================
  // MAIN LOGIN METHOD
  // ============================================================
  ///
  /// This is called when user taps the "Login" button
  ///
  /// RIVERPOD PATTERN:
  /// 1. Update state to show loading
  /// 2. Call service (async operation)
  /// 3. Update state with result (success or error)
  /// 4. Return result so UI can react (navigate, show message)
  ///
  /// Notice: We don't navigate or show snackbars here!
  /// The UI will do that based on the return value
  /// This keeps the business logic separate from UI logic
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      TLoggerHelper.info('Starting login process for: $email');

      // STEP 1: Update state to show loading
      // This will trigger UI to show loading spinner
      state = state.copyWith(isLoading: true, clearError: true);

      // STEP 2: Call the API
      final response = await _authService.login(
        email: email.trim(),
        password: password,
      );

      // STEP 3: Handle the response
      if (response.success && response.data != null) {
        // LOGIN SUCCESS! 🎉

        TLoggerHelper.info('Login successful');

        // Save user data to local storage
        await _saveUserData(response.data!);

        // Update state with user data and stop loading
        state = state.copyWith(
          isLoading: false,
          user: response.data,
          clearError: true,
        );

        // Return true to indicate success
        // The UI will handle navigation
        return true;
      } else {
        // LOGIN FAILED ❌

        TLoggerHelper.warning('Login failed: ${response.error}');

        // Update state with error message and stop loading
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.error ?? 'Login failed',
        );

        // Return false to indicate failure
        return false;
      }
    } catch (e) {
      // UNEXPECTED ERROR

      TLoggerHelper.error('Login error: $e');

      // Update state with error and stop loading
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred. Please try again.',
      );

      return false;
    }
  }

  // ============================================================
  // HELPER METHODS
  // ============================================================

  /// Toggle password visibility
  /// Called when user taps the eye icon
  void togglePasswordVisibility() {
    state = state.copyWith(hidePassword: !state.hidePassword);
  }

  /// Clear error message
  /// Useful when user starts typing again
  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(clearError: true);
    }
  }

  /// Save user data to local storage
  /// Keeps user logged in even after closing the app
  Future<void> _saveUserData(UserModel user) async {
    try {
      await _localStorage.saveData('user', user.toJson());
      // In real app, also save token:
      // await _localStorage.saveData('auth_token', token);
      TLoggerHelper.info('User data saved to local storage');
    } catch (e) {
      TLoggerHelper.error('Error saving user data: $e');
    }
  }

  /// Check if user is already logged in
  /// Called when app starts
  Future<void> checkLoginStatus() async {
    try {
      final userData = _localStorage.readData<Map<String, dynamic>>('user');

      if (userData != null) {
        final user = UserModel.fromJson(userData);
        state = state.copyWith(user: user);
        TLoggerHelper.info('User already logged in: ${user.username}');
      } else {
        TLoggerHelper.info('No logged-in user found');
      }
    } catch (e) {
      TLoggerHelper.error('Error checking login status: $e');
    }
  }

  /// Logout user
  /// Clears all stored data and resets state
  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true);

      // Clear local storage
      await _localStorage.removeData('user');
      await _localStorage.removeData('auth_token');

      // Reset state
      state = const LoginState();

      TLoggerHelper.info('User logged out successfully');
    } catch (e) {
      TLoggerHelper.error('Logout error: $e');
      state = state.copyWith(isLoading: false);
    }
  }
}

// ============================================================
// 3. PROVIDERS (How to access state in your app)
// ============================================================
//
/// WHAT IS A PROVIDER?
/// A provider is like a global variable that:
/// - Can be accessed from anywhere in the app
/// - Automatically rebuilds widgets when it changes
/// - Is type-safe and compile-time checked
/// - Can depend on other providers
///
/// PROVIDER TYPES IN RIVERPOD:
/// - Provider: For objects that never change
/// - StateProvider: For simple state (like a counter)
/// - StateNotifierProvider: For complex state with logic
/// - FutureProvider: For async operations that run once
/// - StreamProvider: For streams of data

/// Auth Service Provider
/// Provides a single instance of AuthService to the app
///
/// WHY MAKE THIS A PROVIDER?
/// - Single instance (singleton pattern)
/// - Can be easily mocked for testing
/// - Can be accessed from any provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Local Storage Provider
/// Provides a single instance of TLocalStorage
final localStorageProvider = Provider<TLocalStorage>((ref) {
  return TLocalStorage();
});

/// Login State Provider
/// This is the main provider that manages login state
///
/// HOW TO USE IN YOUR WIDGETS:
/// ```dart
/// // Read the current state
/// final loginState = ref.watch(loginStateProvider);
///
/// // Call a method on the notifier
/// ref.read(loginStateProvider.notifier).login(email, password);
/// ```
///
/// StateNotifierProvider has TWO parts:
/// 1. loginStateProvider - gives you the STATE (LoginState)
/// 2. loginStateProvider.notifier - gives you the NOTIFIER (LoginNotifier)
///
/// PATTERN:
/// - Use ref.watch() to READ state and REBUILD when it changes
/// - Use ref.read() to CALL methods without rebuilding
final loginStateProvider =
    StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  // Get dependencies from other providers
  final authService = ref.watch(authServiceProvider);
  final localStorage = ref.watch(localStorageProvider);

  // Create and return the notifier with dependencies
  return LoginNotifier(authService, localStorage);
});

// ============================================================
// 4. HELPER PROVIDERS (Optional but useful)
// ============================================================

/// Current User Provider
/// A simple way to check if user is logged in
///
/// Example usage:
/// ```dart
/// final user = ref.watch(currentUserProvider);
/// if (user != null) {
///   // User is logged in
/// }
/// ```
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(loginStateProvider).user;
});

/// Is Loading Provider
/// A simple way to check if login is in progress
///
/// Example usage:
/// ```dart
/// final isLoading = ref.watch(isLoadingProvider);
/// if (isLoading) {
///   return CircularProgressIndicator();
/// }
/// ```
final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(loginStateProvider).isLoading;
});

// ============================================================
// KEY DIFFERENCES: RIVERPOD vs GETX
// ============================================================
//
// GetX:
// - controller.isLoading.value = true;
// - Obx(() => widget)
// - Get.put(Controller())
//
// Riverpod:
// - state = state.copyWith(isLoading: true);
// - ref.watch(provider)
// - Providers are automatically managed
//
// ============================================================
// RIVERPOD ADVANTAGES
// ============================================================
//
// 1. COMPILE-TIME SAFETY
//    - Typos and errors caught before running
//    - Better IDE autocomplete
//
// 2. NO CONTEXT NEEDED
//    - Can use providers anywhere, not just in widgets
//    - Can call providers from other providers
//
// 3. TESTABILITY
//    - Easy to override providers in tests
//    - No need to mock complex controller initialization
//
// 4. IMMUTABLE STATE
//    - State can only change through defined methods
//    - Easier to debug and reason about
//
// 5. BETTER DEVTOOLS
//    - Riverpod has excellent debugging tools
//    - Can see all providers and their state
//
// ============================================================
