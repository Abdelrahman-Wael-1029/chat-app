import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/loading.dart';
import '../../../common/widgets/new_contact.dart';
import '../../../widgets/contacts_list.dart';
import '../controller/select_contacts_controller.dart';

class SelectContactsScreen extends ConsumerWidget {
  const SelectContactsScreen({super.key});

  static const route = '/select-contacts';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(getContactsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text('Spark'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: RefreshIndicator(
          onRefresh: () async {
            ref.refresh(getContactsControllerProvider);
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                NewContact(
                  title: "New Group",
                  icon: Icons.groups,
                ),
                const SizedBox(
                  height: 10,
                ),
                NewContact(
                  title: "New Contact",
                  icon: Icons.person_add,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Contacts",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: 10,
                ),
                contacts.when(
                  data: (data) {
                    return ContactsList(
                      data: data,
                      isScrollable: false,
                      onTapIndex: (index) {
                        ref
                            .read(selectContactsControllerProvider)
                            .selectContact(
                              context,
                              data[index].id,
                            );
                      },
                    );
                  },
                  error: (error, stack) => Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  loading: () => const Loading(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
