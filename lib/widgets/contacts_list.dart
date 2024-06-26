import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/screens/show_image.dart';
import '../models/contact.dart';

// ignore: must_be_immutable
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
