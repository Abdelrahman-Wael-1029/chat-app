import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/select_contacts_repository.dart';

final  selectContactsControllerProvider = FutureProvider<List<Contact>>((ref) async {
  return await ref.read(selectContactsRepositoryProvider).getContacts();
});
