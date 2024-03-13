import 'package:chat_app/features/chat/repository/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/message.dart';

var chatControllerProvider = Provider((ref) {
  return ChatController(chatRepository: ref.watch(chatRepositoryProvider));
});

class ChatController {
  ChatRepository chatRepository;

  ChatController({required this.chatRepository});


  Stream<List<MessageModel>> getMessages({
    required String receiverId,
  }) {
    var messages = chatRepository.getMessages(receiverId: receiverId);
    return messages;
  }

  void setMessages({
    required context,
    required MessageModel message,
  }) {
    chatRepository.setMessages(
      context: context,
      message: message,
    );
  }
}
