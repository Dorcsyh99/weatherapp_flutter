// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({ Key? key }) : super(key: key);

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {

  List<String> cities = ['Budapest', 'London', 'New York', 'Peking', 'Rio de Janeiro', 'Sydney'];
  String? currentCity;

  void changeCurrentCity(String newCity){
    currentCity = newCity;
    print(currentCity);
    Navigator.pop(context, {"currentcity": currentCity});
  }
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    currentCity = data['city'];

    BoxDecoration currentCityDecor = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      color: Color.fromRGBO(7, 244, 158, 1.0),
    );
    BoxDecoration otherCityDecor = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      border: Border.all(color: Color.fromRGBO(7,144,158,1.0)),
      color: Colors.transparent,
    );

    Color currentCityText = Colors.black87;
    Color otherCityText = Colors.white;
    

    return Scaffold(
      backgroundColor: Color.fromRGBO(87, 7, 255, 1.0),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, 50, 10, 20),
        child: Column(
          children: [
            Center(child: Text('Choose location', style: TextStyle(fontSize: 34, color: Colors.white, fontWeight: FontWeight.bold))),
            SizedBox(
              height: 600,              
              child: ListView.builder(
                itemCount: cities.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index){
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: (){
                        changeCurrentCity(cities[index]);
                      },
                      child: Container(
                        padding: EdgeInsets.all(25),
                        decoration: cities[index] == currentCity ? currentCityDecor : otherCityDecor,
                        child: Text(cities[index], style: TextStyle(color: cities[index] == currentCity ? currentCityText : otherCityText, fontSize: 26, fontWeight: FontWeight.w600),)
                      ),
                    ),
                  );
                },
              )
            ),
            SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.all(10),
              child: OutlinedButton(
                onPressed: (){},
                child: Row(children: [
                  Text("Add location"),
                ],)
              ),
            ),
              
            ],)
        )
    );
  }
}