
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime{

  String? location; //name of city
  String? time; //time
  String? flag; //url to flag
  String? url; //api endpoint
  bool isDaytime = true;

  WorldTime({this.location, this.flag, this.url});

  Future<void> getTime() async {

    try{
      Response response = await get(Uri(scheme: 'https', host: 'worldtimeapi.org', path:'/api/timezone/$url'));
      Map data = jsonDecode(response.body);
      
      String datetime = data['datetime'].toString();
      String offset = data['utc_offset'].substring(1,3);

      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: int.parse(offset)));
      isDaytime = now.hour > 6 && now.hour < 19 ? true : false;
      time = DateFormat.jm().format(now);
      print(isDaytime);
    }
    catch(e){
      time = 'could not get time data';      
    }

      
      
  }
}