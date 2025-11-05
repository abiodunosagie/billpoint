import 'package:BillPoint/screens/features/signup/signup_screen.dart';
import 'package:BillPoint/utils/constants/colors.dart';
import 'package:BillPoint/utils/constants/sizes.dart';
import 'package:BillPoint/utils/constants/text_strings.dart';
import 'package:BillPoint/utils/helpers/helper_functions.dart';
import 'package:BillPoint/utils/validators/validation.dart';
import 'package:BillPoint/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

/// ============================================================
/// LOGIN SCREEN WITH API INTEGRATION
/// ============================================================
///
/// This is an example of how to connect your UI to a controller
/// and integrate with an API
///
/// Key concepts demonstrated:
/// 1. GetX controller initialization with Get.put()
/// 2. Using controller's TextEditingControllers for inputs
/// 3. Reactive UI with Obx() widget
/// 4. Loading states
/// 5. Form validation
/// 6. Password visibility toggle

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // ============================================================
    // STEP 1: Initialize the controller
    // ============================================================
    // Get.put() creates an instance of LoginController and makes it available
    // throughout this screen. You can access it anywhere with Get.find<LoginController>()
    final controller = Get.put(LoginController());
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
              // STEP 2: Wrap form with formKey for validation
              // ============================================================
              Form(
                key: controller.formKey, // This enables form validation
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // ============================================================
                    // EMAIL FIELD
                    // ============================================================
                    // Using TextFormField instead of TextField to enable validation
                    TextFormField(
                      controller: controller.emailController, // Controller from LoginController
                      keyboardType: TextInputType.emailAddress,
                      // Validation happens here when form.validate() is called
                      validator: (value) => TValidator.validateEmail(value),
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
                    // Obx() makes this widget reactive to controller.hidePassword changes
                    Obx(
                      () => TextFormField(
                        controller: controller.passwordController,
                        // hidePassword is reactive - when it changes, UI rebuilds
                        obscureText: controller.hidePassword.value,
                        validator: (value) => TValidator.validatePassword(value),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: dark ? TColors.light : TColors.darkGrey,
                            ),
                          ),
                          prefixIcon: const Icon(
                            Iconsax.lock,
                          ),
                          // Toggle password visibility when eye icon is tapped
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.hidePassword.value
                                  ? Iconsax.eye_slash
                                  : Iconsax.eye,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                          hintText: 'Password',
                        ),
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
              // STEP 3: LOGIN BUTTON WITH LOADING STATE
              // ============================================================
              // Obx() watches controller.isLoading and rebuilds when it changes
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // Disable button when loading to prevent multiple submissions
                    onPressed: controller.isLoading.value ? null : controller.login,
                    child: controller.isLoading.value
                        // Show loading indicator when API call is in progress
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        // Show button text when not loading
                        : const Text(TTexts.tContinue),
                  ),
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              // ============================================================
              // ERROR MESSAGE DISPLAY (Optional)
              // ============================================================
              // Shows error message if login fails
              Obx(
                () => controller.errorMessage.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
                        child: Text(
                          controller.errorMessage.value,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox.shrink(),
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
/// KEY TAKEAWAYS FROM THIS IMPLEMENTATION
/// ============================================================
///
/// 1. CONTROLLER PATTERN:
///    - All logic is in LoginController
///    - UI just displays data and calls controller methods
///    - This makes code clean and testable
///
/// 2. REACTIVE STATE MANAGEMENT:
///    - Obx() widget watches reactive variables (.obs)
///    - When variable changes, only that Obx() widget rebuilds
///    - Efficient and automatic UI updates
///
/// 3. FORM VALIDATION:
///    - TextFormField with validator functions
///    - Form key enables form.validate() in controller
///    - Validators are reusable across the app
///
/// 4. LOADING STATES:
///    - isLoading controls button state
///    - Shows spinner during API call
///    - Prevents multiple submissions
///
/// 5. ERROR HANDLING:
///    - Errors shown via snackbar (in controller)
///    - Optional error text display in UI
///    - User gets clear feedback
///
/// This same pattern can be applied to ANY screen with API integration!
