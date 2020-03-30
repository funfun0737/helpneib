import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class HelpNeighborPageLayout extends StatelessWidget {
  dynamic users;
  HelpNeighborPageLayout({this.users});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Container(
      child: new HelpNeighborPage(users: users),
      width: screenSize.width,
      height: screenSize.height,
    );
  }
}

class HelpNeighborPage extends StatefulWidget {
  dynamic users;
  List currentLocations = [];

  HelpNeighborPage({this.users});
  @override
  HelpNeighborPageState createState() =>
      new HelpNeighborPageState(users: users);
}

class HelpNeighborPageState extends State<HelpNeighborPage>
    with TickerProviderStateMixin {

  GoogleMapController mapController;
  dynamic users;
  var userkey;

  Firestore firestore = Firestore.instance;

  HelpNeighborPageState({this.users});

  Completer<GoogleMapController> _controller = Completer();

  Future getNbrLoc() async {
    await firestore.collection('locations').snapshots().listen((data) =>
        data.documents.forEach((locData) =>
            widget.currentLocations
                .add({
              "latitude": locData['latitude'],
              "longitude": locData['longitude'],
              "deviceid": locData['deviceid']
            }))
    );
  }

  void _add(markers, locData) {
    var markerIdVal = MarkerId(locData["deviceid"].toString());
    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerIdVal,
      position: LatLng(
        locData["latitude"],
        locData["longitude"],
      ),
      infoWindow: InfoWindow(title: markerIdVal.toString(), snippet: '*'),
      onTap: () {},
    );
    markers[markerIdVal] = marker;
  }

//  Future getMyLocation() async{
//    return await Geolocator()
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
//  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Help Neib"),
      ),
      body:
      FutureBuilder(
        future: getNbrLoc(),
        builder: (BuildContext context, snapshot) {
          Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
          widget.currentLocations.forEach((curr) {
            print(markers);
            _add(
                markers, curr); //change the location and add all neibs location
          });
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              // should be your own position
              target: LatLng(37.4219983, -122.084),
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationEnabled: true,
            markers: Set<Marker>.of(
                markers.values), //-----set all neibs location
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              child: Text("Help Me!"),
              onPressed: () async {
                await Navigator.of(context).pushNamed('/m');
              },
            ),
            FlatButton(
              child: Text("Help Neighbor!"),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}