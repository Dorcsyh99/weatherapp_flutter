// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_world_time_whether/services/wheather.dart';
import 'package:intl/intl.dart';


class Home extends StatefulWidget {
  Home({ Key? key }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> with TickerProviderStateMixin{

  @override
  void initState(){
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 60) , (Timer t) {refreshData(currentCity); });
    _rotate = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();
  }

  late AnimationController _rotate;
  Timer? timer;
  Map data = {};
  String currentCity = '';
  bool isLoading = false;
  List days = [];
  DateTime? currentTime;

  void refreshData(String city) async{
    Wheather newWeatherInstance = Wheather(location: city);
    _rotate.forward();
    await newWeatherInstance.getWheather();
    await newWeatherInstance.getAstronomy();
    await newWeatherInstance.getForecast();
    setState(() {
      data = {
        'location': newWeatherInstance.location,
        'temp': newWeatherInstance.temp,
        'rain': newWeatherInstance.rain,
        'desc': newWeatherInstance.desc,
        'windspeed': newWeatherInstance.windSpeed,
        'winddir': newWeatherInstance.windDirection,
        'humidity': newWeatherInstance.humidity,
        'cloudiness': newWeatherInstance.cloudiness,
        'uv': newWeatherInstance.uvi,
        'isday': newWeatherInstance.isDay,
        'currenttime': newWeatherInstance.currentTime,
        'sunset': newWeatherInstance.sunset,
        'sunrise': newWeatherInstance.sunrise,
        'moonphase': newWeatherInstance.moonPhase,
        'icon': newWeatherInstance.icon,
        'days': newWeatherInstance.days
      };
      days = data['days'];
      currentTime = data['currenttime'];
      _rotate.reset();
      print(data);
      print(currentTime);
    });
    
  }

