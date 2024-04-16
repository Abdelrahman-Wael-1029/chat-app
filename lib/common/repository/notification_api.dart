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
    print('Sending notification in my class notification api');
    try {
      final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
      final response = await http.post(
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
      if (response.statusCode == 200) {
        print('Notification sent');
        print(token);
      } else {
        print('Failed to send notification');
      }
    } catch (e) {
      print(e);
    }
  }
}
