import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:testbot/apilar/tokenAniqlash.dart';
import 'apilar/botHabarRaqaminiAniqlash.dart';
import 'apilar/botdagiXabararniAniqlash.dart';
import 'apilar/ohirgiUpdateIdniBasegaSaqlash.dart';
import 'apilar/startTugmasniBosganlargaKontaktYuborish.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late String botToken = '';
  late TokenAniqlash _tokenAniqlash = TokenAniqlash();
  late String botHabarRaqami = '';
  late botHabarRaqaminiAniqlash _botHabarRaqaminiAniqlash  =  botHabarRaqaminiAniqlash();
  late String botdagiOhirgiUpdateId  =  '';

  late List<dynamic> botdagiXabararniAniqlash  =  [];
  late BotdagiXabararniAniqlash _botdagiXabararniAniqlash;
  late OhirgiUpdateIdniBasegaSaqlash _ohirgiUpdateIdniBasegaSaqlash;

  List<String> barchaXabarlar = [];
  List<String> startXabarlar = [];
  List<String> kontakt = [];



  late KontaktYuborish _kontaktYuborish;


  // void initState() {
  //   super.initState();
  //   _getToken();
  // }




  Future<void> _getToken() async {
    try {
      Map<String, dynamic>? data =
          (await _tokenAniqlash.getToken()) as Map<String, dynamic>?;
      if (data != null && data.containsKey('botToken')) {
        setState(() {
          botToken = data['botToken'];
          print(botToken);
        });
      } else {}
    } catch (e) {}
  }

  Future<void> _getbotHabarRaqaminiAniqlash() async {
    try {
      Map<String, dynamic> data =
          await _botHabarRaqaminiAniqlash.getbotHabarRaqaminiAniqlash();
      setState(() {
        botHabarRaqami = data['botXabarRaqami'];
      });
    } catch (e) {}
  }

  Future<void> _getBotdagiXabararniAniqlash() async {
    try {
      _botdagiXabararniAniqlash =
          BotdagiXabararniAniqlash(botToken, botHabarRaqami);
      List<dynamic> data =
          await _botdagiXabararniAniqlash.botdagiXabararniAniqlash();

      // Ohirgi update ID ni olish
      if (data.isNotEmpty) {
        var ohirgiUpdate = data.last;
        var updateId = ohirgiUpdate['update_id'];
        botdagiOhirgiUpdateId = updateId.toString();
      }

      setState(() {
        botdagiXabararniAniqlash = data;
      });
    } catch (e) {}
  }

  Future<void> _getohirgiUpdateIdniBasegaSaqlash() async {
    try {
      _ohirgiUpdateIdniBasegaSaqlash =
          OhirgiUpdateIdniBasegaSaqlash(botdagiOhirgiUpdateId);
      Map<String, dynamic> UpdateIdSaqlashData =
          await _ohirgiUpdateIdniBasegaSaqlash.ohirgiUpdateIdniBasegaSaqlash();
    } catch (e) {}
  }

  Future<void> _getstartTugmasniBosganlargaKontaktYuborish() async {
    try {
      for (var item in startXabarlar) {
        if (item != null) {
          final replyMarkup = json.encode({
            'keyboard': [
              [
                {'text': 'Kontakt yuborish', 'request_contact': true},
              ],
            ],
            'one_time_keyboard': true,
            'resize_keyboard': true
          });
          final chatId = item.split("\n")[0].split(": ")[1];

          _kontaktYuborish = KontaktYuborish(botToken,chatId,'Sizga sms xabarnoma borib turishi uchun telefon raqamingizni bizga junating.',replyMarkup);
          bool data = await _kontaktYuborish.kontaktYuborish();

        }
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Bot'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _getToken,
                  child: Text("Tokenni aniqlash"),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(botToken)
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _getbotHabarRaqaminiAniqlash,
                  child: Text("Bot xabar raqamini aniqlash"),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(botHabarRaqami)
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _getBotdagiXabararniAniqlash();
                    await _getohirgiUpdateIdniBasegaSaqlash();
                  },
                  child: Text("Botdagi malumotlarni aniqlash"),
                ),
                SizedBox(
                  width: 20,
                ),
                Text("oxirgi update_id: $botdagiOhirgiUpdateId")
              ],
            ),
            SizedBox(
              height: 20,
            ),


            ElevatedButton(
              onPressed: () => xabarlarniYigish(),
              child: Text("Botga yozilgan xabarlarni aniqlash"),
            ),

            SizedBox(height: 10,),

            ElevatedButton(
              onPressed: () async {
                await _getstartTugmasniBosganlargaKontaktYuborish();
              },
              child: Text(
                  "start tugmasini bosganlarga kontakt yuborish tugma chiqarish"),
            ),

            SizedBox(
              height: 20,
            ),

            ElevatedButton(
              onPressed: () => kantaktYuborish(),
              child: Text(
                  "Kontakt yuborganlar"),
            ),

            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: botdagiXabararniAniqlash.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(botdagiXabararniAniqlash[index].toString()),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true, // Bu qator orqali o'lchamini belgilaydi
                    children: barchaXabarlar.map((data) => ListTile(title: Text(data))).toList(),
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true, // Bu qator orqali o'lchamini belgilaydi
                    children: startXabarlar.map((data) => ListTile(title: Text(data))).toList(),
                  ),
                ),

                Expanded(
                  child: ListView(
                    shrinkWrap: true, // Bu qator orqali o'lchamini belgilaydi
                    children: kontakt.map((data) => ListTile(title: Text(data))).toList(),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }


  void xabarlarniYigish() {
    for (var item in botdagiXabararniAniqlash) {
      if (item['message'] != null) {
        var from = item['message']['from'];
        var text = item['message']['text'];
        if (from != null) {
          var id = from['id'];
          var first_name = from['first_name'];
          var username = from['username'];



          barchaXabarlar.add("ID: $id");
          barchaXabarlar.add("first_name: $first_name");
          barchaXabarlar.add("username: $username");
          barchaXabarlar.add("text: $text");

          if(text =="/start"){

            startXabarlar.add("ID: $id");
            startXabarlar.add("first_name: $first_name");
            startXabarlar.add("username: $username");
            startXabarlar.add("text: $text");


          }
        }
      }
    }
    setState(() {});
  }

  void kantaktYuborish() {
    for (var item in botdagiXabararniAniqlash) {
      if (item['message'] != null) {
        var from = item['message']['from'];
        var text = item['message']['text'];
          // Contact malumotlari
          if (item['message']['contact'] != null) {
            var contact = item['message']['contact'];
            var contactPhoneNumber = contact['phone_number'];
            var contactFirstName = contact['first_name'];
            var contactLastName = contact['last_name'];
            var contactUserId = contact['user_id'];

            kontakt.add("Contact Phone Number: $contactPhoneNumber");
            kontakt.add("Contact First Name: $contactFirstName");
            kontakt.add("Contact Last Name: $contactLastName");
            kontakt.add("Contact User ID: $contactUserId");
          }

      }
    }
    setState(() {});
  }

}
