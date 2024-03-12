import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/select_contacts_repository.dart';

final  getContactsControllerProvider = FutureProvider<List<Contact>>((ref) async {
  return await ref.read(selectContactsRepositoryProvider).getContacts();
});

final selectContactsControllerProvider = Provider((ref) => SelectContactsController(
  selectContactsRepository: ref.read(selectContactsRepositoryProvider),
));

class SelectContactsController {
  SelectContactsRepository selectContactsRepository;

  SelectContactsController({required this.selectContactsRepository});

  Future<dynamic> selectContact(context, String uid) async {
    return await selectContactsRepository.selectContact(context,uid);
  }
}