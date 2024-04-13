import 'package:BillPoint/screens/features/onboarding/onboarding.dart';
import 'package:BillPoint/utils/constants/text_strings.dart';
import 'package:BillPoint/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'bindings/general_bindings.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: TTexts.appName,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialBinding: GeneralBindings(),
      home: const Scaffold(
        body: OnboardingScreen(),
      ),
    );
  }
}
