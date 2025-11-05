import 'package:BillPoint/screens/features/signup/signup_screen.dart';
import 'package:BillPoint/utils/constants/colors.dart';
import 'package:BillPoint/utils/constants/sizes.dart';
import 'package:BillPoint/utils/constants/text_strings.dart';
import 'package:BillPoint/utils/helpers/helper_functions.dart';
import 'package:BillPoint/utils/validators/validation.dart';
import 'package:BillPoint/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

/// ============================================================
/// LOGIN SCREEN WITH RIVERPOD STATE MANAGEMENT
/// ============================================================
///
/// This is a complete example of API integration using Riverpod
///
/// KEY RIVERPOD CONCEPTS DEMONSTRATED:
///
/// 1. ConsumerStatefulWidget - Like StatefulWidget but with Riverpod
/// 2. ref.watch() - Listens to provider changes and rebuilds UI
/// 3. ref.read() - Reads provider without listening (for one-time calls)
/// 4. WidgetRef - Object that gives access to providers
///
/// ============================================================
/// RIVERPOD WIDGET TYPES:
/// ============================================================
///
/// 1. ConsumerWidget (Stateless + Riverpod)
///    - Use when you don't need local state or lifecycle
///    - Like StatelessWidget but has access to ref
///
/// 2. ConsumerStatefulWidget (Stateful + Riverpod)
///    - Use when you need local state (like TextEditingControllers)
///    - Like StatefulWidget but has access to ref
///
/// 3. Consumer (Just a widget)
///    - Use to wrap specific parts of widget tree
///    - Useful when only part of widget needs to rebuild
///
/// We use ConsumerStatefulWidget here because we need:
/// - TextEditingControllers (local state)
/// - Lifecycle methods (dispose controllers)
/// - Access to Riverpod providers (ref)
///
/// ============================================================

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

