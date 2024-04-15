import 'package:flutter/widgets.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';

// ignore: must_be_immutable
class DisplayStory extends StatelessWidget {
  static const String route = '/displayStory';

  List<StoryItem?> images;
  var controller;

  DisplayStory({super.key, required this.images, required this.controller});

  @override
  Widget build(BuildContext context) {
    return StoryView(
      controller: controller,
      onVerticalSwipeComplete: (direction) {
        if (direction == Direction.down) {
          Navigator.pop(context);
        }
      },
      storyItems: images,
      repeat: false,
      onComplete: () {
        Navigator.pop(context);
      },
    );
  }
}
