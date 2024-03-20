import '../common/widgets/enum_message.dart';

class MessageModel {
  String message;
  final String senderId;
  final String receiverId;
  final String time;
  final bool isRead;
  final MessageType messageType;

  MessageModel({
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.time,
    required this.isRead,
    this.messageType = MessageType.text,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    print(json['messageType']);
    return MessageModel(
      message: json['message'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      time: json['time'],
      isRead: json['isRead'],
      messageType: (json['messageType'])  != null
          ? MessageType.values[json['messageType']]
          : MessageType.text,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'senderId': senderId,
      'receiverId': receiverId,
      'time': time,
      'isRead': isRead,
      'messageType': messageType.index,
    };
  }

  @override
  String toString() {
    return 'MessageModel(message: $message, senderId: $senderId, receiverId: $receiverId, time: $time, isRead: $isRead, messageType: $messageType)';
  }
}
