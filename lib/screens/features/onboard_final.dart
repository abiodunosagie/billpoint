import 'package:BillPoint/screens/features/login/login_screen.dart';
import 'package:BillPoint/screens/features/signup/signup_screen.dart';
import 'package:BillPoint/utils/constants/colors.dart';
import 'package:BillPoint/utils/constants/image_strings.dart';
import 'package:BillPoint/utils/constants/sizes.dart';
import 'package:BillPoint/utils/constants/text_strings.dart';
import 'package:BillPoint/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardFinalScreen extends StatefulWidget {
  const OnboardFinalScreen({super.key});

  @override
  State<OnboardFinalScreen> createState() => _OnboardFinalScreenState();
}

class _OnboardFinalScreenState extends State<OnboardFinalScreen> {
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(
                flex: 1,
              ),

              Image(
                width: dark ? 200 : 100,
                height: dark ? 200 : 100,
                image: AssetImage(
                  dark ? TImages.darkAppLogo : TImages.lightAppLogo,
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              Text(
                TTexts.onboardingFinalWelcomeTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              Text(
                TTexts.onboardingFinalWelcomeSubTitle,
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: dark ? TColors.darkGrey : TColors.darkerGrey,
                    ),
                textAlign: TextAlign.center,
              ),
              // const SizedBox(
              //   height: TSizes.spaceBtwSections * 4,
              // ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 0),
                  onPressed: () => Get.to(
                    () => const LoginScreen(),
                  ),
                  child: const Text(
                    TTexts.signIn,
                  ),
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    elevation: 0,
                    side: BorderSide(
                      color: dark ? TColors.primary : TColors.darkGrey,
                    ),
                  ),
                  onPressed: () => Get.to(
                    () => const SignupScreen(),
                  ),
                  child: const Text(TTexts.createAccount),
                ),
              ),
              const Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
