import 'package:flutter/material.dart';
import 'select_level_page.dart';
import 'settingpage.dart';
import 'uploadimagepage.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Matching',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.amber,

      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  late double screenHeight, screenWidth;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        //Play the Music
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        //Stop the music
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        //Stop the music
        break;
    }
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
      color: const Color(0xFFFFECB3),
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
            padding: const EdgeInsets.fromLTRB(0, 60, 0, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Image.asset('assets/images/logo.png', 
            height: 220, 
            width: 220,
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
            Container(
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
  ),),
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
