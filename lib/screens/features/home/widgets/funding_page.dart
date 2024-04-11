import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';

class fundingPage extends StatelessWidget {
  const fundingPage(
      {super.key,
      required this.buttonText,
      required this.icon,
      this.buttonOnTap,
      this.buttonColor = TColors.dark});
  final String buttonText;
  final IconData icon;
  final Color? buttonColor;
  final VoidCallback? buttonOnTap;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      children: [
        Container(
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
