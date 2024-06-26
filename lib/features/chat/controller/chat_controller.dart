import '../repository/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/contact.dart';
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

  Future<void> setMessages({
    required context,
    required MessageModel message,
    String? type,
  }) async {
    await chatRepository.setMessages(
      context: context,
      message: message,
      type: type,
    );
  }

  Stream<List<ContactModel>> getContacts() {
    var contacts = chatRepository.getContacts();
    return contacts;
  }

  Future<void> setSeenMessage({
        required context,
    required MessageModel message,
  }) async {
    await chatRepository.setSeenMessage(
      context: context,
      message: message,
    );
  }
}
