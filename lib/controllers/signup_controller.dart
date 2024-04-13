import 'package:BillPoint/utils/constants/image_strings.dart';
import 'package:BillPoint/utils/popups/fullscreen_loader.dart';
import 'package:BillPoint/utils/popups/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../utils/http/network_manager.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  /// Variables
  final username = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();
  final address = TextEditingController();
  final hidePassword = true.obs; // Observable for hiding/showing password.
  GlobalKey<FormState> signupFormKey =
      GlobalKey<FormState>(); // Form key for form validation

  /// -- Signup
  Future<void> signup() async {
    try {
      // Starts loading
      TFullScreenLoader.openLoadingDialog(
          'We are processing your information', TImages.loadingAnim);
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;
      // Form Validation
      if (signupFormKey.currentState!.validate()) return;
      // Privacy Policy Check

      // Register user in the Endpoint & save user data in the api given

      // Save authenticated user data in the api end-point

      // Show success Message

      // Move to verify email screen
    } catch (e) {
      // Show some generic error to the user
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      // Remove loader
      TFullScreenLoader.stopLoading();
    }
  }
}
