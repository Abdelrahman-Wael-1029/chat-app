import 'message_reply.dart';

import '../common/widgets/enum_message.dart';

class MessageModel {
  String message;
  final String senderId;
  final String receiverId;
  final String time;
  final bool isRead;
  final MessageType messageType;
  MessageReplyModel? reply;

  MessageModel({
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.time,
    required this.isRead,
    this.messageType = MessageType.text,
    this.reply,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json['message'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      time: json['time'],
      isRead: json['isRead'],
      messageType: (json['messageType'])  != null
          ? MessageType.values[json['messageType']]
          : MessageType.text,
      reply: json['reply'] != null ? MessageReplyModel.fromJson(json['reply']) : null,
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
      'reply': reply?.toJson(),
    };
  }

  @override
  String toString() {
    return 'MessageModel(message: $message, senderId: $senderId, receiverId: $receiverId, time: $time, isRead: $isRead, messageType: $messageType , reply: $reply)';
  }
}
