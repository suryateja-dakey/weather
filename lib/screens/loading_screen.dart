// ignore_for_file: avoid_print, unused_local_variable, prefer_const_constructors, sort_child_properties_last

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'WheatherModelClass.dart';
import 'package:http/http.dart';

var c;
final TextEditingController city = TextEditingController();

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late Future<WhetherModelClass> futureAlbum;

  var lats = 0.0;
  var lons = 0.0;
  var ds;
  var i;
  var c;
  var cities = "city name";
  var country = "country name";
  var temp = '0';
  var temps;
  var wid = 50.0;
  var pri = "🌍";
  var sunset = "";
  var des = "Description";
  var q = Color.fromARGB(255, 255, 255, 255);
  var iq = Color.fromARGB(255, 119, 75, 177);
  var tf = "city name ";
  String imageName = "images/normal1.gif";
  late LocationData loc;
  var ani="images/coolm1.gif";

// TO GET CURRENT LOCATION CORRDINATES
  void getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    var lat = locationData.latitude;
    var lon = locationData.longitude;

    print(locationData);
    print("--------Location--------");
    print('Current Location Latitude  : $lat');
    print('Current Location Longitude : $lon');
  }

// SELECTED CITY LOCATION
  void di() async {
    // Clean up the controller when the widget is disposed.
    //city.dispose();
    // super.dispose();
    c = city.text;

    var urls = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$c&appid=3ea270a45569dc5182c8df1bf5b60b27');
    print("-----City Location Deatails-----");
    Response response = await get(urls);
    print(response.statusCode);
    print(response.body);
    WhetherModelClass.fromJson(jsonDecode(response.body));
    var res = response.body;

    //Response response = await get(ur);
    // var dd = jsonDecode(res);
    WhetherModelClass dd = WhetherModelClass.fromJson(jsonDecode(res));
    //cities=dd["name"];
    setState(() {
      country = dd.sys!.country!;
      //dd["sys"]["country"];
      temps = dd.main!.temp!;
      //dd["main"]["temp"];
      sunset = dd.sys!.sunset.toString();
      //dd["sys"]["sunset"].toString();
      des = dd.weather![0].description!;
      //dd["weather"][0]["description"];

      //converting k to c
      temp = (temps - 273.15).toStringAsFixed(2);

      if (double.parse(temp.toString()) < 13) {
        imageName = 'images/snow1.gif';
        ani='images/frezm1.gif';
        pri = '🥶 ';
      } else if (double.parse(temp.toString()) >= 14 &&
          double.parse(temp.toString()) < 18) {
        imageName = 'images/rain1.gif';
        ani='images/raing1.gif';
        pri = '🌧';
      } else if (double.parse(temp.toString()) >= 18 &&
          double.parse(temp.toString()) < 30) {
        imageName = 'images/normal1.gif';
        ani='images/coolm1.gif';
        pri = '⛅️';
      } else {
        imageName = 'images/sun1.gif';
        pri = '🌞';
        ani='images/summerm1.gif';
      }
    });
    i = temp;
    print(cities);
    print(country);
    print(temp);
    print(sunset);
  }

