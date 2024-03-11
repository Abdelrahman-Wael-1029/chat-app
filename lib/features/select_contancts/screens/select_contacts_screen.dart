import 'package:chat_app/common/widgets/new_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/loading.dart';
import '../controller/select_contacts_controller.dart';

class SelectContactsScreen extends ConsumerWidget {
  const SelectContactsScreen({super.key});

  static const route = '/select-contacts';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(selectContactsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spark'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: RefreshIndicator(
          onRefresh: () async {
            ref.refresh(selectContactsControllerProvider);
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
                  data: (data){
                    print(data);
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        var image = data[index].photo;

                        return NewContact(
                          title: data[index].displayName ?? "",
                          icon: image ==null? Icons.person:null,
                          backgroundImage: image != null ? MemoryImage(image) : null,
                        );
                      },
                    );

                  },
                  error: (error, stack) => Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  loading: () => Loading(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
