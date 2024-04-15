class VideoCallModel {
  final String senderId;
  final String senderName;
  final String reciverId;
  final String time;

  VideoCallModel({
    required this.senderId,
    required this.senderName,
    required this.reciverId,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'reciverId': reciverId,
      'time': time,
    };
  }

  factory VideoCallModel.fromMap(Map<String, dynamic> map) {
    return VideoCallModel(
      senderId: map['senderId'],
      senderName: map['senderName'],
      reciverId: map['reciverId'],
      time: map['time'],
    );
  }

  @override
  String toString() =>
      'VideoCallModel(senderId: $senderId, senderName: $senderName, reciverId: $reciverId, time: $time)';
}
