import 'dart:io';
import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:chat_app/features/stories/repository/stories_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storiesControllerProvider = Provider((ref) {
  return StoriesController(storiesRepository: ref.watch(storiesRepositoryProvider));
});

class StoriesController{
  final StoriesRepository storiesRepository ;

  StoriesController({required this.storiesRepository});

  Future<void> addStory({
    required String userName,
    required String phone,
    required String userImage,
    required context,
    required File image,
    required WidgetRef ref,
  }) async {
    ref.watch(authGetCurrentUserProvider).whenData((value) {
      if (value != null) {
        storiesRepository.addStory(
          userName: value.name,
          phone: value.phone,
          userImage: value.image,
          context: context,
          image: image,
          ref: ref,
        );
      }
    });
  }

  Stream getStories(){
    return storiesRepository.getStories();
  }
}