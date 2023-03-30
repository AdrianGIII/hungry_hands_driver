import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hungry_hands_driver/delievery-app/home_page.dart';
import '../utils.dart';
import 'Order_Information.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/alert_Dialog.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hungry_hands_driver/delievery-app/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class DeliveryHome extends StatefulWidget {
  const DeliveryHome({Key? key}) : super(key: key);

  @override
  State<DeliveryHome> createState() => _FetchDataState();
}

class _FetchDataState extends State<DeliveryHome >{
  int _selectedIndex = 0;
  final user = FirebaseAuth.instance.currentUser!;

  _showDialogOne(BuildContext context)
  {
    VoidCallback continueCallBack = () => {
      Navigator.of(context).pop(),
      // code on continue comes here

    };
    BlurryDialog  alert = BlurryDialog("Ready?","Are you currently ready to accept an order?",continueCallBack);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _LoadView(int index){
    switch(index) {
      case 0: Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage()));
      break;
      case 1: _showDialogOne(context);
      break;
      case 2: Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OrderInfromationDelivery()));

    }


  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _LoadView(_selectedIndex);
    });
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 20,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.offline_bolt, color: Colors.red), label: 'Go offline',),
          BottomNavigationBarItem(icon: Icon(Icons.back_hand_rounded, color: Colors.green),label: 'Start' ),
          BottomNavigationBarItem(icon: Icon(Icons.info, color: Colors.blue), label: 'Information',),

        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: GoogleMap(
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
    );
    double baseWidth = 430;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    /*return Container(


        child: SingleChildScrollView(

      child: Container(
        // delieveryhomevrq (1:31)
        width: double.infinity,
        height: 932*fem,
        child: Container(
          // group23Am (2:17)
          padding: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0*fem),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration (
            color: Color(0x99ff0000),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // autogroupr9kzj3b (UwaEdKdACavptfN5sSR9kZ)
                padding: EdgeInsets.fromLTRB(0*fem, 31.78*fem, 0*fem, 34.95*fem),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // drivernamect5 (1:37)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 31.78*fem),
                      child: Text(
                        user.email!,
                        style: SafeGoogleFont (
                          'Alegreya Sans',
                          fontSize: 40*ffem,
                          fontWeight: FontWeight.w900,
                          height: 0.45*ffem/fem,
                          letterSpacing: -0.0099999998*fem,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                    Container(
                      // orderinformationHUR (1:45)
                      margin: EdgeInsets.fromLTRB(22.69*fem, 0*fem, 22.69*fem, 0*fem),
                      width: double.infinity,
                      height: 186.4*fem,
                      decoration: BoxDecoration (
                        color: Color(0xffd9d9d9),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // autogroupe8qtzNq (UwaEKznhB8xqUnkDrGE8qT)
                width: double.infinity,
                height: 629.1*fem,
                child: Stack(
                  children: [
                    Positioned(
                      // taskbarJuK (1:33)
                      left: 0*fem,
                      top: 508.2309570312*fem,
                      child: Align(
                        child: SizedBox(
                          width: 430*fem,
                          height: 120.87*fem,
                          child: Container(
                            decoration: BoxDecoration (
                              border: Border.all(color: Color(0xff000000)),
                              color: Color(0xd6f08989),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // buttonNPP (1:34)
                      left: 22.6944580078*fem,
                      top: 535.8999023438*fem,
                      child: TextButton(
                        onPressed: () => {

                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage()))

                        },
                        style: TextButton.styleFrom (
                          padding: EdgeInsets.zero,
                        ),
                        child: Container(
                          width: 128.2*fem,
                          height: 66.02*fem,
                          decoration: BoxDecoration (
                            color: Color(0xddfa0b0b),
                            borderRadius: BorderRadius.circular(108*fem),
                          ),
                          child: Center(
                            child: Center(
                              child: Text(
                                'GO OFFLINE',
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont (
                                  'Alegreya Sans',
                                  fontSize: 20*ffem,
                                  fontWeight: FontWeight.w900,
                                  height: 0.9*ffem/fem,
                                  letterSpacing: -0.0099999998*fem,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // mapKbT (1:35)
                      left: 0*fem,
                      top: 0*fem,
                      child: Align(
                        child: SizedBox(
                          width: 430*fem,
                          height: 508.23*fem,
                          child: Container(
                            decoration: BoxDecoration (
                              color: Color(0xffd9d9d9),
                              borderRadius: BorderRadius.only (
                                topLeft: Radius.circular(100*fem),
                                topRight: Radius.circular(100*fem),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

        ),
          );



  }*/
}
  @override
  void initState(){
    getCurrentLocation();
    super.initState();
  }
}