import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:card_matching/cardinfo.dart';
import 'cardimage.dart';
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
  bool hideTest = false;
  final GameEx _game = GameEx();
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  late List _cardList1 = [];
  late List _cardList2 = [];
  late List newCardList = [];
  List<String>? gameImg;
  final String hiddenCardpath = Config.server + "/card_matching/images/hidden.png";
  List<Map<int, String>> matchCheck = [];

  //game stats
  double latestScore = 0;
  double score = 0;
  int timeleft = 180;
  double highestScore =0;

  @override
  void initState(){
    super.initState();
    _loadCards();
    _game.initGame();
    _countTimeLeft();
     loadScore();
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



  void _countTimeLeft()  {
    
    Timer.periodic(const Duration(seconds: 1), (timer){
      if (timeleft > 0 ){
      setState(() {
        timeleft--;
        if (score == 400){
          timer.cancel();
            
          latestScore = score + (timeleft*0.25);
          score = latestScore;
            if (latestScore > highestScore){
              updateScore();
              
            }
          successDialog();
        }
      });
      } else{
        timer.cancel();
        failDialog();
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xFFFFECB3),
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
              cardInfo("Time", timeleft.toString()),
              cardInfo("Score", "$score"),
              cardInfo("Highest","$highestScore")
            ],
          ),
          SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                  itemCount: gameImg!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        loadScore();
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
                          color: const Color(0xFFFFB46A),
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
  void failDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Fail",
            style: TextStyle(fontSize: 30, color: Colors.red, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Retry",
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
            TextButton(
              child: const Text(
                "Exit",
                style: TextStyle(fontSize: 15, color: Colors.brown, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
     }
     );
      } 
  });
  }
  
  
}