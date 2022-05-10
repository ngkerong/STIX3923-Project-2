import 'package:flutter/material.dart';
import 'select_level_page.dart';
import 'settingpage.dart';
import 'uploadimagepage.dart';
import 'dart:io';
import 'package:flame_audio/flame_audio.dart';  
import 'package:shared_preferences/shared_preferences.dart';
import 'colorsettings.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late double screenHeight, screenWidth;
  bool audio = true;
  String getColor = '';
  var colCode = '';
  

  @override
  void initState(){
    super.initState();
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('bgm.mp3', volume: 100);
    setColor();
    getBgmColor();
  }

  void setColor() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getColor = (prefs.getString('colorCode') ?? "Default"); 
    print(getColor);
  }


  getBgmColor(){
    switch (getColor) {
      case "Default":
        return Color(0xFFFFECB3);
        
      case "Blue":
        return Color(0xFFE1F5FE);
        
      case "Red":
        return Color(0xFFFFCDD2);   
    }
  }

  void loadAudio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      audio = (prefs.getBool('getAudio') ?? true);
    });
  }

  void offAudio() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      
      prefs.setBool('get', false);
      audio = (prefs.getBool('getAudio') ?? true);
    });
  }

  void onAudio() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      
      prefs.setBool('get', true);
      audio = (prefs.getBool('getAudio') ?? true);
    });
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    
    return  Scaffold(
    body: Container(
      color: Color(0xFFFFECB3),
      child: Stack(
      children: [
        upperHalf(context),
        lowerHalf(context)
      ],
      ),
    ));
  }
  Widget upperHalf(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return ClipPath(
        clipper: CurvedBottomClipper(),
        child:
          Container(
          color: const Color(0xFFFDD54F),
          width: screenWidth,
          height: 300,
          child:  Center(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Image.asset('assets/images/newlogo.png', 
            height: 220, 
            width: 220,
            fit: BoxFit.fill,
            ),
            Stack(
                children: <Widget>[
                  // Stroked text as border.
                  Text(
                    'Card Game',
                    style: TextStyle(
                      fontSize: 50,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6
                        ..color = Colors.brown,
                    ),
                  ),
                  // Solid text as fill.
                  Text(
                    'Card Game',
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.orange[100],
                    ),
                  ),
                ],
              )
            ],
            ),
              ),
            ),
          ));
  }
  Widget lowerHalf(BuildContext context) {
       return Container(
          width: screenWidth,
          height: screenHeight,
          margin: EdgeInsets.only(top: screenHeight/2),
      padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children:   [
            Card(
            child:ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.orange[50],
              side: const  BorderSide(width: 3.0, color: Colors.brown,),
              fixedSize: Size(screenWidth/1.8, 80),),
            onPressed: ( ) {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) => const SelectLevelPage()));
              },
            child:  const Text('Play Game',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.brown,
              fontSize: 28)),
          )),
          SizedBox(height:screenHeight/20),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children:  [
            GestureDetector(
            child: Container(
              decoration: BoxDecoration(
              border: Border.all(color: Colors.brown, width: 4),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.orange[50],     
            ),
            child: IconButton(
              iconSize: 60,
              icon: const Icon(Icons.image_outlined),
              color: Colors.brown,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) => const UploadImagePage()));
              },
  ),)),
      SizedBox(width:screenWidth/10),
      Container(
              decoration: BoxDecoration(
              border: Border.all(color: Colors.brown, width: 4),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.orange[50],     
            ),
            child: IconButton(
              iconSize: 60,
              icon: const Icon(Icons.settings_outlined),
              color: Colors.brown,
              onPressed: () {
                 Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) => const SettingPage()));
              },
  ),),
      ],
          )
	  
            ],
          ),
        );   

  }
}

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final roundingHeight = size.height * 0.2;
    final filledRectangle =
        Rect.fromLTRB(0, 0, size.width, size.height - roundingHeight);
    final roundingRectangle = Rect.fromLTRB(
        -5, size.height - roundingHeight * 2, size.width + 5, size.height);

    final path = Path();
    path.addRect(filledRectangle);
    path.arcTo(roundingRectangle, size.height , size.height * 4, true);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
