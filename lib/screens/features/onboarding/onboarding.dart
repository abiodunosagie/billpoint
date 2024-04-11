import 'package:BillPoint/screens/features/onboarding/onboard_final.dart';
import 'package:BillPoint/utils/constants/image_strings.dart';
import 'package:BillPoint/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import 'onboarding_controller.dart';
import 'onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(OnBoardingController());
    return Scaffold(
      backgroundColor: dark ? TColors.dark : TColors.light,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Column(
                children: [
                  Image(
                    height: 80,
                    width: 80,
                    image: AssetImage(
                      dark ? TImages.darkAppLogo : TImages.lightAppLogo,
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: controller.pageController,
                      onPageChanged: controller.updatePageIndicator,
                      children: const [
                        OnboardingPage(
                          image: TImages.payment,
                          title: TTexts.onBoardingTitle1,
                          subTitle: TTexts.onBoardingSubTitle1,
                        ),
                        OnboardingPage(
                          image: TImages.trust,
                          title: TTexts.onBoardingTitle2,
                          subTitle: TTexts.onBoardingSubTitle2,
                        ),
                        OnboardingPage(
                          image: TImages.refer,
                          title: TTexts.onBoardingTitle3,
                          subTitle: TTexts.onBoardingSubTitle3,
                        ),
                      ],
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: controller.pageController,
                    count: 3,
                    onDotClicked: controller.dotNavigationClick,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: TColors.primary,
                      dotColor: TColors.grey,
                      dotHeight: 6,
                      dotWidth: 5,
                    ),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                    height: MediaQuery.of(context).size.width * 0.20,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: TColors.primary,
                    ),
                    child: IconButton(
                      onPressed: () => Get.off(
                        () => const OnboardFinalScreen(),
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: TColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
