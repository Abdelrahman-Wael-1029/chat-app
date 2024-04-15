class VideoCallModel {
  final String senderId;
  final String reciverId;
  final String time;

  VideoCallModel(
      {required this.senderId, required this.reciverId, required this.time});

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'reciverId': reciverId,
      'time': time,
    };
  }

  factory VideoCallModel.fromMap(Map<String, dynamic> map) {
    return VideoCallModel(
      senderId: map['senderId'],
      reciverId: map['reciverId'],
      time: map['time'],
    );
  }

  @override
  String toString() =>
      'VideoCallModel(senderId: $senderId, reciverId: $reciverId, time: $time)';
}
