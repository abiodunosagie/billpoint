import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';

class FundingPage extends StatelessWidget {
  const FundingPage(
      {super.key,
      required this.buttonText,
      required this.icon,
      required this.buttonOnTap,
      this.buttonColor = TColors.dark});
  final String buttonText;
  final IconData icon;
  final Color? buttonColor;
  final VoidCallback buttonOnTap;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      children: [
        GestureDetector(
          onTap: buttonOnTap,
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: buttonColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                color: dark ? TColors.light : TColors.white,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: TSizes.spaceBtwItems,
        ),
        Text(
          buttonText,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
