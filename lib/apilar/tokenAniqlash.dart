import 'dart:convert';
import 'package:dio/dio.dart';

class TokenAniqlash {
  final Dio dio = Dio();

  Future<Map<String, dynamic>?> getToken() async {
    try {
      var basic = 'Basic ${base64Encode(utf8.encode('mobiles:123'))}';
      Duration time = Duration(minutes: 1);
      dio.options.baseUrl = "http://185.17.66.163:60200/Tatwir/hs/BotMobilSms/";
      dio.options.connectTimeout = time;
      dio.options.receiveTimeout = time;
      dio.options.sendTimeout = time;
      dio.options.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': basic,
      });

      final response = await dio.get("getBotToken");
      if (response.statusCode == 200) {
        if (response.data != null) {
          bool error = response.data["error"];
          String message = response.data["message"];
          if (!error) {
            Map<String, dynamic> data = response.data["data"];
            String botToken = data["botToken"];
            return data;
          } else {
            throw message;
          }
        } else {
          throw "Serverdan bo'sh javob olingan";
                }
      } else {
        throw "Server tomonidan xato kodi: ${response.statusCode}";
      }
    } catch (e) {
      throw '$e';
    }
  }
}
