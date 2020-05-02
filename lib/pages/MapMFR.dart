import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapMFR extends StatefulWidget {
  String _StudentContact = '';
  GeoPoint _locationOfEmergency;
  MapMFR(GeoPoint locationOfEmergency, String patientContactNo): super(){
    _StudentContact = patientContactNo;
    _locationOfEmergency = locationOfEmergency;
  }

  @override
  MapState createState() => new MapState(_locationOfEmergency, _StudentContact);
}

class MapState extends State<MapMFR> {
  GeoPoint _locationOfEmergency;
  String contactNumber = '';
  Map<MarkerId, Marker> emergencyMarker = <MarkerId, Marker>{};

  MapState(GeoPoint location, String number){
    _locationOfEmergency = location;
    contactNumber = number;
    var markerIdVal = emergencyMarker.length + 1;
    String mar = markerIdVal.toString();
    final MarkerId markerId = MarkerId(mar);
    final Marker marker =
    Marker(
        markerId: markerId,
        position: LatLng(location.latitude, location.longitude),
        infoWindow: InfoWindow( title: contactNumber)
    );
    setState(() {
      emergencyMarker[markerId] = marker;
    });




  }

  GoogleMapController _controller;
  static var Zoom = 11.0;
  static const LatLng _loc = const LatLng(45.531563, -122.677433);
  LatLng currLoc = _loc;
  LatLng _lastMapPosition = _loc;
  MapType _currentMapType = MapType.normal;
  static Location _locationTracker = Location();
  Marker marker;
  StreamSubscription _locationSubscription;

  _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  static final CameraPosition initialisation = CameraPosition(
    target: LatLng(45.531563, -122.677433),
    zoom: Zoom,
  );

  void updateMarker(LocationData newLocation) {
    LatLng values = LatLng(newLocation.latitude, newLocation.longitude);
    this.setState(() {
      marker = Marker(
        markerId: MarkerId("Your location"),
        infoWindow: InfoWindow(
          title: 'Your location',
        ),
        position: values,
        rotation: newLocation.heading,
        draggable: false,
        zIndex: 2,
        flat: false,
        anchor: Offset(0, 0),
      );
    });
  }

  void zoomIn() async {
    _controller.animateCamera(
      CameraUpdate.zoomIn(),
    );
  }

  void zoomOut() async {
    _controller.animateCamera(
      CameraUpdate.zoomOut(),
    );
  }

  void getCurrentLocaion() async {
    try {
      var location = await _locationTracker.getLocation();

      updateMarker(location);
      currLoc = LatLng(location.latitude, location.longitude);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged().listen((newLocation) {
        if (_controller != null) {
          currLoc = LatLng(newLocation.latitude, newLocation.longitude);

          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192,
                  target: LatLng(newLocation.latitude, newLocation.longitude),
                  tilt: 0,
                  zoom: Zoom)));
          updateMarker(newLocation);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    return MaterialApp(

      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff142850),
          title: Text(
            'Map',
            style: TextStyle(
              fontFamily: 'HelveticaNeueLight',
              letterSpacing: 2.0,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: initialisation,
              mapType: _currentMapType,
              markers:  Set<Marker>.of(emergencyMarker.values),
              onCameraMove: _onCameraMove,
            ),
//              Padding(
//                  padding: EdgeInsets.fromLTRB(width*0.1, height*0.1, width*0.1, 10.0),
//                  child: Text(
//                    'Student Number: ',
//                    style: TextStyle(
//                      fontFamily: 'HelveticaNeueLight',
//                      letterSpacing: 2.0,
//                      fontSize: 0.014*(height+width),
//                    ),
//                  )
//              ),
            Padding(
                padding: EdgeInsets.fromLTRB(
                    width * 0.23, height * 0.75, width * 0.16, 10.0),
                child: SizedBox(
                    width: (width + height) * 0.20,
                    height: (width + height) * 0.04,
                    child: RaisedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "Are you sure?",
                                    style: TextStyle(
                                      fontFamily: 'HelveticaNeueLight',
                                      letterSpacing: 2.0,
                                      fontSize: 20,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        'YES',
                                        style: TextStyle(
                                          fontFamily: 'HelveticaNeueLight',
                                          letterSpacing: 3.0,
                                          fontSize: 20,
                                          color: const Color(0xff1a832a),
                                        ),
                                      ),
                                      onPressed: () async {

                                        Navigator.pushReplacementNamed(
                                            context, '/MFR_home');
                                        Navigator.of(context).pop();
//                                        todo: occupied status change
                                      },
                                    ),
                                    FlatButton(
                                      child: Text(
                                        'NO',
                                        style: TextStyle(
                                          fontFamily: 'HelveticaNeueLight',
                                          letterSpacing: 2.5,
                                          fontSize: 20,
                                          color: const Color(0xffee0000),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        textColor: Colors.cyan[500],
                        color: Colors.white,
                        // todo: update occupied status
                        child: Text(
                          'End Emergency',
                          style: TextStyle(
                            color: Colors.cyan[500],
                            fontSize: (width + height) * 0.012,
                            letterSpacing: 3.0,
                            fontFamily: 'HelveticaNeueBold',
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )))),
          ],
        ),
        floatingActionButton: Column(children: <Widget>[
          SizedBox(height: height * 0.16),
          FloatingActionButton(
            child: Icon(Icons.map),
            onPressed: () {
              _onMapTypeButtonPressed();
            },
          ),
          SizedBox(height: height / 3),
          FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              zoomIn();
            },
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            child: Icon(Icons.remove),
            onPressed: () {
              zoomOut();
            },
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            child: Icon(Icons.location_searching),
            onPressed: () {
              getCurrentLocaion();
            },
          ),
        ]),
      ),
    );
  }
}