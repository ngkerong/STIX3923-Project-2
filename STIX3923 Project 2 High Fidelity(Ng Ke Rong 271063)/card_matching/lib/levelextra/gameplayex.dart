import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:card_matching/cardinfo.dart';
import "dart:async";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:card_matching/model/config.dart';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class GamePlayExPage extends StatefulWidget {
  const GamePlayExPage({Key? key}) : super(key: key);

  @override
 GamePlayExPageState createState() => GamePlayExPageState();

}


class GamePlayExPageState extends State<GamePlayExPage> {
  //setting text style
  
  
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  late List _cardList1 = [];
  late List _cardList2 = [];
  late List newCardList = [];
  List<String>? gameImg;
  final String hiddenCardpath = Config.server + "/card_matching/images/dots.png";
  List<Map<int, String>> matchCheck = [];
  String getColor = '';
  String selectCol = " ";
  String latestCol = " ";
  Color color1 = Color(0xFFFFECB3);
  Color color2 = Color(0xFFE1F5FE);
  Color color3=  Color(0xFFFFCDD2); 
  String valueString =" ";
  int value = 0;
  Color otherColor = Color(0x00000000);
  Color color4 = Color(0xFFFDD54F);
  Color color5 = Color(0xFF8C9EFF);
  Color color6 = Color(0xFFF48FB1);
Color otherColor2 = Color(0x00000000);


  //game stats
  double latestScore = 0;
  double score = 0;
  int timeleft = 0;
  double highestScore =0;
  int scoreEx = 0;
  int latestTime = 0;
  int fastestTime = 0; 
  int counter = 0;
  int count = 0;

  @override
  void initState(){
    super.initState();
    _loadCards();
     loadScore();
     loadTime();
     loadColor();
  }


  void loadScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      highestScore = (prefs.getDouble('highScoreEx') ?? 0);
    });
  }

  void updateScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setDouble('highScoreEx', latestScore);
      highestScore = (prefs.getDouble('highScoreEx') ?? 0);
    });
  }

  void getScore() async {
    setState((){
      for(int i = 0; i < _cardList1.length; i++ ){
          scoreEx += 100;
      }
    });
  }

  void getLength()  {
    
    setState((){
      if(newCardList.length < 10){
        counter = 3;
      }else if(newCardList.length <20 && newCardList.length >=10){
        counter = 4;
      }else{
        counter = 5;
      }
    });
  }

  void loadTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      fastestTime = (prefs.getInt('fastestTimeEx') ?? 0);
    });
  }

  void updateTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('fastestTimeEx', latestTime);
      fastestTime = (prefs.getInt('fastestTimeEx') ?? 0);
    });
  }

  void _countTimeLeft()  {
    
    Timer.periodic(const Duration(seconds: 1), (timer){
      if (timeleft >= 0 ){
      setState(() {
        timeleft++;
        if (score == scoreEx){
          timer.cancel();
            latestTime = timeleft;
            if(timeleft <= 300){
              latestScore = score + (50*100/timeleft);
            }else if(timeleft > 300 && timeleft < 540){
              latestScore = score + (25*100/timeleft);
            }else{
              latestScore = score + (10*100/timeleft);
            }
          latestScore = double.parse(latestScore.toStringAsFixed(2));
          score = latestScore;
              if (latestScore > highestScore){
                updateScore();
                updateTime();
              }
          count = 0;
          successDialog();
        }
      });
      } 
    });
  }

  void loadColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      selectCol = (prefs.getString('colorCode') ?? "Default");
      bgm1();
      bgm2();
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


void bgm2() async{
  
    switch (selectCol) {
      case "Default":
        latestCol = color4.toString();
        break;

      case "Blue":
        latestCol = color5.toString();
        break;

      case "Red":
        latestCol = color6.toString();
        break;
    }
    valueString = latestCol.split('(0x')[1].split(')')[0]; // kind of hacky..
    value = int.parse(valueString, radix: 16);
    otherColor2 = Color(value);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:otherColor,
      appBar: AppBar(
        title: const Text("Back",
        style: TextStyle (fontSize: 30, color: Color(0xFF3E2723), fontWeight: FontWeight.bold)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              cardInfo("Time(s)", timeleft.toString()),
              cardInfo("Score", "$score"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ 
              cardInfo("Highest Score","$highestScore"),
              cardInfo("Fatest Time(s)","$fastestTime")
            ],
          ),
          SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                  itemCount: gameImg!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: counter,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        loadScore();
                        count++;
                        if (count == 1) {
                        _countTimeLeft();
                        }
                        setState(() {
                          //incrementing the clicks
                          gameImg![index] = Config.server + "/card_matching/images/" + newCardList[index]["cardid"] + ".png";
                          matchCheck
                              .add({index:Config.server + "/card_matching/images/" + newCardList[index]["cardid"] + ".png"});
                          
                        });
                        if (matchCheck.length == 2) {
                          if (matchCheck[0].values.first ==
                              matchCheck[1].values.first) {
                            
                            //incrementing the score
                            score += 100;
                            matchCheck.clear();
                          } else {
                            

                            Future.delayed(const Duration(milliseconds: 500), () {
                            
                              setState(() {
                                gameImg![matchCheck[0].keys.first] =
                                    hiddenCardpath;
                                gameImg![matchCheck[1].keys.first] =
                                    hiddenCardpath;
                                matchCheck.clear();
                              });
                            });
                          }
                        }
                      },
                      child: CachedNetworkImage(
                      imageUrl: gameImg![index],
                      imageBuilder: (context, imageProvider) => Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: otherColor2,
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ));
                  }))
        ],
      ),
    );
  }
  void successDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Success",
            style: TextStyle(fontSize: 30, color: Colors.green, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Replay",
                style: TextStyle(fontSize: 15, color: Colors.brown, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => super.widget));
              },
            ),
          ],
        );
      },
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
      _cardList1 = parsedJson['data']['cards'];
      _cardList2 = parsedJson['data']['cards'];
      newCardList = List.from(_cardList1)..addAll(_cardList2);
      newCardList.shuffle();
      gameImg = List.generate(newCardList.length, (index) => hiddenCardpath);
      getScore();
      print(scoreEx);
      getLength();
     }
     );
      } 
  });
  }
  
  
}