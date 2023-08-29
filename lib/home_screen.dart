import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  LocationData? myCurrentLocation;
  StreamSubscription? _streamSubscription;


  @override
  void initState() {
    super.initState();
    initial();
  }


  void initial(){
    Location.instance.changeSettings(
      distanceFilter: 10,
      accuracy: LocationAccuracy.high,
      interval: 50000,
    );
  }


  Future<void> getMyLocation() async {
    await Location.instance.requestPermission().then((requestPermission) async {
      print(requestPermission);

      await Location.instance.hasPermission().then((permissionStatus) async {
        print(permissionStatus);
      });
    });

    myCurrentLocation = await Location.instance.getLocation();
    print(myCurrentLocation);
    if (mounted) {
      setState(() {});
    }
  }


  void listenToMyLocation() {
        _streamSubscription = Location.instance.onLocationChanged.listen((location) {
          if(location != myCurrentLocation) {
            myCurrentLocation = location;
            print('listening to location $location');
            if (mounted) {
              setState(() {});
            }
          }
        });
  }

  void stopListenLocation(){
    _streamSubscription?.cancel();
  }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Location", style: TextStyle(
            fontSize: 25,
          ),),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("My location"),
              Text("${myCurrentLocation?.latitude ?? ""}    ${myCurrentLocation?.latitude ?? ""}"),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                listenToMyLocation();
              },
              child: const Icon(Icons.location_on),
            ),

            const SizedBox(width: 20,),

            FloatingActionButton(
              onPressed: () {
                stopListenLocation();
              },
              child: const Icon(Icons.stop_circle_outlined),
            ),

            const SizedBox(width: 20,),

            FloatingActionButton(
              onPressed: () {
                getMyLocation();
              },
              child: const Icon(Icons.my_location),
            ),

          ],
        ),
      );
    }

    @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

}



