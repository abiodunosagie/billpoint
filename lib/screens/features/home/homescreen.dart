import 'package:BillPoint/screens/features/home/widgets/funding_page.dart';
import 'package:BillPoint/utils/constants/colors.dart';
import 'package:BillPoint/utils/constants/image_strings.dart';
import 'package:BillPoint/utils/constants/sizes.dart';
import 'package:BillPoint/utils/constants/text_strings.dart';
import 'package:BillPoint/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

import '../../../controllers/login_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Fund Bottom Sheet Function
  void _openFundButtonSheet() {
    showModalBottomSheet(
      elevation: 10,
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: [
            Container(
              // height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    TTexts.addMoneyTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Text(
                    TTexts.addMoneySubTitle,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.height * 0.150,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: TColors.darkGrey,
                              ),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(20),
                              color: TColors.buttonDisabled,
                            ),
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  TTexts.phoneNumberTitle,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: TSizes.spaceBtwItems,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.height * 0.150,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(20),
                              color: TColors.primary,
                            ),
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  TTexts.accountNumberTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .apply(
                                        color: TColors.white,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                  const Image(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      TImages.bankBanner,
                    ),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: TColors.accent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          TTexts.accountNumberTitle,
                          style: Theme.of(context).textTheme.bodyMedium!.apply(
                                color: TColors.darkGrey,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: TColors.accent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          TTexts.accountNumberTitle,
                          style: Theme.of(context).textTheme.bodyMedium!.apply(
                                color: TColors.darkGrey,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(LoginController());
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Iconsax.home,
              color: TColors.darkGrey,
            ),
            label: 'Home',
            activeIcon: Icon(
              Iconsax.home,
              color: TColors.primary,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Iconsax.shop,
              color: TColors.darkGrey,
            ),
            label: 'Services',
            activeIcon: Icon(
              Iconsax.home,
              color: TColors.primary,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Iconsax.wallet,
              color: TColors.darkGrey,
            ),
            label: 'Wallet',
            activeIcon: Icon(
              Iconsax.home,
              color: TColors.primary,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Iconsax.user,
              color: TColors.darkGrey,
            ),
            label: 'Profile',
            activeIcon: Icon(
              Iconsax.home,
              color: TColors.primary,
            ),
          ),
        ],
        elevation: 5,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: TColors.primary,
        unselectedItemColor: TColors.darkGrey,
        unselectedLabelStyle: const TextStyle(
          color: TColors.darkGrey,
        ),
        selectedLabelStyle: const TextStyle(
          color: TColors.darkGrey,
        ),
        onTap: _onItemTapped,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.logout();
                      },
                      child: const CircleAvatar(
                        radius: 25,
                        backgroundColor: TColors.white,
                        backgroundImage: AssetImage(
                          TImages.user,
                        ),
                      ),
                    ),
                    const CircleAvatar(
                      radius: 25,
                      child: Icon(
                        Iconsax.notification,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: TSizes.spaceBtwItems,
                ),
                Text(
                  TTexts.greetingTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  TTexts.greetingSubTitle,
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: TColors.darkerGrey,
                      ),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: TColors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          TTexts.homscreenBalanceTextOne,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              TTexts.homscreenBalanceTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .apply(
                                    color: dark
                                        ? TColors.white
                                        : TColors.darkerGrey,
                                  ),
                            ),
                            const SizedBox(
                              width: TSizes.spaceBtwItems,
                            ),
                            const Icon(Iconsax.eye_slash),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FundingPage(
                              buttonOnTap: () {},
                              icon: Iconsax.bank,
                              buttonText: TTexts.accountTitle,
                            ),
                            FundingPage(
                              buttonOnTap: () {
                                _openFundButtonSheet();
                              },
                              icon: Iconsax.add,
                              buttonText: TTexts.addTitle,
                            ),
                            FundingPage(
                              buttonOnTap: () {},
                              icon: Iconsax.send,
                              buttonText: TTexts.sendTitle,
                            ),
                            FundingPage(
                              buttonOnTap: () {},
                              icon: Iconsax.convert,
                              buttonText: TTexts.convertTitle,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: TSizes.spaceBtwItems,
                        ),
                        const Divider(
                          thickness: 1,
                          color: TColors.grey,
                        ),
                        const SizedBox(
                          height: TSizes.spaceBtwItems,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              TTexts.recentTransactionTitle,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                TTexts.seeAllTitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .apply(
                                      color: Colors.blue,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: TSizes.spaceBtwSections,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Iconsax.receipt,
                                color: TColors.grey,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                TTexts.transactionTitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .apply(color: TColors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                const Text(
                  TTexts.actionTitle,
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FundingPage(
                      buttonOnTap: () {},
                      buttonColor: TColors.primary,
                      buttonText: TTexts.airtimeTitle,
                      icon: Iconsax.call,
                    ),
                    FundingPage(
                      buttonOnTap: () {},
                      buttonColor: TColors.primary,
                      buttonText: TTexts.dataTitle,
                      icon: Iconsax.share,
                    ),
                    FundingPage(
                      buttonOnTap: () {},
                      buttonColor: TColors.primary,
                      buttonText: TTexts.cableTvTitle,
                      icon: Iconsax.monitor,
                    ),
                    FundingPage(
                      buttonOnTap: () {},
                      buttonColor: TColors.primary,
                      buttonText: TTexts.moreTitle,
                      icon: Iconsax.more,
                    ),
                  ],
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: TColors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              TTexts.recentActivityTitle,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                TTexts.seeAllTitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .apply(
                                      color: Colors.blue,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: TSizes.spaceBtwSections,
                            ),
                            SizedBox(
                              height: 200,
                              width: 200,
                              child: Lottie.asset(
                                TImages.loadingAnim,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              TTexts.recentTextSubTitle,
                              style:
                                  Theme.of(context).textTheme.bodyMedium!.apply(
                                        color: TColors.darkGrey,
                                      ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
