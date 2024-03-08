class UserModel {
  String name;
  String phone;
  String image;
  List<String> groupsId;
  bool isOnline;
  String id;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.image,
    required this.groupsId,
    required this.isOnline,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      image: json['image'],
      name: json['name'],
      groupsId: List<String>.from(json['groupsId']),
      phone: json['phone'],
      isOnline: json['isOnline'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'image': image,
      'groupsId': groupsId,
      'isOnline': isOnline,
    };
  }

  @override
  String toString() {
    return 'UserModel{name: $name, phone: $phone, image: $image, groupsId: $groupsId, isOnline: $isOnline}';
  }
}
