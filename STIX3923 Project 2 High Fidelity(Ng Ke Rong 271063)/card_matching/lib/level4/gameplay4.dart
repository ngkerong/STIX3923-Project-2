import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:card_matching/cardinfo.dart';
import 'cardimage.dart';
import "dart:async";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:card_matching/level5/gameplay5.dart';
import 'package:flame_audio/flame_audio.dart';  

class GamePlay4Page extends StatefulWidget {
  const GamePlay4Page({Key? key}) : super(key: key);

  @override
 GamePlay4PageState createState() => GamePlay4PageState();

}


class GamePlay4PageState extends State<GamePlay4Page> {
  //setting text style
  bool hideTest = false;
  final Game4 _game = Game4();
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
  String selectedLang = " ";
  String lang1 = " ";
  String lang2 = " ";
  String lang3 = " ";
  String lang4 = " ";
  String lang5 = " ";
  String lang6 = " ";
  String lang7 = " ";
  String lang8 = " ";


  //game stats
  double latestScore = 0;
  double score = 0;
  int timeleft = 0;
  double highestScore =0;
  int fastestTime = 0;
  int latestTime = 0;
  int counter = 0;

  @override
  void initState(){
    super.initState();
    _game.initGame();
     loadScore();
     loadTime();
    _game.cards_list.shuffle();
    loadColor();
    loadLanguage();
    setLanguage();
  }

  void loadScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      highestScore = (prefs.getDouble('highScore4') ?? 0);
    });
  }

  void updateScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setDouble('highScore4', latestScore);
      highestScore = (prefs.getDouble('highScore4') ?? 0);
    });
  }

   void loadTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      fastestTime = (prefs.getInt('fastestTime4') ?? 0);
    });
  }

  void updateTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('fastestTime4', latestTime);
      fastestTime = (prefs.getInt('fastestTime4') ?? 0);
    });
  }

   void _countTimeLeft()  {
    
    Timer.periodic(const Duration(seconds: 1), (timer){
      if (timeleft >= 0 ){
      setState(() {
        timeleft++;
        if (score == 600){
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
          counter = 0;
          FlameAudio.play('success.mp3');
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

  void loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      selectedLang = (prefs.getString('languageSet') ?? "English");
      setLanguage();
    });
  }

  void setLanguage() async{

    setState((){
    switch (selectedLang) {
      case "English":
        lang1 = "Back";
        lang2 = "Time(s)";
        lang3 = "Scores";
        lang4 = "Highest Scores";
        lang5 = "Fastest Time(s)";
        lang6 = "Success";
        lang7 = "Continue";
        lang8 = "Restart";
        break;

      case "Malay":
        lang1 = "Kembali";
        lang2 = "Masa(s)";
        lang3 = "Markah";
        lang4 = "Markah Tertinggi";
        lang5 = "Masa Terpantas(s)";
        lang6 = "Berjaya";
        lang7 = "Teruskan";
        lang8 = "Mulakan Semula";
        break;

    }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:otherColor,
      appBar: AppBar(
        title: Text("$lang1",
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
              cardInfo("$lang2", timeleft.toString()),
              cardInfo("$lang3", "$score"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ 
              cardInfo("$lang4","$highestScore"),
              cardInfo("$lang5","$fastestTime")
            ],
          ),
          SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                  itemCount: _game.gameImg!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        FlameAudio.play('flip.mp3');
                        loadScore();
                        counter ++;
                        if (counter == 1){
                          _countTimeLeft();
                        }
                        setState(() {
                          //incrementing the clicks
                          _game.gameImg![index] = _game.cards_list[index];
                          _game.matchCheck
                              .add({index: _game.cards_list[index]});
                          
                        });
                        if (_game.matchCheck.length == 2) {
                          if (_game.matchCheck[0].values.first ==
                              _game.matchCheck[1].values.first) {
                            
                            //incrementing the score
                            FlameAudio.play('score.mp3');
                            score += 100;
                            _game.matchCheck.clear();
                          } else {
                            

                            Future.delayed(const Duration(milliseconds: 500), () {
                            
                              setState(() {
                                _game.gameImg![_game.matchCheck[0].keys.first] =
                                    _game.hiddenCardpath;
                                _game.gameImg![_game.matchCheck[1].keys.first] =
                                    _game.hiddenCardpath;
                                _game.matchCheck.clear();
                              });
                            });
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: otherColor2,
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: AssetImage(_game.gameImg![index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
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
          title: Text(
            "$lang6",
            style: TextStyle(fontSize: 30, color: Colors.green, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "$lang7",
                style: TextStyle(fontSize: 15, color: Colors.brown, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) => const GamePlay5Page()));
   
              },
            ),
            TextButton(
              child: Text(
                "$lang8",
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
}