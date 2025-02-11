import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talk_nest/utils/constants/app_string.dart';
import 'package:talk_nest/utils/globle_widget/text_from_widget.dart';
import '../../view_model/app_validation/validation.dart';
import '../../view_model/provider/auth_provider.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviderIn>(
      builder: (BuildContext context, authProvider, Widget? child) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: authProvider.userNameController,
                    decoration: InputDecoration(
                      hintText: AppString.firstNameHint,
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                    validator: (value) {
                      return Validation.validateName(value);
                    }, // Correct validator
                    keyboardType: TextInputType.name,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: authProvider.lastNameController,
                    decoration: InputDecoration(
                      hintText: AppString.lastNameHint,
                      prefixIcon:
                          const Icon(Icons.nest_cam_wired_stand_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                    validator: (value) {
                      return Validation.validateLastName(value);
                    },
                    keyboardType: TextInputType.text,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),

            TextFromPage.buildTextField(
              controller: authProvider.phoneController,
              hintText: AppString.phoneNumberHint,
              validator: (value) {
                return Validation.validatePhoneNumber(value);
              },
              context: context,
              icons: const Icon(Icons.phone),
              inputType: TextInputType.number,
            ),
            const SizedBox(height: 10), // Add spacing between fields

            TextFromPage.buildTextField(
              controller: authProvider.emailController,
              hintText: AppString.emailHint,
              validator: (value) {
                return Validation.validateEmail(value);
              },
              context: context,
              icons: const Icon(Icons.email),
              inputType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 10), // Add spacing between fields

            TextFromPage.buildTextField(
              controller: authProvider.passwordController,
              hintText: AppString.passwordHint,
              validator: (value) {
                return Validation.validatePassword(value);
              },
              context: context,
              icons: const Icon(Icons.password),
              inputType: TextInputType.visiblePassword,
            ),

            const SizedBox(height: 10), // Add spacing between fields

            TextFromPage.buildTextField(
              controller: authProvider.addressController,
              hintText: AppString.addressHint,
              validator: (value) {
                return Validation.validateAddress(value);
              },
              context: context,
              icons: const Icon(Icons.add_reaction_outlined),
              inputType: TextInputType.streetAddress,
            ),
          ],
        );
      },
    );
  }
}
