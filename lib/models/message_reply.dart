import '../common/widgets/enum_message.dart';

class MessageReplyModel {
  String name;
  String message;
  bool isMe;
  String messageId;
  MessageType messageType;
  

  MessageReplyModel({
    required this.name,
    required this.message,
    required this.isMe,
    required this.messageId,
    required this.messageType,
  });

  factory MessageReplyModel.fromJson(Map<String, dynamic> json) {
    return MessageReplyModel(
      name: json['name'],
      message: json['message'],
      isMe: json['isMe'],
      messageId: json['messageId'],
      messageType: MessageType.values[json['messageType']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'message': message,
      'isMe': isMe,
      'messageId': messageId,
      'messageType': messageType.index,
    };
  }

  @override
  String toString() {
    return 'MessageReplyModel(name: $name, message: $message, isMe: $isMe, messageId: $messageId, messageType: $messageType)';
  }

}
