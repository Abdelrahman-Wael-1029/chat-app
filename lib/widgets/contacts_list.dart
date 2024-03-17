import 'package:chat_app/common/widgets/error.dart';
import 'package:chat_app/common/widgets/loading.dart';
import 'package:chat_app/features/chat/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/chat/screens/chat_screen.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var chatController = ref.watch(chatControllerProvider);
    return StreamBuilder(
        stream: chatController.getContacts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorScreen(error: snapshot.error.toString());
          }
          if (!snapshot.hasData) {
            return const Loading();
          }
          var data = snapshot.data!;
          return ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(data[index].image!),
                    onBackgroundImageError: (exception, stackTrace) {}),
                title: Text(data[index].name,
                    style: Theme.of(context).textTheme.titleLarge!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                 ),
                subtitle: Text(
                  data[index].lastMessage ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  data[index].time ?? "",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.grey,
                      ),
                ),
                onTap: (){
                  Navigator.pushNamed(context, ChatScreen.route, arguments: {
                    'name': data[index].name,
                    'imageUrl': data[index].image,
                    'isOnline': data[index].isOnline,
                    'uid': data[index].id,
                  });

                },
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 10,
              );
            },
            itemCount: data.length,
          );
        });
  }
}
