import 'dart:convert';
import 'package:dio/dio.dart';

class OhirgiUpdateIdniBasegaSaqlash {
  final Dio dio = Dio();
  final String botdagiOhirgiUpdateId;
  OhirgiUpdateIdniBasegaSaqlash(this.botdagiOhirgiUpdateId);

  Future<Map<String, dynamic>> ohirgiUpdateIdniBasegaSaqlash() async {

    try {
      var basic = 'Basic ${base64Encode(utf8.encode('mobiles:123'))}';
      Duration time = Duration(minutes: 1);
      dio.options.baseUrl =
      "http://185.17.66.163:60200/Tatwir/hs/BotMobilSms/";
      dio.options.connectTimeout = time;
      dio.options.receiveTimeout = time;
      dio.options.sendTimeout = time;
      dio.options.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': basic,
      });
      final response = await dio.post("updateIdSaqlash", data: {
        'updateId': botdagiOhirgiUpdateId
      });

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw "Server tomonidan xato kodi: ${response.statusCode}";
      }
    } catch (e) {
      throw 'Server bilan bog`lanishda xatolik yuz berdi: $e';
    }
  }
}
