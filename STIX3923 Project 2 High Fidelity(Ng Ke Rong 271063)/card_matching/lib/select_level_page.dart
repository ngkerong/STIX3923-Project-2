
import 'package:flutter/material.dart';
import 'level1/gameplay1.dart';
import 'level2/gameplay2.dart';
import 'level3/gameplay3.dart';
import 'level4/gameplay4.dart';
import 'level5/gameplay5.dart';
import 'levelextra/gameplayex.dart';

class SelectLevelPage extends StatefulWidget {
  const SelectLevelPage({Key? key}) : super(key: key);

  @override
  SelectLevelPageState createState() => SelectLevelPageState();

}

class SelectLevelPageState extends State<SelectLevelPage>{

  late double screenHeight, screenWidth;

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
        color: const Color(0xFFFFECB3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                    Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) => const GamePlayExPage()));
                  },
                  child: const Text("Ex",style: TextStyle(fontSize: 30, color: Colors.brown, fontWeight: FontWeight.bold)),
                ),
            ),
            
            ]),
            ]
        )
      ),
      );
  }



}