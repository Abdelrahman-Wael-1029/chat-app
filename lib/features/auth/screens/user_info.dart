import 'dart:io';

import 'package:chat_app/common/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/auth_controller.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  static const route = "/user-info";

  const UserInfoScreen({super.key});

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  XFile? image;
  late final imageProvider = Provider<XFile?>((ref) => image);
  var nameController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(imageProvider);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 80,
                            child: image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.file(
                                      File(image!.path),
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.fill,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.error);
                                      },
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                      'https://p7.hiclipart.com/preview/782/114/405/5bbc3519d674c.jpg',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.fill,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.error);
                                      },
                                    ),
                                  ),
                          ),
                          IconButton(
                            onPressed: () async {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.camera_alt),
                                        title: const Text('Camera'),
                                        onTap: () async {
                                          final ImagePicker picker =
                                              ImagePicker();
                                          final XFile? _image =
                                              await picker.pickImage(
                                            source: ImageSource.camera,
                                          );
                                          if (_image != null) {
                                            setState(() {
                                              image = _image;
                                            });
                                          }
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.image),
                                        title: const Text('Gallery'),
                                        onTap: () async {
                                          final ImagePicker _picker =
                                              ImagePicker();
                                          final XFile? _image =
                                              await _picker.pickImage(
                                            source: ImageSource.gallery,
                                          );
                                          if (_image != null) {
                                            setState(() {
                                              image = _image;
                                            });
                                          }
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              shadows: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: "Full Name",
                        ),
                        controller: nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Name cannot be empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                  defaultEvaluationButton(
                    context,
                    text: "NEXT",
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        ref.read(authControllerProvider).saveUserData(
                              name: nameController.text,
                              image: image?.path,
                              context: context,
                            );
                      }
                    },
                    width: MediaQuery.of(context).size.width * 0.25,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
