import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:talk_nest/utils/helpers/helper_functions.dart';
import 'package:url_launcher/url_launcher.dart';
import '../service/contect_service.dart';

class ContectProvider extends ChangeNotifier {
  final ContectService contectService = ContectService();
  bool isLoding = false;
  List<Map<String, dynamic>> contactList = [];

  Future<void> setContact() async {
    isLoding = true;
    notifyListeners();
    try {
      final contacts = await contectService.prepareContactList();
      contactList = contacts;
    } catch (e) {
      AppHelperFunctions.showSnackBar("Error fetching contacts: $e");
    } finally {
      isLoding = false;
      notifyListeners();
    }
  }

  Future<void> sendSms(String number, String message) async {
    final smsUri = Uri.parse('sms:$number?body=$message');
    if (await canLaunchUrl(smsUri)) {
      contectService.sendMessage(smsUri);
    } else {
      Fluttertoast.showToast(msg: "Could not open SMS app");
    }
  }
}
