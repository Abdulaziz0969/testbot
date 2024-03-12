import 'package:dio/dio.dart';

class BotdagiXabararniAniqlash {
  final Dio dio = Dio();
  final String botToken;
  final String botHabarRaqami;
  BotdagiXabararniAniqlash(this.botToken, this.botHabarRaqami);

  Future<List<dynamic>> botdagiXabararniAniqlash() async {
   try {
      final response = await dio.get(
        "https://api.telegram.org/bot$botToken/getUpdates?offset=$botHabarRaqami",
      );

      if (response.statusCode == 200 && response.data['ok'] == true) {
        List<dynamic> result = response.data['result'];
        return result;
      } else {
        throw Exception("So'rovnoma jo'natishda xatolik: ${response.data['description']}");
      }
    } catch (e) {
      throw Exception("Xato: $e");
    }
  }
}