// FOR CURRENT LOCATION
  void getDatas() async {
    Location location = new Location();
    loc = await location.getLocation();
    var lats = loc.latitude;
    var lons = loc.longitude;
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lats&lon=$lons&appid=3ea270a45569dc5182c8df1bf5b60b27');
    Response response = await get(url);
    print("-----Current Location Details-----");
    print("$lats");
    print("$lons");
    print(response.body);
    var dat = response.body;
    var res = response.body;
    var dd = jsonDecode(res);

    setState(() {
      cities = dd["name"];
      country = dd["sys"]["country"];
      temps = dd["main"]["temp"];
      temp = (temps - 273.15).toStringAsFixed(2);
      sunset = dd["sys"]["sunset"].toString();
      des = dd["weather"][0]["description"];
      tf = cities;

      if (double.parse(temp.toString()) < 13) {
        imageName = 'images/snow1.gif';
        ani='images/frezm1.gif';
        pri = '🥶 ';
      } else if (double.parse(temp.toString()) >= 14 &&
          double.parse(temp.toString()) < 18) {
        imageName = 'images/rain1.gif';
        ani='images/raing1.gif';
        pri = '🌧';
      } else if (double.parse(temp.toString()) >= 18 &&
          double.parse(temp.toString()) < 30) {
        imageName = 'images/normal1.gif';
        ani='images/coolm1.gif';
        pri = '⛅️';
      } else {
        imageName = 'images/sun1.gif';
        pri = '🌞';
        ani='images/summerm1.gif';
      }
    });
    i = temp;
    //var dec=jsonDecode(dat);
    // var sta= jsonDecode(dat)['weather'][0]['icon'];
    // var sa= jsonDecode(dat)["weather"][0]["main"];
    // print(sta);
    // print(sa);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 9, 10),
        title: Text("Weather"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageName),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 19,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        cities = value;
                      });
                    },
                    controller: city,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: tf,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          di();
                        },
                      ),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          city.clear();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),


            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/cbg.jpeg"),
                      fit: BoxFit.cover,
                      opacity: 70.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 19,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: wid,
                          ),
                          const Icon(
                            Icons.location_city_rounded,
                            color: Color.fromARGB(255, 112, 207, 57),
                            size: 35,
                          ),
                          Text(
                            "  CITY :   $cities",
                            style: TextStyle(fontSize: 19, color: q),
                          ),
                           IconButton(
                            icon: Icon(Icons.my_location_rounded),
                            iconSize: 40,
                            color: Color.fromARGB(255, 40, 127, 241),
                            tooltip: 'TAP TO GET CURRENT LOCATION',
                  
                            onPressed: () {
                              //Get the current location
                              //getLocation();
                              getDatas();
                              city.clear();
                            //  imageName = "images/snow1.gif";
                             // ani='images/freezm1.gif';
                              pri = '🥶 ';
                            
                  
                            },
                            // child: const Icon( Icons.my_location,color:Color.fromARGB(255, 0, 0, 0),size: 35,),
                            // Text('+',style: TextStyle(fontSize: 18,color:Colors.white ),),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 19,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: wid,
                          ),
                          const Icon(
                            Icons.flight_sharp,
                            color: Color.fromARGB(255, 119, 75, 177),
                            size: 35,
                          ),
                          Text(
                            "  COUNTRY :   $country",
                            style: TextStyle(fontSize: 19, color: q),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 19,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: wid,
                          ),
                          const Icon(
                            Icons.thermostat_rounded,
                            color: Color.fromARGB(255, 226, 32, 32),
                            size: 35,
                          ),
                          Text(
                            "  CURRENT TEMP :   $temp°C",
                            style: TextStyle(fontSize: 19, color: q),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 19,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: wid,
                          ),
                          //  const Icon( Icons.cloud,size: 35,color:Color.fromARGB(255, 255, 255, 255)),
                          Text(
                            "$pri",
                            style: TextStyle(fontSize: 23, color: q),
                          ),

                          Text(
                            "  WEATHER :   $des",
                            style: TextStyle(fontSize: 19, color: q),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 09,
                      ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Text(
                            "   $temp",
                            style: TextStyle(fontSize: 75, color: q),
                          ),
                          Text(
                            "°C",
                            style: TextStyle(fontSize: 30, color: q),
                          ),
                          Text(
                            "$pri",
                            style: TextStyle(fontSize: 50, color: q),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Flexible(
              child: Column(
                children: [
                  // Flexible(
                  //   child: SizedBox(
                  //     width: 30,
                  //   ),

                  // ),
                   Flexible(child: Image.asset(ani,width: 750,height:1000 ,)),
          
                  // Flexible(
                  //   child: Row(
                  //     children: [
                  //        Flexible(
                  //          child: SizedBox(
                  //             width:350 ,
                  //           ),
                  //        ),
                  //        Text("Tap to get current location weather",style: TextStyle( ),),
                  //       Flexible(
                         
                  // //Current location button
                  //         child: IconButton(
                  //           icon: Icon(Icons.my_location_rounded),
                  //           iconSize: 50,
                  //           color: Color.fromARGB(255, 40, 127, 241),
                  //           tooltip: 'TAP TO GET CURRENT LOCATION',
                  
                  //           onPressed: () {
                  //             //Get the current location
                  //             //getLocation();
                  //             getDatas();
                  //             city.clear();
                  //             imageName = "images/snow1.gif";
                  //             pri = '🥶 ';
                            
                  
                  //           },
                  //           // child: const Icon( Icons.my_location,color:Color.fromARGB(255, 0, 0, 0),size: 35,),
                  //           // Text('+',style: TextStyle(fontSize: 18,color:Colors.white ),),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            // const Icon( Icons.thermostat_rounded,color:Color.fromARGB(255, 226, 32, 32),size: 35,),
          ],
        ),
      ),
    );
  }
}
