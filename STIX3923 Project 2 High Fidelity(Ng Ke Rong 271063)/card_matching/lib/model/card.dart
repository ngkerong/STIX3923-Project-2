class Card {
  String? cardid;
  String? userid;
  String? date;

  Card(
    {
      required this.cardid,
      required this.userid,
      required this.date,
    }
  );

  Card.fromJson(Map<String, dynamic> json) {
    cardid = json["cardid"];
    userid = json["userid"];
    date = json["date"];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data["cardid"] = cardid;
    data["userid"] = userid;
    data["date"] = date;
    
    return data;
  }
}