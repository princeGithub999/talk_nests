import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider/auth_provider.dart';

class ContectService {
  final dataBaseContacts =
      Provider.of<AuthProviderIn>(Get.context!, listen: false);

  Future<List<Contact>?> fetchContacts() async {
    if (await FlutterContacts.requestPermission(readonly: true)) {
      return await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> prepareContactList() async {
    final contacts = await fetchContacts();
    final dbContact = dataBaseContacts.profileData;

    List<Map<String, dynamic>> matchedContacts = [];
    List<Map<String, dynamic>> nonMatchedContacts = [];

    if (contacts == null || contacts.isEmpty) return [];

    for (var contact in contacts) {
      final contactNumber = contact.phones.isNotEmpty
          ? normalizePhoneNumber(contact.phones.first.number)
          : '';
      final dbNumbers = dbContact
          .map((data) => normalizePhoneNumber(data.userPhone.toString()))
          .toList();

      final isMatched = dbNumbers.contains(contactNumber);

      Map<String, dynamic> contactData = {
        'name': contact.displayName ?? "Unknown",
        'number': contactNumber,
        // 'image': contact.photo,
        'isMatched': isMatched,
      };

      if (isMatched) {
        final matchedDbContact = dbContact.firstWhere((dbData) =>
            normalizePhoneNumber(dbData.userPhone.toString()) == contactNumber);

        contactData['image'] = matchedDbContact.userImage;
        contactData['userId'] = matchedDbContact.currentUserId;
        contactData['email'] = matchedDbContact.userEmail;
        contactData['notificationToken'] = matchedDbContact.notificationToken;
        matchedContacts.add(contactData);
      } else {
        nonMatchedContacts.add(contactData);
      }
    }

    return [...matchedContacts, ...nonMatchedContacts];
  }

  String normalizePhoneNumber(String phoneNumber,
      {String defaultCountryCode = '91'}) {
    String cleanedNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (cleanedNumber.length == 10) {
      cleanedNumber = defaultCountryCode + cleanedNumber;
    }
    return cleanedNumber;
  }

  Future<void> sendMessage(Uri smsUri) async {
    await launchUrl(smsUri);
  }
}
