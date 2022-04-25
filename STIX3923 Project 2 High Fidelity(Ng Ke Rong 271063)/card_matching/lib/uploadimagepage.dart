import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:card_matching/model/config.dart';
import 'package:card_matching/model/card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'addimagepage.dart';
import 'deleteimagepage.dart';
import 'package:device_info/device_info.dart';


class UploadImagePage extends StatefulWidget {
  const UploadImagePage({Key? key}) : super(key: key);

  @override
  UploadImagePageState createState() => UploadImagePageState();

}

class UploadImagePageState extends State<UploadImagePage>{

  late List _cardList = [];
  String textCenter = "Please Upload an Image";
  late double screenHeight, screenWidth;
  late ScrollController _scrollController;
  int scrollcount = 10;
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String deviceID = " ";


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadCards();
   
  }

  

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Page",
        style: TextStyle (fontSize: 30, color: Color(0xFF3E2723), fontWeight: FontWeight.bold)),
        actions: <Widget>[
    IconButton(
      icon: const Icon(
        Icons.restart_alt,
        color: Colors.white,
        size: 40.0
      ),
      onPressed: () {
        _loadCards();
      },
    ),
    IconButton(
      icon: const Icon(
        Icons.add,
        color: Colors.white,
        size: 40.0
      ),
      onPressed: () {
        if(_cardList.length <= 7) {
          Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) => const AddImagePage()));
        }else{
          imageDialog();
        }
      },
    ),
    IconButton(
      icon: const Icon(
        Icons.delete,
        color: Colors.white,
        size: 40.0
      ),
      onPressed: () {
         Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) => const DeleteImagePage()));
      },
    ),
  ],
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
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(15)),
                ),
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
  void _scrollListener() {
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
          content: const Text("The limited amount of image is 8. Please delete some of the images.", style: TextStyle()),
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