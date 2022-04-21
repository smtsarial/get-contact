import 'package:contacts_service/contacts_service.dart';

class ContactHelper {
  Future<Iterable<Contact>> getAllContacts() async {
    // Get all contacts on device

    Iterable<Contact> contacts = await ContactsService.getContacts();

    return contacts;
  }
}
