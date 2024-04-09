import 'package:BillPoint/utils/constants/colors.dart';
import 'package:BillPoint/utils/constants/image_strings.dart';
import 'package:BillPoint/utils/constants/sizes.dart';
import 'package:BillPoint/utils/constants/text_strings.dart';
import 'package:BillPoint/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      TImages.user,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        TTexts.tUsername,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        TTexts.tProfession,
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              const Row(
                children: [
                  Icon(
                    Iconsax.call,
                  ),
                  SizedBox(
                    width: TSizes.spaceBtwItems,
                  ),
                  Text(
                    TTexts.tProfilePhone,
                  ),
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              const Row(
                children: [
                  Icon(
                    Iconsax.sms,
                  ),
                  SizedBox(
                    width: TSizes.spaceBtwItems,
                  ),
                  Text(
                    TTexts.tUserEmail,
                  ),
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              Divider(
                thickness: 1,
                color: dark ? TColors.lightGrey : TColors.darkGrey,
              ),
              Center(
                child: Text(
                  TTexts.tUserAddress,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Center(
                child: Text(
                  TTexts.tUserAddressDetail,
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              Divider(
                thickness: 1,
                color: dark ? TColors.lightGrey : TColors.darkGrey,
              ),
              Row(
                children: [
                  const Icon(
                    Iconsax.logout,
                    color: TColors.primary,
                  ),
                  const SizedBox(
                    width: TSizes.spaceBtwItems,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      TTexts.logOut,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
