import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/common/widgets/loading.dart';
import 'package:chat_app/features/stories/controller/stories_controller.dart';
import 'package:chat_app/features/stories/screens/display_story.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class StoriesScreen extends ConsumerWidget {
  StoriesScreen({super.key});
  final storyController = StoryController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var storiesController = ref.watch(storiesControllerProvider);
    print("get stories");
    return StreamBuilder(
      stream: storiesController.getStories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        }
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data.docs.length,
          separatorBuilder: (context, index) {
            return const SizedBox(
              width: 10,
            );
          },
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  DisplayStory.route,
                  // controller and images are required
                  arguments: {
                    'controller': storyController,
                    'images': List<StoryItem?>.from(
                      (snapshot.data.docs[index]['storyImages'] as List)
                          .map((e) {
                        return StoryItem.pageImage(
                          url: e,
                          controller: storyController,
                        );
                      }).toList(),
                    ),
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: CachedNetworkImageProvider(
                          snapshot.data.docs[index]['userImage']),
                    ),
                    Text(
                      snapshot.data.docs[index]['userName'],
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
