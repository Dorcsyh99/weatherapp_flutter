// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_world_time_whether/services/wheather.dart';
import 'package:flutter_world_time_whether/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Loading extends StatefulWidget {
  const Loading({ Key? key }) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  

  void setupWeather() async {
    Wheather instance = Wheather(location: 'Budapest');
    await instance.getWheather();
    await instance.getAstronomy();
    await instance.getForecast();
    
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'location': instance.location,
      'temp': instance.temp,
      'rain': instance.rain,
      'desc': instance.desc,
      'windspeed': instance.windSpeed,
      'winddir': instance.windDirection,
      'humidity': instance.humidity,
      'cloudiness': instance.cloudiness,
      'uv': instance.uvi,
      'isday': instance.isDay,
      'currenttime': instance.currentTime,
      'sunset': instance.sunset,
      'sunrise': instance.sunrise,
      'moonphase': instance.moonPhase,
      'icon': instance.icon,
      'days': instance.days
    });
  }

  @override
  void initState(){
    super.initState();
    setupWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: SpinKitCubeGrid(
          color: Colors.orangeAccent,
          size: 100.0,
        ),
      ),
    );
  }
}