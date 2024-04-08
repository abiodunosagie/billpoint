import 'package:BillPoint/screens/features/home/homescreen.dart';
import 'package:BillPoint/screens/features/signup/signup_screen.dart';
import 'package:BillPoint/utils/constants/colors.dart';
import 'package:BillPoint/utils/constants/sizes.dart';
import 'package:BillPoint/utils/constants/text_strings.dart';
import 'package:BillPoint/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
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
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: dark ? TColors.light : TColors.darkGrey,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Iconsax.lock,
                        ),
                        suffixIcon: const Icon(
                          Iconsax.eye,
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
                  onPressed: () => Get.offAll(
                    () => const HomeScreen(),
                  ),
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
