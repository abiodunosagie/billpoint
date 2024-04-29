import 'package:BillPoint/controllers/login_controller.dart';
import 'package:BillPoint/screens/features/signup/signup_screen.dart';
import 'package:BillPoint/utils/constants/colors.dart';
import 'package:BillPoint/utils/constants/sizes.dart';
import 'package:BillPoint/utils/constants/text_strings.dart';
import 'package:BillPoint/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/validators/validation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
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
              Form(
                key: controller.loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                      validator: (value) => TValidator.validateEmail(value),
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: dark ? TColors.light : TColors.darkGrey,
                        )),
                        prefixIcon: const Icon(
                          Iconsax.user,
                        ),
                        hintText: 'Email',
                      ),
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),
                    TextFormField(
                      validator: (value) => TValidator.validatePassword(value),
                      controller: controller.passwordController,
                      obscureText: controller.loginHidePassword.value,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: dark ? TColors.light : TColors.darkGrey,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Iconsax.lock,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => controller.loginHidePassword.value =
                              !controller.loginHidePassword.value,
                          icon: Icon(
                            controller.loginHidePassword.value
                                ? Iconsax.eye_slash
                                : Iconsax.eye,
                          ),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.loginWithEmail(),
                  child: const Text(
                    TTexts.tContinue,
                  ),
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(TTexts.dontHaveAnAccount),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () => Get.off(() => const SignupScreen()),
                    child: Text(
                      TTexts.createAccount,
                      style: Theme.of(context).textTheme.bodyMedium!.apply(
                            color: TColors.primary,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
