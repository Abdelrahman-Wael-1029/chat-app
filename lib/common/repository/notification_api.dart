import 'dart:convert';
import '../../env.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final notificationApiProvider = Provider((ref) => NotificationApi());

class NotificationApi {
  Future<void> sendFcmNotification({
    required String token,
    required String title,
    required String body,
    required data,
  }) async {
    try {
      final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
      await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode({
          'notification': <String, dynamic>{
            'title': title,
            'body': body,
          },
          'data': data,
          'to': token,
        }),
      );
    } catch (e) {
      print(e);
    }
  }
}
