import 'dart:convert';
import 'package:dio/dio.dart';

class botHabarRaqaminiAniqlash {
  final Dio dio = Dio();

  Future<Map<String, dynamic>> getbotHabarRaqaminiAniqlash() async {
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

      final response = await dio.get("getBotXabarTartibRaqam");
      if (response.statusCode == 200) {
        if (response.data != null) {
          bool xatolik = response.data["error"];
          String massageXatolik = response.data["message"];
          if (!xatolik) {
            dynamic responseData = response.data["data"];
            if (responseData is Map<String,dynamic>) {
              return responseData;
            } else {
              throw "Server tomonidan noto'g'ri formatda ma'lumot olingan";
            }
          } else {
            throw massageXatolik;
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
