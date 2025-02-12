import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talk_nest/model/auth_model/auth_model.dart';
import 'package:talk_nest/utils/helpers/helper_functions.dart';
import 'package:talk_nest/view/onBoarding/on_boarding_screen.dart';
import 'package:talk_nest/view/page/buttom_navigation_page.dart';

import '../../model/contacts_model/contacts_model.dart';
import '../service/auth_service.dart';

class AuthProviderIn extends ChangeNotifier {
  AuthService authService = AuthService();
  List<AuthModel> profileData = [];
  AuthModel currentUser = AuthModel();
  bool isLoding = false;
  bool isEditing = false;
  File? imageFile;
  String? errorMessage;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

  TextEditingController userNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  void setErrorMessage(String? message) {
    errorMessage = message;
    notifyListeners();
  }

  Future<void> signUpUser(BuildContext context, AuthModel data) async {
    try {
      isLoding = true;
      notifyListeners();

      String? token = await getDeviceToken();

      if (imageFile != null) {
        UserCredential userCredential =
            await authService.signUp(data.userEmail!, data.userPassword!);

        String imageUrl = await authService.uploadProfileImage(
            imageFile!, userCredential.user!.uid);

        var setData = AuthModel(
            currentUserId: userCredential.user!.uid,
            userName: data.userName,
            userEmail: data.userEmail,
            userAddress: data.userAddress,
            userPassword: data.userPassword,
            userPhone: data.userPhone,
            userImage: imageUrl.toString(),
            notificationToken: token ?? '');

        var chatData = ContactsModel(
          userId: userCredential.user!.uid,
          userName: data.userName,
          contactNumber: data.userPhone,
          userImage: imageUrl.toString(),
          userEmail: data.userEmail,
          notificationToken: token ?? '',
        );

        // await authService.addChatNumber(chatData);
        await authService.saveUserData(userCredential.user!.uid, setData);

        AppHelperFunctions.showSnackBar('SignUp Success');
        AppHelperFunctions.navigateToScreenBeforeEndPage(
          context,
          ButtomNavigationPage(),
        );
      } else {
        AppHelperFunctions.showSnackBar('Please select image');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '$e');
      AppHelperFunctions.showSnackBar('$e');
    } finally {
      isLoding = false;
      notifyListeners();
    }
  }

  Future<void> signInUser(
      BuildContext context, String userEmail, String userPassword) async {
    try {
      isLoding = true;
      notifyListeners();
      await authService.signIn(userEmail, userPassword);

      AppHelperFunctions.showSnackBar('LoginSuccess');
      AppHelperFunctions.navigateToScreenBeforeEndPage(
          context, ButtomNavigationPage());
      clearController();
    } catch (e) {
      AppHelperFunctions.showSnackBar('Login Error $e');
    } finally {
      isLoding = false;
      notifyListeners();
    }
  }

  Future<void> getProfileData() async {
    try {
      isLoding = true;
      notifyListeners();

      var userData = await authService.fetchProfileData();

      if (userData.isNotEmpty) {
        profileData.clear();
        profileData.addAll(userData);
      } else {
        Fluttertoast.showToast(msg: 'null');
      }
    } catch (e) {
      AppHelperFunctions.showSnackBar('Profile Get Error: $e');
    } finally {
      isLoding = false;
      notifyListeners();
    }
  }

  Future<void> getCurrentUser() async {
    var data = await authService.getCurrentUser();
    if (data != null) {
      currentUser = data;
    } else {
      Fluttertoast.showToast(msg: 'User not found');
    }
  }

  Future<void> checkUserLoginStutas() async {
    var authCheckStutas = authService.checkUserLoginStutas();
    if (await authCheckStutas) {
      AppHelperFunctions.navigateToScreenBeforeEndPage(
          Get.context!, const ButtomNavigationPage());
    } else {
      AppHelperFunctions.navigateToScreenBeforeEndPage(
          Get.context!, const OnBoardingScreen());
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      isLoding = true;
      notifyListeners();
      await authService.resetPassword(email);
      AppHelperFunctions.showSnackBar('Send link on email');
    } catch (e) {
      AppHelperFunctions.showSnackBar('$e');
    } finally {
      isLoding = false;
      notifyListeners();
    }
  }

  Future<void> pickImageFromGallery() async {
    var getImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (getImage != null) {
      imageFile = File(getImage.path);
      notifyListeners();
    }
  }

  void clearController() {
    userNameController.clear();
    lastNameController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
  }

  Future<String?> getDeviceToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        return token;
      } else {
        Fluttertoast.showToast(msg: 'FCM Token is null');
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
      return null;
    }
  }

  Future<void> isEditingF() async {
    if (isEditing) {
      isEditing = false;
    } else {
      isEditing = true;
    }
    notifyListeners();
  }

  Future<void> updateProfileData(AuthModel userData) async {
    try {
      isLoding = true;
      notifyListeners();

      String updateImage = await authService.uploadProfileImage(
          imageFile!, FirebaseAuth.instance.currentUser!.uid);

      if (updateImage.isNotEmpty) {
        var updateData = {
          'userName': userData.userName,
          'userEmail': userData.userEmail,
          'userPhone': userData.userPhone,
          'userAddress': userData.userAddress,
          'userImage': updateImage
        };

        authService.updateProfileData(updateData);
      }

      await getCurrentUser();
    } catch (error) {
      Fluttertoast.showToast(msg: 'update Error $error');
    } finally {
      isLoding = false;
      isEditing = false;
      notifyListeners();
    }
  }

  Future<Uri?> inviteWithDynamicLink() async {
    try {
      final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
        link: Uri.parse('https://talknext.page.link/invite'),
        uriPrefix: 'https://talknext.page.link',
        androidParameters: const AndroidParameters(
          packageName: 'com.example.talk_nest',
        ),
      );

      final ShortDynamicLink shortLink =
          await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
      return shortLink.shortUrl;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Dynamic Link Error: $e');
      print('Error Creating Dynamic Link: $e');
      return null;
    }
  }
}
