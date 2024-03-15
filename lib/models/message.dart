class MessageModel {
  final String message;
  final String senderId;
  final String receiverId;
  final String time;
  final bool isRead;

  MessageModel({
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.time,
    required this.isRead,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json['message'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      time: json['time'],
      isRead: json['isRead'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'senderId': senderId,
      'receiverId': receiverId,
      'time': time,
      'isRead': isRead,
    };
  }

  @override
  String toString() {
    return 'MessageModel(message: $message, senderId: $senderId, receiverId: $receiverId, time: $time, isRead: $isRead)';
  }
}
