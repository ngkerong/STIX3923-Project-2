import 'package:flutter/material.dart';
import 'select_level_page.dart';
import 'settingpage.dart';
import 'uploadimagepage.dart';
import 'dart:io';
import 'package:flame_audio/flame_audio.dart';  
import 'package:shared_preferences/shared_preferences.dart';

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
  String selectCol = " ";
  String latestCol = " ";
  String selectedLang = " ";
  String lang1 = " ";
  String lang2 = " ";
  Color color1 = Color(0xFFFFECB3);
  Color color2 = Color(0xFFE1F5FE);
  Color color3=  Color(0xFFFFCDD2); 
  Color color4 = Color(0xFFFDD54F);
  Color color5 = Color(0xFF8C9EFF);
  Color color6 = Color(0xFFF48FB1);
  String valueString =" ";
  int value = 0;
  Color otherColor = Color(0x00000000);
  Color otherColor2 = Color(0x00000000);

  @override
  void initState(){
    super.initState();
    setState((){
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('bgm.mp3', volume: 30);
    loadColor();
    loadLanguage();
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

  void loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      selectedLang = (prefs.getString('languageSet') ?? "English");
      setLanguage();
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

void setLanguage() async{

    setState((){
    switch (selectedLang) {
      case "English":
        lang1 = "Play Game";
        lang2 = "Copyrighted images by";
        break;

      case "Malay":
        lang1 = "Mula Main";
        lang2 = "Gambar berhak cipta oleh";
        break;

    }
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
      color: otherColor,
      child: Stack(
      children: [
        upperHalf(context),
        lowerHalf(context)
      ],
      ),
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        copyrightDialog();},
        child: const Icon(
          Icons.copyright_outlined,
          color: Colors.brown,
          size: 40,),
        backgroundColor: Colors.orange[50]
      ), 
    );
  }
  Widget upperHalf(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return ClipPath(
        clipper: CurvedBottomClipper(),
        child:
          Container(
          color: otherColor2,
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
            child: Text('$lang1',
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
              icon: const Icon(Icons.upload_outlined),
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
                Navigator.push( context, MaterialPageRoute( builder: (context) => SettingPage()), 
              ).then((value) => setState(() {
                loadColor();
                loadLanguage();
              }));
              },
  ),),
      ],
          ),
          
	  
            ],
          ),
          
        );   

  }

  void copyrightDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "$lang2",
            style: TextStyle(fontSize: 18, color: Colors.brown, fontWeight: FontWeight.bold),
          ),
          content:Text("sudowoodo\ndrical\nNopee_erini\nNavakun Suwantragul\nanimicsgo\nTenor\nsetory\nQianTuWang\nMaxis\nAmethystDesign\nIcongeek26\neucalyp\nFlat-icons-com\nFreepik\nSmashicons"
          , style: TextStyle()),
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


