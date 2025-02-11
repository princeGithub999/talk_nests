import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talk_nest/utils/constants/app_string.dart';
import 'package:talk_nest/utils/constants/images.dart';
import 'package:talk_nest/utils/helpers/helper_functions.dart';
import 'package:talk_nest/view/auth/sign_up_page.dart';
import '../../utils/constants/colors.dart';
import '../../utils/globle_widget/button_widget.dart';
import '../../utils/globle_widget/text_from_widget.dart';
import '../../view_model/app_validation/validation.dart';
import '../../view_model/provider/auth_provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final sizes = MediaQuery.of(context).size;
    final isDark = AppHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<AuthProviderIn>(
          builder: (BuildContext context, authProvider, Widget? child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        left: sizes.width * 0.1 - 20,
                        child: Text(
                          AppString.forgotPassword,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ))
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: sizes.width * 0.1 - 20, top: 10, right: 10),
                  child: Form(
                    key: fromKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppString.forgotPasswordContent,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            AppImage.forgetPasswardImage,
                            width: sizes.width * 0.7,
                          ),
                        ),
                        SizedBox(
                          height: sizes.height * 0.1 - 60,
                        ),
                        TextFromPage.buildTextField(
                            controller: authProvider.emailController,
                            hintText: AppString.emailHint,
                            validator: (value) {
                              return Validation.validateEmail(value);
                            },
                            context: context,
                            icons: Icon(Icons.email_outlined),
                            inputType: TextInputType.emailAddress),
                        SizedBox(
                          height: sizes.height * 0.1 - 60,
                        ),
                        ButtonWidget.forgotButton(
                          () {
                            if (fromKey.currentState!.validate()) {
                              authProvider.forgotPassword(
                                  authProvider.emailController.text.trim());
                            } else {
                              authProvider.setErrorMessage(
                                  'Please fix the errors above');
                            }
                          },
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
