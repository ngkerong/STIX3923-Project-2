import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';  
import 'package:shared_preferences/shared_preferences.dart';
import 'colorsettings.dart';



class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  SettingPageState createState() => SettingPageState();

}

class SettingPageState extends State<SettingPage>{

  late double screenHeight, screenWidth;
  bool audio = true;
  String selectCol = " ";
  List<String> colorlist = [
     "Default",
     "Blue",
     "Red",
   ];
   final Color1 _color1 = Color1();

   controlAudio() {
    
    if(audio){
      return const Icon(Icons.volume_up_outlined);
    }else{
      return const Icon(Icons.volume_mute);
    }
  
  }

  void initState(){
    super.initState();
    loadColor();
    _color1.setColor();
  }

  void loadColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      selectCol = (prefs.getString('colorCode') ?? "Default");
    });
  }


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Page",
        style: TextStyle (fontSize: 30, color: Color(0xFF3E2723), fontWeight: FontWeight.bold)),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        color:  Color(_color1.bgm1()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Background Music',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                  fontSize: 35
                ),
              ),
              SizedBox(height: screenHeight/20),
              Container(
              decoration: BoxDecoration(
              border: Border.all(color: Colors.brown, width: 4),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.orange[50],     
            ),

            child: IconButton(
              iconSize: 60,
              icon: controlAudio(),
              color: Colors.brown,
              onPressed: () {
                if(audio){
                  FlameAudio.bgm.pause();
                  audio = false;
                  controlAudio();
                }else{
                  FlameAudio.bgm.resume();
                  audio = true;
                  controlAudio();
                }
              },
  ),),
            SizedBox(height: screenHeight/18),
            const Text(
                'Background Color',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                  fontSize: 35
                ),
              ),
              SizedBox(height: screenHeight/20),
              DecoratedBox(
                decoration: const BoxDecoration( 
                  color:Colors.white,
                ),
            child: DropdownButton(
              itemHeight: 60,
              value: selectCol,
              
              onChanged: (newValue){
                setState((){
                  selectCol = newValue.toString();
                  _color();
                });
              },
              items: colorlist.map((selectCol){
                return DropdownMenuItem(
                  child : Text(
                    selectCol,
                  ),
                value: selectCol,
                );
              }).toList(),
          ),)
          ]))
    );
  }
  Future <void> _color() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();

     setState((){
        switch (selectCol) {
          case "Default":
            prefs.setString('colorCode', "Default");
            break;
          case "Blue":
            prefs.setString('colorCode', "Blue");
            break;
          case "Red":
            prefs.setString('colorCode', "Red");
            break; 
        }
      _color1.setColor();

      });
  }
}