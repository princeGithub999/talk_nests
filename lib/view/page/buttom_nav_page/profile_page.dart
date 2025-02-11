import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talk_nest/utils/constants/colors.dart';
import 'package:talk_nest/utils/globle_widget/button_widget.dart';
import 'package:talk_nest/utils/helpers/helper_functions.dart';
import 'package:talk_nest/view_model/provider/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var sizes = MediaQuery.of(context).size;
    var isDark = AppHelperFunctions.isDarkMode(context);

    return Consumer<AuthProviderIn>(
      builder: (BuildContext context, authProvider, Widget? child) {
        var userName = authProvider.currentUser.userName ?? 'prince';
        var userImage = authProvider.currentUser.userImage ?? 'ha';
        var userPhone = authProvider.currentUser.userPhone;
        var userAddress = authProvider.currentUser.userAddress ?? 'somw';
        var userEmail = authProvider.currentUser.userEmail ?? 'eagau';

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
                    // alignment: Alignment.topCenter,
                    children: [
                      Center(
                        child: CircleAvatar(
                          backgroundColor:
                              isDark ? AppColors.blue900 : AppColors.lightBlue,
                          radius: 70,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: userImage,
                              fit: BoxFit.cover,
                              width: sizes.width * 0.3 + 17,
                              height: sizes.height * 0.2 - 35,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: sizes.width * 0.6 - 4,
                        child: CircleAvatar(
                          backgroundColor: isDark
                              ? AppColors.blue900.withOpacity(0.9)
                              : AppColors.lightBlue.withOpacity(0.9),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.edit,
                                color: Colors.white, size: 25),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Text(
                  //   userName,
                  //   style: const TextStyle(fontSize: 27),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  profileRow('Name :', userName),
                  const SizedBox(
                    height: 10,
                  ),
                  profileRow('Phone :', 'userPhone'),
                  const SizedBox(
                    height: 10,
                  ),
                  profileRow('Email :', userEmail),
                  const SizedBox(
                    height: 10,
                  ),
                  profileRow('Address:', userAddress),
                  const SizedBox(
                    height: 10,
                  ),

                  SizedBox(height: sizes.height * 0.2),

                  ButtonWidget.anyWereButtom(() {
                    authProvider.isEditing
                        ? authProvider.isEditingF()
                        : authProvider.isEditingF();
                  }, authProvider.isEditing ? 'Save' : 'Edit profile'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget profileRow(String label, dynamic data) {
    return Consumer<AuthProviderIn>(
      builder: (BuildContext context, authProvider, Widget? child) {
        return Padding(
          padding: const EdgeInsets.only(left: 40, right: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 18),
                  )),
              Expanded(
                  flex: 4,
                  child: authProvider.isEditing
                      ? TextField(
                          decoration: InputDecoration(border: InputBorder.none),
                        )
                      : Text(
                          data,
                          style: const TextStyle(fontSize: 18),
                        ))
            ],
          ),
        );
      },
    );
  }
}
