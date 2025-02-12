import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talk_nest/model/auth_model/auth_model.dart';
import 'package:talk_nest/utils/constants/colors.dart';
import 'package:talk_nest/utils/globle_widget/button_widget.dart';
import 'package:talk_nest/utils/helpers/helper_functions.dart';
import 'package:talk_nest/view_model/provider/auth_provider.dart';

import '../../auth/profile_image.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    addressController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sizes = MediaQuery.of(context).size;
    var isDark = AppHelperFunctions.isDarkMode(context);

    return Consumer<AuthProviderIn>(
      builder: (BuildContext context, authProvider, Widget? child) {
        var userName = authProvider.currentUser.userName ?? 'prince';
        var userPhone = authProvider.currentUser.userPhone.toString();
        var userEmail = authProvider.currentUser.userEmail ?? 'eagau';
        var userAddress = authProvider.currentUser.userAddress ?? 'somewhere';

        nameController.text = userName;
        phoneController.text = userPhone;
        emailController.text = userEmail;
        addressController.text = userAddress;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: sizes.height * 0.1 - 40),
                  Stack(
                    children: [
                      Center(
                        child: ProfileImage.profileImageUpdate(),
                      ),
                      authProvider.isEditing
                          ? Positioned(
                              left: sizes.width * 0.6 - 4,
                        child: CircleAvatar(
                          backgroundColor: isDark
                              ? AppColors.blue900.withOpacity(0.9)
                              : AppColors.lightBlue.withOpacity(0.9),
                                maxRadius: 12,
                                child: IconButton(
                                  onPressed: () {
                                    if (authProvider.isEditing) {
                                      authProvider.pickImageFromGallery();
                                    }
                                  },
                                  icon: const Icon(Icons.edit,
                                      color: Colors.white, size: 12),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  profileRow('Name :', userName, nameController),
                  const SizedBox(height: 10),
                  profileRow('Phone :', userPhone, phoneController),
                  const SizedBox(height: 10),
                  profileRow('Email :', userEmail, emailController),
                  const SizedBox(height: 10),
                  profileRow('Address :', userAddress, addressController),
                  const SizedBox(height: 20),
                  ButtonWidget.anyWereButtom(() {
                    if (authProvider.isEditing) {
                      var data = AuthModel(
                        userName: nameController.text,
                        userEmail: emailController.text,
                        userPhone: int.tryParse(phoneController.text) ?? 0,
                        userAddress: addressController.text,
                      );
                      authProvider.updateProfileData(data);
                    }
                    authProvider.isEditingF();
                  }, authProvider.isEditing ? 'Save' : 'Edit profile'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget profileRow(
      String label, dynamic data, TextEditingController controller) {
    return Consumer<AuthProviderIn>(
      builder: (BuildContext context, authProvider, Widget? child) {
        return Padding(
          padding: const EdgeInsets.only(left: 40, right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text(label, style: const TextStyle(fontSize: 18)),
              ),
              Expanded(
                flex: 4,
                child: authProvider.isEditing
                    ? TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      )
                    : Text(data, style: const TextStyle(fontSize: 18)),
              ),
            ],
          ),
        );
      },
    );
  }
}
