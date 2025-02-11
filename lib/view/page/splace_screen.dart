import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:talk_nest/utils/constants/app_animation.dart';
import 'package:talk_nest/utils/constants/app_string.dart';
import 'package:talk_nest/utils/constants/images.dart';
import 'package:talk_nest/utils/constants/sizes.dart';
import 'package:talk_nest/utils/helpers/helper_functions.dart';

class SplaceScreen extends StatefulWidget {
  const SplaceScreen({super.key});

  @override
  State<SplaceScreen> createState() => _SplaceScreenState();
}

class _SplaceScreenState extends State<SplaceScreen> {
  @override
  void initState() {
    super.initState();
    AppHelperFunctions.splaceController(context);
  }

  @override
  Widget build(BuildContext context) {
    final sizes = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImage.messageImage,
                height: sizes.height * 0.1 - 50,
              ),
              const SizedBox(
                width: AppSizes.defaultSpacing,
              ),
              Text(
                AppString.appName,
                style: Theme.of(context).textTheme.headlineMedium,
              )
            ],
          ),
          Lottie.asset(AppAnimation.laptopWithBoyAni,
              height: sizes.height * 0.3),
          Lottie.asset(AppAnimation.threeDoteLoder, height: sizes.height * 0.1),
        ],
      ),
    );
  }
}
