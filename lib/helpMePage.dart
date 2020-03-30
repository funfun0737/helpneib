import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:device_id/device_id.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HelpMePageLayout extends StatelessWidget {
  dynamic users;
  HelpMePageLayout({this.users});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Container(
      child: new HelpMePage(users: users),
      width: screenSize.width,
      height: screenSize.height,
    );
  }
}

class HelpMePage extends StatefulWidget {
  dynamic users;
  HelpMePage({this.users});
  @override
  HelpMePageState createState() => new HelpMePageState(users: users);
}

class HelpMePageState extends State<HelpMePage> with TickerProviderStateMixin {
  dynamic users;
  var userkey;

  HelpMePageState({this.users});

  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  void getMyLocation() async {
    String device_id = await DeviceId.getID;
    var markerIdVal = MarkerId(device_id);
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    firestore.collection('locations').add({
      'latitude': currentLocation.latitude,
      'longitude': currentLocation.longitude,
      'deviceid': device_id
    });

    setState(() {
      markers.clear();
      final marker = Marker(
        markerId: markerIdVal,
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
      );
      markers[markerIdVal] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Help Neib"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new IconButton(
                icon: new Icon(Icons.error),
                color: Colors.red,
                onPressed: getMyLocation,
                iconSize: 100),

            new Text("BroadCast My Location")
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              child: Text("Help Me!"),
              onPressed: () {},
            ),
            FlatButton(
              child: Text("Help Neighbor!"),
              onPressed: () async {
                await Navigator.of(context).pushNamed('/n');
              },
            ),
          ],
        ),
      ),
    );
  }
}
