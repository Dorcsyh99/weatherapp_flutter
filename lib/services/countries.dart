import 'package:flutter_world_time_whether/services/wheather.dart';

class Country{
  String? cityName;
  String? country;
  String? countryCode;
  String? stateCode;
  Wheather? wheather;

  Country({this.cityName, this.country, this.countryCode, this.stateCode = ''});


}