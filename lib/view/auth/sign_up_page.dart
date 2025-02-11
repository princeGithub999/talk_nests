import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talk_nest/model/auth_model/auth_model.dart';
import 'package:talk_nest/utils/constants/app_string.dart';
import 'package:talk_nest/utils/constants/colors.dart';
import 'package:talk_nest/utils/globle_widget/sign_up_form.dart';
import 'package:talk_nest/utils/helpers/helper_functions.dart';
import 'package:talk_nest/view/auth/profile_image.dart';
import 'package:talk_nest/view/auth/sign_in_page.dart';
import '../../utils/globle_widget/button_widget.dart';
import '../../view_model/provider/auth_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final sizes = MediaQuery.of(context).size;
    final isDark = AppHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<AuthProviderIn>(
          builder: (BuildContext context, authProvider, Widget? child) {
            return Column(
              children: [
                Stack(
                  children: [
                    ClipPath(
                      clipper: CustomClipperBlue100(),
                      child: Container(
                          height: sizes.height * 0.3, color: AppColors.blue100),
                    ),
                    ClipPath(
                      clipper: CustomClipperDesign(),
                      child: Container(
                          height: sizes.height * 0.28,
                          color:
                              isDark ? AppColors.blue900 : AppColors.lightBlue),
                    ),
                    Positioned(
                      top: sizes.height * 0.1,
                      left: sizes.width * 0.1,
                      child: Text(
                        AppString.letsSignUpAccount,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: authProvider.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              AppString.helloUser,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            ProfileImage.profileImage()
                          ],
                        ),
                        SizedBox(height: sizes.height * 0.1 - 50),

                        const SignUpForm(),
                        SizedBox(height: sizes.height * 0.1 - 20),

                        ButtonWidget.signUpButton(() {
                          if (authProvider.formKey.currentState!.validate()) {
                            authProvider.setErrorMessage('');

                            var data = AuthModel(
                              userName: authProvider.userNameController.text,
                              userEmail: authProvider.emailController.text,
                              userAddress: authProvider.addressController.text,
                              userPassword:
                                  authProvider.passwordController.text,
                              userPhone: int.tryParse(
                                      authProvider.phoneController.text) ??
                                  0,
                            );

                            authProvider.signUpUser(context, data);
                          } else {
                            authProvider
                                .setErrorMessage('Please fix the errors above');
                          }
                        }),

                        SizedBox(height: sizes.height * 0.1 - 50),

                        // FormDivider(dividerText: 'Or',),

                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //
                        //     ButtonWidget.googleAuthButton(() {
                        //
                        //     },),
                        //
                        //     ButtonWidget.facebookAuthButton(() {
                        //
                        //     },)
                        //    ],
                        // )

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppString.haveAlreadyAccount,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                                onTap: () {
                                  AppHelperFunctions
                                      .navigateToScreenBeforeEndPage(
                                          context, const SignInPage());
                                },
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(color: AppColors.error),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CustomClipperDesign extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    var firstStart = Offset(size.width / 5, size.height);
    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);

    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dy, firstEnd.dx);

    var secondStart =
        Offset(size.width - (size.width / 3.24), size.height - 105);
    var secondEnd = Offset(size.width, size.height - 10);

    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return oldClipper != this;
  }
}

class CustomClipperBlue100 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    var firstStart = Offset(size.width / 5, size.height);
    var firstEnd = Offset(size.width / 2.15, size.height - 50.0);

    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dy, firstEnd.dx);

    var secondStart =
        Offset(size.width - (size.width / 3.1), size.height - 105);
    var secondEnd = Offset(size.width, size.height - 10);

    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) {
    return old != this;
  }
}
