import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hungry_hands_driver/components/my_button.dart';
import 'package:hungry_hands_driver/components/my_textfield.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hungry_hands_driver/delievery-app/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../utils.dart';
import 'delievery_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _FetchDataState();
}

class _FetchDataState extends State<HomePage>{
  int _selectedIndex = 0;
  final user = FirebaseAuth.instance.currentUser!;



  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }


  void _goOnline(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>DeliveryHome()));
  }

  final Completer<GoogleMapController> _controller = Completer();
  //Creating Google Map Controller

  static const CameraPosition _csun = CameraPosition(
    target: LatLng(34.240161, -118.529638),
    zoom: 16.5,
  );
  //Camera object centered at CSUN

  //List of coordinates needed to make a route.

  Position? currentLocation;
  //Object CurrentLocation

  //end of variables


  //These functions are not unused in this vertion
  void getCurrentLocation() async {
    currentLocation = await Geolocator.getCurrentPosition();
    //set global variable to location's position
    setState(() {});
  }

  void liveLocation(){
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      // the accuracy of the geolocatior
      distanceFilter: 5,
      //the distance that a position must change before it is updated
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
    //Stream the device's position using the settings we just created.
        .listen((Position position){
      //listen for the device's position
      currentLocation = position;
      //set global variable to location's position
      setState(() {});
    });
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
          child: Text(
        "LOGGED IN AS: " + user.email!,
        style: TextStyle(fontSize: 20),
      )),
    );
  } */



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:  Center(
            child: Text(
              user.email!,
              style: TextStyle(color: Colors.black),
            )
        ),
        leading: GestureDetector(
          onTap: (signUserOut),
          child: Icon(Icons.arrow_back_sharp, color: Colors.black,),
        ),
      ),

      bottomNavigationBar: Container(
            height: 60,
    color: Colors.white,
    child: InkWell(
      onTap: _goOnline,
    child: Padding(
    padding: EdgeInsets.only(top: 8.0),
    child: Column(
    children: <Widget>[
    Icon(
    Icons.online_prediction,
    color: Colors.green,
      size:30,
    ),
    Text('Go Online'),
    ],
    ),
      ),
    )
    ),
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            height: 500.0,
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)
                  ),
                ),
                child: new Center(
                  child: GoogleMap(
                    mapType: MapType.hybrid, //normal Or hybrid
                    initialCameraPosition: _csun,
                    markers: {
                      const Marker(
                        markerId: MarkerId("Oviatt Library"),
                        position: LatLng(34.240161,-118.529638),
                      ),
                      Marker (
                        markerId:  const MarkerId("currentLocation"),
                        position: LatLng(currentLocation!.latitude, currentLocation!.longitude),

                      ),
                      const Marker(
                        markerId: MarkerId("Student Store"),
                        position: LatLng(34.237378,-118.528172),
                      ),
                      const Marker(
                        markerId: MarkerId("Sierra Center"),
                        position: LatLng(34.238943,-118.531143),
                      ),
                      const Marker(
                        markerId: MarkerId("Student Recreation Center"),
                        position: LatLng(34.239877,-118.524921),
                      ),
                      const Marker(
                        markerId: MarkerId("The Soraya"),
                        position: LatLng(34.236073,-118.52812),
                      ),
                      const Marker(
                        markerId: MarkerId("Arbor Grill"),
                        position: LatLng(34.241542,-118.529613),
                      ),
                      const Marker(
                        markerId: MarkerId("mark"),
                        position: LatLng(34.240161,-118.529638),
                      )
                    },
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      liveLocation();
                    },
                  ),
                )),
          ),

        ],
      ),
      ),



    );
  }
  @override
  void initState(){
    getCurrentLocation();
    super.initState();
  }
}
