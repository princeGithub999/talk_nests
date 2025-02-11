import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talk_nest/utils/constants/app_string.dart';
import 'package:talk_nest/utils/constants/colors.dart';
import 'package:talk_nest/utils/constants/images.dart';
import 'package:talk_nest/utils/globle_widget/button_widget.dart';
import 'package:talk_nest/utils/globle_widget/text_from_widget.dart';
import 'package:talk_nest/view/auth/forgot_password.dart';
import 'package:talk_nest/view/auth/sign_up_page.dart';
import '../../utils/helpers/helper_functions.dart';
import '../../view_model/app_validation/validation.dart';
import '../../view_model/provider/auth_provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final sizes = MediaQuery.of(context).size;
    final dark = AppHelperFunctions.isDarkMode(context);

    return Consumer<AuthProviderIn>(
      builder: (BuildContext context, authProvider, Widget? child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipPath(
                      clipper: Blue100Clipper(),
                      child: Container(
                        height: sizes.height * 0.33,
                        color: dark ? AppColors.black700 : AppColors.blue100,
                      ),
                    ),
                    ClipPath(
                      clipper: LightBlueClipper(),
                      child: Container(
                        height: sizes.height * 0.30,
                        color: dark ? AppColors.blue900 : AppColors.lightBlue,
                      ),
                    ),
                    Positioned(
                      top: sizes.height * 0.1,
                      left: sizes.height * 0.2 - 18,
                      child: Image.asset(
                        AppImage.messageImage,
                        width: sizes.width * 0.2,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: sizes.width * 0.1 - 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppString.signIn,
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                              Text(
                                AppString.welcome,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          ButtonWidget.googleAuthButton(() {}),
                        ],
                      ),
                      SizedBox(
                        height: sizes.height * 0.1 - 40,
                      ),
                      Form(
                          key: fromKey,
                          child: Column(
                            children: [
                              TextFromPage.buildTextField(
                                controller: authProvider.emailController,
                                hintText: AppString.emailHintText,
                                context: context,
                                icons: const Icon(Icons.email_outlined),
                                inputType: TextInputType.emailAddress,
                                validator: (value) {
                                  return Validation.validateEmail(value);
                                },
                              ),
                              SizedBox(
                                height: sizes.height * 0.1 - 60,
                              ),
                              TextFromPage.buildTextField(
                                controller: authProvider.passwordController,
                                hintText: AppString.passwordHintText,
                                context: context,
                                icons: const Icon(Icons.password),
                                inputType: TextInputType.visiblePassword,
                                validator: (value) {
                                  return Validation.validatePassword(value);
                                },
                              ),
                            ],
                          )),
                      SizedBox(height: sizes.height * 0.2 - 10),
                      ButtonWidget.signInButton(() {
                        if (fromKey.currentState!.validate()) {
                          authProvider.setErrorMessage('');
                          authProvider.signInUser(
                              context,
                              authProvider.emailController.text,
                              authProvider.passwordController.text);
                        } else {
                          authProvider
                              .setErrorMessage('Please fix the errors above');
                        }
                      }),
                      Align(
                        alignment: Alignment.topRight,
                        child: ButtonWidget.textButton(() {
                          AppHelperFunctions.navigateToScreen(
                              context, ForgotPassword());
                        }, AppString.forgotPasswordText),
                      ),
                      SizedBox(
                        height: sizes.height * 0.1 - 60,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppString.dontHaveAccount,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                              onTap: () {
                                AppHelperFunctions
                                    .navigateToScreenBeforeEndPage(
                                        context, const SignUpPage());
                              },
                              child: const Text(
                                AppString.signUp,
                                style: TextStyle(color: AppColors.error),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LightBlueClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height * 0.42);
    path.quadraticBezierTo(
        size.width * 0.50, size.height, size.width, size.height * 0.45);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class Blue100Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height * 0.50);
    path.quadraticBezierTo(
        size.width * 0.50, size.height, size.width, size.height * 0.55);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
