class ContactModel {
  late String id;
  late String name;
  late String phone;
  late String? image;

  ContactModel({
    required this.id,
    required this.name,
    required this.phone,
    this.image,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'ContactModel{id: $id, name: $name, phone: $phone, image: $image}';
  }
}
