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
      id: json['id'],
      name: json['name'],
      phone: json[' phone'],
      image: json['image'],
      groupsId: json['groupsId'],
      isOnline: json['isOnline'],
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
