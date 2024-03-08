import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonFirebaseStorageRepositoryProvider = Provider(
  (ref) => CommonFirebaseStorageRepository(
    storage: FirebaseStorage.instance,
  ),
);

class CommonFirebaseStorageRepository {
  FirebaseStorage storage;

  CommonFirebaseStorageRepository({required this.storage});

  Future<String> uploadFile(String ref, File file) async {
    TaskSnapshot snap = await storage.ref(ref).putFile(file);
    return await snap.ref.getDownloadURL();
  }
}
