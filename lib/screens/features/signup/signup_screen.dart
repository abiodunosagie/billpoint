import 'package:BillPoint/controllers/signup_controller.dart';
import 'package:BillPoint/utils/helpers/helper_functions.dart';
import 'package:BillPoint/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: dark ? TColors.light : TColors.darkerGrey,
        ),
        title: const Text(
          TTexts.createAccount,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    TTexts.signupTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Text(
                    TTexts.signupSubTitle,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections * 2,
                  ),
                  Form(
                    key: controller.signupFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextFormField(
                          controller: controller.username,
                          validator: (value) =>
                              TValidator.validateEmptyText('Username', value),
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: dark ? TColors.light : TColors.darkGrey,
                            )),
                            prefixIcon: const Icon(
                              Iconsax.user,
                            ),
                            hintText: 'Username',
                          ),
                        ),
                        const SizedBox(
                          height: TSizes.spaceBtwItems,
                        ),
                        TextFormField(
                          validator: (value) => TValidator.validateEmail(value),
                          controller: controller.email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: dark ? TColors.light : TColors.darkGrey,
                            )),
                            prefixIcon: const Icon(
                              Iconsax.message,
                            ),
                            hintText: 'Email',
                          ),
                        ),
                        const SizedBox(
                          height: TSizes.spaceBtwItems,
                        ),
                        TextFormField(
                          validator: (value) =>
                              TValidator.validatePhoneNumber(value),
                          controller: controller.phoneNumber,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: dark ? TColors.light : TColors.darkGrey,
                            )),
                            prefixIcon: const Icon(
                              Iconsax.call,
                            ),
                            hintText: 'Phone Number',
                          ),
                        ),
                        const SizedBox(
                          height: TSizes.spaceBtwItems,
                        ),
                        Obx(
                          () => TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              } else if (value != 'pistol' &&
                                  value.length < 6) {
                                return 'Password must be at least 6 characters long or use the specific password provided by ReqRes.in';
                              }
                              return null;
                            },
                            controller: controller.password,
                            obscureText: controller.hidePassword.value,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      dark ? TColors.light : TColors.darkGrey,
                                ),
                              ),
                              prefixIcon: const Icon(
                                Iconsax.lock,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () => controller.hidePassword.value =
                                    !controller.hidePassword.value,
                                icon: Icon(
                                  controller.hidePassword.value
                                      ? Iconsax.eye_slash
                                      : Iconsax.eye,
                                ),
                              ),
                              hintText: 'Password',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: TSizes.spaceBtwItems,
                        ),
                        TextFormField(
                          validator: (value) =>
                              TValidator.validateEmptyText('Address', value),
                          controller: controller.address,
                          keyboardType: TextInputType.streetAddress,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: dark ? TColors.light : TColors.darkGrey,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Iconsax.location,
                            ),
                            hintText: 'Address',
                          ),
                        ),
                        const SizedBox(
                          height: TSizes.spaceBtwItems,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.signupFormKey.currentState!.validate()) {
                          controller.signup();
                        }
                      },
                      child: const Text(
                        TTexts.tContinue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
