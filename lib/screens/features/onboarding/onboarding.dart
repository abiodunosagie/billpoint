import 'package:BillPoint/utils/constants/image_strings.dart';
import 'package:BillPoint/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import 'onboarding_controller.dart';

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
                  Expanded(
                    child: PageView(
                      controller: controller.pageController,
                      onPageChanged: controller.updatePageIndicator,
                      children: const [
                        OnboardingPage(
                          image: TImages.onBoardingImage1,
                          title: TTexts.onBoardingTitle1,
                          subTitle: TTexts.onBoardingSubTitle1,
                        ),
                        OnboardingPage(
                          image: TImages.onBoardingImage2,
                          title: TTexts.onBoardingTitle2,
                          subTitle: TTexts.onBoardingSubTitle2,
                        ),
                        OnboardingPage(
                          image: TImages.onBoardingImage3,
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      children: [
        /// Slide Image
        Container(
          margin: const EdgeInsets.all(10),
          height: 350,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                image,
              ),
            ),
            borderRadius: BorderRadius.circular(20),
            color: dark ? TColors.dark : TColors.white,
          ),
        ),
        const SizedBox(
          height: TSizes.defaultSpace,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),

        const SizedBox(
          height: TSizes.defaultSpace,
        ),
        Text(
          subTitle,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: TSizes.defaultSpace,
        ),
      ],
    );
  }
}
