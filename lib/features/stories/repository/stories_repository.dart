import 'dart:io';
import 'package:chat_app/common/repository/common_firebase_storage.dart';
import 'package:chat_app/models/story_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final storiesRepositoryProvider = Provider<StoriesRepository>((ref) {
  return StoriesRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

class StoriesRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  StoriesRepository({required this.auth, required this.firestore});

  Future<void> addStory({
    required String userName,
    required String phone,
    required String userImage,
    required context,
    required File image,
    required WidgetRef ref,
  }) async {
    try {
      var storyId = const Uuid().v4();
      var uid = auth.currentUser!.uid;
      var extention = image.path.split('.').last;
      var imageurl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .uploadFile('stories/$uid/$storyId.$extention', image);

      var storyImages = <String>[];

      // get old stories
      var oldStory = await firestore.collection('stories').doc(uid).get();
      if (oldStory.exists) {
        storyImages = List<String>.from(oldStory['storyImages']);
      }
      storyImages.add(imageurl);

      //  get old whoCanSee
      var whoCanSee = <String>[];
      if (oldStory.exists) {
        whoCanSee = List<String>.from(oldStory['whoCanSee']);
      }
      whoCanSee.add('all');

      var story = StoryModel(
        uid: uid,
        userName: userName,
        phone: phone,
        storyImages: storyImages,
        userImage: userImage,
        createdAt: DateTime.now(),
        storyId: storyId,
        whoCanSee: whoCanSee,
      );
      await firestore.collection('stories').doc(uid).set(story.toMap());
    } catch (e) {
      print(e);
    }
  }

  Stream getStories() {
    return firestore.collection('stories').snapshots().asyncMap((e) async {
      var contacts = [];

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withThumbnail: false,
        );
      }
      var contactsNumbers =
          contacts.map((e) => e.phones[0].number.replaceAll(' ', '')).toList();
      
      contactsNumbers.add(auth.currentUser!.phoneNumber!.replaceAll(' ', ''));

      var stories = [];
      for (var item in e.docs) {
        if (contactsNumbers.contains(item['phone'])) {
          stories.add(item);
        }
      }
      return stories;
    });
  }
}
