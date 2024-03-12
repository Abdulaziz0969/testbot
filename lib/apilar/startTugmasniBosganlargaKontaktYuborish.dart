import 'dart:convert';
import 'package:http/http.dart' as http;

class KontaktYuborish {
  final String botToken;
  final String chatId;
  final String xabarText;
  final dynamic replyMarkup;

  KontaktYuborish(this.botToken, this.chatId, this.xabarText, this.replyMarkup);

  Future<bool> kontaktYuborish() async {
    try {
      print(chatId);
      final apiUrl = 'https://api.telegram.org/bot$botToken/sendMessage';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'chat_id': chatId,
          'text': xabarText,
          'reply_markup': replyMarkup,
        }),
      );

      return false;

    } catch (e) {
      throw 'Xatolik yuz berdi: $e';
    }
  }
}
