class ContactModel {
  String id;
  String name;
  String phone;
  String? image;
  String? lastMessage;
  String? time;

  ContactModel(
      {required this.id,
      required this.name,
      required this.phone,
      this.image,
      this.lastMessage,
      this.time});

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        image: json['image'],
        lastMessage: json['lastMessage'],
        time: json['time']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'image': image,
      'lastMessage': lastMessage,
      'time': time
    };
  }

  @override
  String toString() {
    return 'ContactModel{id: $id, name: $name, phone: $phone, image: $image, lastMessage: $lastMessage, time: $time}';
  }
}
