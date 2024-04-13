class StoryModel {
  String uid;
  String storyId;
  String userName;
  String phone;
  List<String> storyImages;
  String userImage;
  DateTime createdAt;
  List<String> whoCanSee;

  StoryModel({
    required this.uid,
    required this.storyId,
    required this.userName,
    required this.phone,
    required this.storyImages,
    required this.userImage,
    required this.createdAt,
    required this.whoCanSee,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'storyId': storyId,
      'userName': userName,
      'phone': phone,
      'storyImages': storyImages,
      'userImage': userImage,
      'createdAt': createdAt,
      'whoCanSee': whoCanSee,
    };
  }

  factory StoryModel.fromJson(Map<String, dynamic> map) {
    return StoryModel(
      uid: map['uid'],
      storyId: map['storyId'],
      userName: map['userName'],
      phone: map['phone'],
      storyImages: List<String>.from(map['storyImages']),
      userImage: map['userImage'],
      createdAt: map['createdAt'].toDate(),
      whoCanSee: List<String>.from(map['whoCanSee']),
    );
  }
} 
