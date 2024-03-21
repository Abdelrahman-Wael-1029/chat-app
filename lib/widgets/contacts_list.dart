import 'package:chat_app/common/widgets/error.dart';
import 'package:chat_app/common/widgets/loading.dart';
import 'package:chat_app/features/chat/controller/chat_controller.dart';
import 'package:chat_app/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/chat/screens/chat_screen.dart';
import '../features/select_contancts/controller/select_contacts_controller.dart';
import '../screens/show_image.dart';

class ContactsList extends ConsumerWidget {
  List<ContactModel> data;

  Function(int)? onTapIndex;

  bool isScrollable;

  ContactsList({
    super.key,
    required this.data,
    this.onTapIndex,
    this.isScrollable = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      shrinkWrap: true,
      physics: isScrollable
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: InkWell(
            onTap: (){
              if(data[index].image == null) {
                return;
              }
              Navigator.pushNamed(context, ShowImage.route, arguments: data[index].image);
            },
            child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(data[index].image ?? ""),
                onBackgroundImageError: (exception, stackTrace) {}),
          ),
          title: Text(
            data[index].name,
            style: Theme.of(context).textTheme.titleLarge,
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
          onTap: () {
            if(onTapIndex != null) {
              onTapIndex!(index);
            }
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
  }
}
