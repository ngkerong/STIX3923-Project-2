import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:card_matching/model/config.dart';
import 'package:card_matching/model/card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ndialog/ndialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:device_info/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DeleteImagePage extends StatefulWidget {
  const DeleteImagePage({Key? key}) : super(key: key);

  @override
  DeleteImagePageState createState() => DeleteImagePageState();

}

class DeleteImagePageState extends State<DeleteImagePage>{

  late List _cardList = [];
  String textCenter = " ";
  late double screenHeight, screenWidth;
  late ScrollController _scrollController;
  int scrollcount = 6;
  File? _image;
  var pathAsset = "assets/images/add-image.png"; 
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String selectedLang = " ";
  String lang1 = " ";
  String lang2 = " ";
  String lang3 = " ";
  String lang4 = " ";
  String lang5 = " ";
  String lang6 = " ";
  String lang7 = " ";
  String lang8 = " ";
  String lang9 = " ";
  String latestCol = " ";
  String selectCol = " ";
  Color color1 = Color(0xFFFFECB3);
  Color color2 = Color(0xFFE1F5FE);
  Color color3=  Color(0xFFFFCDD2); 
  String valueString =" ";
  int value = 0;
  Color otherColor = Color(0x00000000);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadCards();
    loadLanguage();
    loadColor();
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
        lang2 = "Delete this image";
        lang3 = "Are you sure?";
        lang4 = "Yes";
        lang5 = "No";
        lang6 = "Deleting image..";
        lang7 = "Processing...";
        lang8 = "Success";
        lang9 = "Failed";
        break;

      case "Malay":
        lang1 = "Kembali";
        lang2 = "Padamkan gambar ini";
        lang3 = "Adakah anda pasti?";
        lang4 = "Ya";
        lang5 = "Tidak";
        lang6 = "Pandamkan Gambar..";
        lang7 = "Memproses...";
        lang8 = "Berjaya";
        lang9 = "Gagal";
        break;

    }
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
  
  setState((){
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
    });
}


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("$lang1",
        style: TextStyle (fontSize: 30, color: Color(0xFF3E2723), fontWeight: FontWeight.bold)),

      ),
      body: _cardList.isEmpty
        ? Center(
                child: Text(textCenter,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)))
          : RefreshIndicator(
        onRefresh: _loadCards ,
        child:  Column(children: [
         _cardList == null ?  const Flexible(
          child: Center(child: Text("No Data")),):
             Flexible(
               child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      controller:_scrollController,
                      childAspectRatio: ((screenWidth / screenHeight * 1.5)),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                    children: List.generate(scrollcount, (index){
              return InkWell(
                child: Container(
                child: Column(
                  children:[
                      const SizedBox(height:10),
                      CachedNetworkImage(
                            height: 120,
                            width: 120,
                            imageUrl: Config.server + "/card_matching/images/" + _cardList[index]["cardid"] + ".png",
                ),const SizedBox(height:10),
                      Text( _cardList[index]["date"] + "\n",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
        
                ]),
                decoration: BoxDecoration(
                    color: otherColor,
                    borderRadius: BorderRadius.circular(15)),
                ),
                onTap: () =>{_onDeleteImage(index)} ,
              );
              
            }),
             ),

               )))]
        ),
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
      textCenter = "Contain Data";
      if (scrollcount >= _cardList.length) {
            scrollcount = _cardList.length;
          }
      }
      );
        print(_cardList);
      } else {
        textCenter = "No data";
        return;
      } 
  });
  }
   _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        if (_cardList.length > scrollcount) {
          scrollcount = scrollcount + 10;
          if (scrollcount >= _cardList.length) {
            scrollcount = _cardList.length;
          }
        }
      });
    }
   }
   _onDeleteImage(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "$lang2",
            style: TextStyle(),
          ),
          content: Text("$lang3", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child:  Text(
                "$lang4",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteProduct(index);
              },
            ),
            TextButton(
              child: Text(
                "$lang5",
                style: TextStyle(),
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
   _deleteProduct(int index) {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: Text("$lang6"),
        title:  Text("$lang7"));
    progressDialog.show();
    http.post(Uri.parse(Config.server + "/card_matching/php/deletecard.php"),
        body: {
          "cardid": _cardList[index]['cardid'],
          
        }).then((response) {
      var data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "$lang8",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        Navigator.of(context).pop();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "$lang9",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        return;
      }
    });
  } 
}