/// ============================================================
/// CONSUMER STATE - Widget State with Riverpod Access
/// ============================================================
///
/// Notice: ConsumerState<LoginScreen> instead of State<LoginScreen>
///
/// This gives us access to 'ref' which lets us:
/// - ref.watch(provider) - Listen to provider and rebuild when it changes
/// - ref.read(provider) - Read provider once without listening
/// - ref.listen(provider, callback) - Run side effects when provider changes
///
class _LoginScreenState extends ConsumerState<LoginScreen> {
  // ============================================================
  // LOCAL STATE (Widget-specific, not in Riverpod)
  // ============================================================
  //
  // TextEditingControllers are local to the widget because:
  // - They need to be disposed when widget is destroyed
  // - They're UI-specific (not business logic)
  // - Each TextField needs its own controller
  //
  // RULE: If it has a lifecycle (dispose), keep it in widget state

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // IMPORTANT: Always dispose controllers to prevent memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOGIN HANDLER
  // ============================================================
  //
  /// This method handles the login button press
  ///
  /// RIVERPOD PATTERN:
  /// 1. Validate form
  /// 2. Call notifier method using ref.read()
  /// 3. Handle result (navigate, show message)
  ///
  /// WHY ref.read()?
  /// - We're CALLING a method, not listening to state
  /// - ref.read() doesn't cause rebuilds
  /// - Use .notifier to access the LoginNotifier methods
  Future<void> _handleLogin() async {
    // STEP 1: Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // STEP 2: Call login method from provider
    // ref.read() gives us one-time access to the provider
    // .notifier gives us access to the LoginNotifier methods
    final success = await ref.read(loginStateProvider.notifier).login(
          email: _emailController.text,
          password: _passwordController.text,
        );

    // STEP 3: Handle result
    // Only navigate/show messages if the widget is still mounted
    if (!mounted) return;

    if (success) {
      // SUCCESS! Show success message
      Get.snackbar(
        'Success',
        'Login successful',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate to home screen
      // Note: We still use GetX for navigation (Riverpod doesn't handle navigation)
      Get.offAllNamed('/home');

      // Clear form fields
      _emailController.clear();
      _passwordController.clear();
    } else {
      // FAILURE! Error message is already in state
      // UI will show it automatically because ref.watch() is listening
      // But we can also show a snackbar
      final errorMessage = ref.read(loginStateProvider).errorMessage;
      Get.snackbar(
        'Login Failed',
        errorMessage ?? 'Please check your credentials',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ============================================================
    // WATCHING PROVIDERS
    // ============================================================
    //
    /// ref.watch() subscribes to provider changes
    /// When the provider's state changes, this widget rebuilds
    ///
    /// PERFORMANCE TIP:
    /// - Only watch what you need
    /// - Can watch specific parts: ref.watch(provider.select((s) => s.isLoading))
    /// - Or watch the whole state and access properties
    ///
    /// We watch the entire loginState here because multiple parts of UI
    /// need different pieces of state

    // Watch the login state
    // When state changes, this build method runs again
    final loginState = ref.watch(loginStateProvider);

    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: dark ? TColors.light : TColors.darkerGrey,
        ),
        title: const Text(
          TTexts.signIn,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                TTexts.signIn,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              const Text(
                TTexts.loginSubTitle,
              ),
              const Spacer(
                flex: 2,
              ),
              // ============================================================
              // FORM WITH VALIDATION
              // ============================================================
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // ============================================================
                    // EMAIL FIELD
                    // ============================================================
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => TValidator.validateEmail(value),
                      // Clear error when user starts typing
                      onChanged: (value) {
                        if (loginState.errorMessage != null) {
                          ref.read(loginStateProvider.notifier).clearError();
                        }
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: dark ? TColors.light : TColors.darkGrey,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Iconsax.direct,
                        ),
                        hintText: 'Email',
                      ),
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),
                    // ============================================================
                    // PASSWORD FIELD WITH VISIBILITY TOGGLE
                    // ============================================================
                    //
                    // Notice: We read hidePassword from loginState
                    // When user taps eye icon, state changes and this rebuilds
                    TextFormField(
                      controller: _passwordController,
                      // Read hidePassword state from provider
                      obscureText: loginState.hidePassword,
                      validator: (value) => TValidator.validatePassword(value),
                      onChanged: (value) {
                        if (loginState.errorMessage != null) {
                          ref.read(loginStateProvider.notifier).clearError();
                        }
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: dark ? TColors.light : TColors.darkGrey,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Iconsax.lock,
                        ),
                        // Toggle password visibility
                        suffixIcon: IconButton(
                          icon: Icon(
                            loginState.hidePassword
                                ? Iconsax.eye_slash
                                : Iconsax.eye,
                          ),
                          // Call togglePasswordVisibility on notifier
                          onPressed: () => ref
                              .read(loginStateProvider.notifier)
                              .togglePasswordVisibility(),
                        ),
                        hintText: 'Password',
                      ),
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),
                    Text(
                      TTexts.forgetPassword,
                      style: Theme.of(context).textTheme.bodyMedium!.apply(
                            color: TColors.primary,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              // ============================================================
              // LOGIN BUTTON WITH LOADING STATE
              // ============================================================
              //
              // The button changes based on loginState.isLoading
              // When isLoading changes, this widget rebuilds automatically
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // Disable button when loading
                  onPressed: loginState.isLoading ? null : _handleLogin,
                  child: loginState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(TTexts.tContinue),
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              // ============================================================
              // ERROR MESSAGE DISPLAY
              // ============================================================
              //
              // Automatically shows/hides based on state.errorMessage
              if (loginState.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
                  child: Text(
                    loginState.errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(TTexts.dontHaveAnAccount),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () => Get.to(
                      () => const SignupScreen(),
                    ),
                    child: Text(
                      TTexts.createAccount,
                      style: Theme.of(context).textTheme.bodyMedium!.apply(
                            color: TColors.primary,
                          ),
                    ),
                  ),
                ],
              ),
              const Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ============================================================
/// ALTERNATIVE: Using Consumer Widget for Specific Rebuilds
/// ============================================================
///
/// If you want to optimize performance and only rebuild specific parts,
/// you can use Consumer widget:
///
/// ```dart
/// Consumer(
///   builder: (context, ref, child) {
///     final isLoading = ref.watch(loginStateProvider).isLoading;
///     return ElevatedButton(
///       onPressed: isLoading ? null : _handleLogin,
///       child: isLoading ? CircularProgressIndicator() : Text('Login'),
///     );
///   },
/// )
/// ```
///
/// Or even more specific with select():
///
/// ```dart
/// final isLoading = ref.watch(
///   loginStateProvider.select((state) => state.isLoading)
/// );
/// ```
///
/// This way, the widget only rebuilds when isLoading changes,
/// not when other parts of state change.
///
/// ============================================================
/// KEY RIVERPOD PATTERNS USED IN THIS FILE:
/// ============================================================
///
/// 1. ConsumerStatefulWidget
///    - Provides access to ref
///    - Can have local state (controllers)
///
/// 2. ref.watch(provider)
///    - Subscribes to provider changes
///    - Rebuilds widget when state changes
///    - Use in build() method
///
/// 3. ref.read(provider)
///    - One-time read without listening
///    - Use in event handlers (onPressed, etc.)
///    - Use .notifier to call methods
///
/// 4. State Management Flow:
///    User Action → ref.read().notifier.method()
///    → Notifier updates state → ref.watch() rebuilds UI
///
/// ============================================================
/// RIVERPOD vs GETX COMPARISON (THIS SCREEN):
/// ============================================================
///
/// GetX:
/// - StatelessWidget
/// - Get.put(LoginController())
/// - Obx(() => widget)
/// - controller.isLoading.value
/// - controller.login()
///
/// Riverpod:
/// - ConsumerStatefulWidget
/// - ref.watch(loginStateProvider)
/// - No wrapper needed (direct use in build)
/// - loginState.isLoading
/// - ref.read(loginStateProvider.notifier).login()
///
/// ============================================================
