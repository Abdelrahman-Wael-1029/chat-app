import '../widgets/enum_message.dart';

String typeMessage(message) {
  switch (message.messageType) {
    case MessageType.text:
      return message.message;
    case MessageType.image:
      return 'Image 📷';
    case MessageType.video:
      return 'Video 📸';
    case MessageType.audio:
      return 'Audio 🔉';
    case MessageType.file:
      return 'File 📁';
  }
  return "";
}