  @override
  Widget build(BuildContext context) {    
    
    if(currentCity == ""){
      data = ModalRoute.of(context)!.settings.arguments as Map;
      currentCity = data['location'];
      days = data['days'];
      currentTime = data['currenttime'];
      _rotate.reset();
      print(currentTime);
    }

    String moonPhases(String moon){
      String img = 'assets/moon/full_moon.png';
      if(moon == 'New Moon'){
        img = 'assets/moon/new_moon.png';
      }
      if(moon == 'Waxing Crescent'){
        img = 'assets/moon/waxing_crescent.png';
      }
      if(moon == 'First Quarter'){
        img = 'assets/moon/first_quarter.png';
      }
      if(moon == 'Waxing Gibbous'){
        img = 'assets/moon/waxing_gibbous.png';
      }
      if(moon == 'Waning Gibbous'){
        img = 'assets/moon/waning_gibbous.png';
      }
      if(moon == 'Last Quarter'){
        img = 'assets/moon/last_quarter.png';
      }
      if(moon == 'Waning Crescent'){
        img = 'assets/moon/waning_crescent.png';
      }
      return img;
    }

    

    String conditionImages(String text, int isDay){
      String correctGif = '';
      if(text.contains('Sunny')){
        correctGif = 'assets/sun_anim.gif';
      }
      else if(text.contains('Mist')){
        correctGif = 'assets/mist_anim.gif';
      }
      else if(text.contains('Fog')){
        correctGif = 'assets/foggy_anim.gif';
      }
      else if(text.contains('Rain') || text.contains('rain')){
        correctGif = 'assets/rainy_sun.gif';
        if(data['isday'] != 1){
          correctGif = 'assets/rain_moon_anim.gif';
        }
      }
      else if(text.contains('Clear')){
        correctGif = "assets/moon_clear.gif";
      }
      else if(text.contains('Cloud') || text.contains('cloud') ||text.contains("Overcast")){
        correctGif = 'assets/cloudy_anim.gif';
        if(isDay == 0){
          correctGif = 'assets/cloudy_mmon_anim.gif';
        }
      }else{
        correctGif = 'assets/sun_anim.gif';
      }
      return correctGif;
    }

    



    ButtonStyle btnstyl = OutlinedButton.styleFrom(
      backgroundColor: Color.fromRGBO(7,244,158,0.7),
      primary: Color.fromRGBO(7,244,158,0.7),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
    );

    String daynightImage = data['isday'] == 1 ? 'assets/day_image.jpg' : 'assets/night_image.jpg';
    DateTime toFormat = data['currenttime']; 

    String day = DateFormat.EEEE().format(toFormat);
    String date = DateFormat.MMMMd().format(toFormat);

    String sunText = data['isday']==1 ? 'Sunset' : 'Sunrise';
    String sunImage = data['isday']==1 ? 'assets/sunset.png' : 'assets/sunrise.png';
    String sunTime = data['isday']==1 ? data['sunset'] : data['sunrise'];
    
    //String bgImage = data['isDaytime'] ? 'assets/day.jpg' : 'assets/night_moon.jpg';
    //Color? bgClor = data['isDaytime'] ? Colors.teal : Colors.blue[900];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.fromRGBO(7,244,158,1.0), Color.fromRGBO(87,7,255,1.0)],
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
            child: Column(
              children: [
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(7, 244, 158, 1.0), width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    image: DecorationImage(
                      image: AssetImage(daynightImage),
                      fit: BoxFit.cover,
                    )
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20,10,20,10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton.icon(
                              onPressed: (){
                                refreshData(currentCity);
                              },
                              icon: RotationTransition(
                                turns: Tween(begin: 0.0, end: 1.0).animate(_rotate),
                                child: Icon(Icons.refresh, color: Colors.grey[900])),
                              label: Text('Refresh', style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[900],
                                fontWeight: FontWeight.bold,
                              )),
                              style: btnstyl, 
                            ),
                            OutlinedButton.icon(onPressed: (){
                              Navigator.pushNamed(context,'/location', arguments: {'city': currentCity}).then((value) => {
                                  data = value as Map,
                                  print(data),
                                  currentCity = data['currentcity'].toString(),
                                  print(currentCity),
                                  refreshData(currentCity),
                              });
                            },
                              icon: Icon(Icons.location_on, color: Colors.grey[900]),
                              label: Text('Change location', style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[900],
                                fontWeight: FontWeight.bold,
                              )),
                              style: btnstyl, 
                            ),
                          ]
                        ),
                      ),
                      SizedBox(height: 35),
                      Column(
                        children: <Widget> [
                          Text(day + ', ' +date, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(blurRadius: 10.0, color: Colors.black, offset: Offset(2.0,2.0))])),
                          Text(data['location'], style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(blurRadius: 10.0, color: Colors.black, offset: Offset(2.0,2.0))])),
                          Text(DateFormat.Hm().format(toFormat), style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(blurRadius: 10.0, color: Colors.black, offset: Offset(2.0,2.0))])),
                        ]
                      )
                    ]
                  ) 
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Container(
                    height: 200,
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                        colors: [Color.fromRGBO(7,244,158,0.6), Color.fromRGBO(87,7,255,0.6)],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(color: Color.fromRGBO(7, 244, 158, 1.0), width: 1.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(data['temp'].toString().split('.')[0] + '\u00B0' + 'C', 
                                style: TextStyle(
                                fontSize: 66, color: Colors.white, fontWeight: FontWeight.bold
                              )),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Image(image: AssetImage('assets/rainperc.png'), width: 24,),
                                      SizedBox(height: 5),
                                      Text(data['rain'].toString().split('.')[0] + "%", style: TextStyle(fontSize:14, color: Colors.white))
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    children: [
                                      Image(image: AssetImage('assets/windspeed.png'), width: 24,),
                                      SizedBox(height: 5),
                                      Text(data['windspeed'].toString().split('.')[0] + "km/h", style: TextStyle(fontSize:14, color: Colors.white))
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    children: [
                                      Image(image: AssetImage('assets/humidity.png'), width: 24,),
                                      SizedBox(height: 5),
                                      Text(data['humidity'].toString().split('.')[0] + "%", style: TextStyle(fontSize:14, color: Colors.white))
                                    ],
                                  ),
                                  
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(image: AssetImage(conditionImages(data['desc'], data['isday'])), width: 123,),
                              Text(data['desc'], style: TextStyle(fontSize:24, fontWeight: FontWeight.bold, color: Colors.white))
                            ]
                          ),
                        )
                      ],
                    )
                  )
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0,5,0,5),
                  child: SizedBox(
                    height: 130,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: days.length,
                      itemBuilder: (BuildContext context, int index){
                        return Padding(
                            padding: const EdgeInsets.fromLTRB(5,0,5,0),
                            child: Container(
                              width: 65,
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(7, 244, 158, 0.6),
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                border: Border.all(color: Color.fromRGBO(7, 244, 158, 1.0), width: 1.0), 
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(DateFormat.E().format(DateTime.parse(days[index]['date'])),
                                    style: TextStyle(fontSize: 18, color: Colors.white)),
                                  Image(image: AssetImage(conditionImages(days[index]['condition'], 1))),
                                  Text(days[index]['avgtemp'].toString().split('.')[0] + '\u00B0' + 'C',
                                    style: TextStyle(fontSize: 18, color: Colors.white)),
                                ],
                              ),
                            ),
                            
                          );
                      }
                    ),
                  )
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            border: Border.all(color: Color.fromRGBO(7, 244, 158, 1.0), width: 1.0),
                            gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft,
                              colors: [Color.fromRGBO(7,244,158,0.6), Color.fromRGBO(87,7,255,0.6)],
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(sunText, style: TextStyle(color: Colors.white, fontSize:28, fontWeight: FontWeight.bold)),
                                Image(image: AssetImage(sunImage), width: 54),
                                Text(sunTime.toString().split(' ')[0], style: TextStyle(color: Colors.white, fontSize:38, fontWeight: FontWeight.bold))
                              ]
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 30),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            border: Border.all(color: Color.fromRGBO(7, 244, 158, 1.0), width: 1.0),
                            color: Color.fromRGBO(7, 244, 158, 0.6)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Image(image: AssetImage(moonPhases(data['moonphase'])), width: 50),
                                Center(child: Text(data['moonphase'], style: TextStyle(color: Colors.white, fontSize:26, fontWeight: FontWeight.bold)))
                              ]
                            )
                          )
                        ),
                      )
                    ],
                  )
                )
              ],
            )
          )
        )
      )   
    );    
  }
}