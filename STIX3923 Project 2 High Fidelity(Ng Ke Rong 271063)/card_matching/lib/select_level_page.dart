import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'level1/gameplay1.dart';
import 'level2/gameplay2.dart';
import 'level3/gameplay3.dart';
import 'level4/gameplay4.dart';
import 'level5/gameplay5.dart';
import 'levelextra/gameplayex.dart';
import 'package:http/http.dart' as http;
import 'package:card_matching/model/config.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SelectLevelPage extends StatefulWidget {
  const SelectLevelPage({Key? key}) : super(key: key);

  @override
  SelectLevelPageState createState() => SelectLevelPageState();

}

class SelectLevelPageState extends State<SelectLevelPage>{

  late double screenHeight, screenWidth;
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  late List _cardList = [];
  String selectCol = " ";
  String latestCol = " ";
  Color color1 = Color(0xFFFFECB3);
  Color color2 = Color(0xFFE1F5FE);
  Color color3=  Color(0xFFFFCDD2); 
  String valueString =" ";
  int value = 0;
  Color otherColor = Color(0x00000000);

  @override
  void initState() {
    super.initState();
    setState(() {
    _loadCards();
    loadColor();
    });
  }

    void loadColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      selectCol = (prefs.getString('colorCode') ?? "Default");
      bgm1();
    });
  }

  void bgm1() async{
  
    switch (selectCol) {
      case "Default":
        latestCol = color1.toString();
        break;

      case "Blue":
        latestCol = color2.toString();
        break;

      case "Red":
        latestCol = color3.toString();
        break;
    }
    valueString = latestCol.split('(0x')[1].split(')')[0]; // kind of hacky..
    value = int.parse(valueString, radix: 16);
    otherColor = Color(value);
}

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Back",
        style: TextStyle (fontSize: 30, color: Color(0xFF3E2723), fontWeight: FontWeight.bold)),
      ),
      body: Container(
        alignment: Alignment.center,
        color: otherColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                'Tap the level you want to play',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                  fontSize: 28
                ),
              ),
            SizedBox(height:screenHeight/20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
              border: Border.all(color: Colors.brown, width: 3),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.orange[50],     
            ),
            child:
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 30, 
                  color: Colors.brown, 
                  fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) => const GamePlay1Page()));
                  },
                  child: const Text("1",style: TextStyle(fontSize: 30, color: Colors.brown, fontWeight: FontWeight.bold)),
                ),
            ),
            SizedBox(width:screenWidth/10),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
              border: Border.all(color: Colors.brown, width: 3),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.orange[50],     
            ),
            child:
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 30, 
                  color: Colors.brown, 
                  fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) => const GamePlay2Page()));
                  },
                  child: const Text("2",style: TextStyle(fontSize: 30, color: Colors.brown, fontWeight: FontWeight.bold)),
                ),
            ),
            SizedBox(width:screenWidth/10),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
              border: Border.all(color: Colors.brown, width: 3),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.orange[50],     
            ),
            child:
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 30, 
                  color: Colors.brown, 
                  fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) => const GamePlay3Page()));
                  },
                  child: const Text("3",style: TextStyle(fontSize: 30, color: Colors.brown, fontWeight: FontWeight.bold)),
                ),
            ),
            ]),
            SizedBox(height:screenWidth/20),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
              border: Border.all(color: Colors.brown, width: 3),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.orange[50],     
            ),
            child:
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 30, 
                  color: Colors.brown, 
                  fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) => const GamePlay4Page()));
                  },
                  child: const Text("4",style: TextStyle(fontSize: 30, color: Colors.brown, fontWeight: FontWeight.bold)),
                ),
            ),
            SizedBox(width:screenWidth/10),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
              border: Border.all(color: Colors.brown, width: 3),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.orange[50],     
            ),
            child:
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 30, 
                  color: Colors.brown, 
                  fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) => const GamePlay5Page()));
                  },
                  child: const Text("5",style: TextStyle(fontSize: 30, color: Colors.brown, fontWeight: FontWeight.bold)),
                ),
            ),
            SizedBox(width:screenWidth/10),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
              border: Border.all(color: Colors.brown, width: 3),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.orange[50],     
            ),
            child:
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 30, 
                  color: Colors.brown, 
                  fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if(_cardList.length >= 3){
                    Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) => const GamePlayExPage()));
                    }else{
                    imageDialog();
                    }
                  },
                  child: const Text("Sp",style: TextStyle(fontSize: 30, color: Colors.brown, fontWeight: FontWeight.bold)),
                ),
            ),
            
            ]),
            ]
        )
      ),
      );
  }
 Future<void> _loadCards() async {
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    String userid = androidInfo.androidId;

    http.post(Uri.parse(Config.server + "/card_matching/php/loadcard.php"), 
    body: {
      "userid":userid,
    
    }).then((response) {
      var rescode = response.statusCode;
    if(rescode == 200){
     setState(() {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      _cardList = parsedJson['data']['cards'];
      
     }
     );
      } 
  });
  }
  
void imageDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Message",
            style: TextStyle(fontSize: 30, color: Colors.brown, fontWeight: FontWeight.bold),
          ),
          content: const Text("The amount of images upload must be more than 2 to play this level.", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Ok",
                style: TextStyle(fontSize: 15, color: Colors.brown, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}