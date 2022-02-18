import 'dart:async';
import 'dart:convert';
import 'dart:developer' as debug;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/ParcelleModel.dart';
import 'package:flutter_gismo/parcelle/PaturagePage.dart';
import 'package:geolocator/geolocator.dart';

//import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:sentry/sentry.dart';

class ParcellePage extends StatefulWidget {
  final GismoBloc _bloc;
  ParcellePage( this._bloc,
      /* this.initialCameraPosition,
      this.onMapCreated,
      this.onStyleLoadedCallback,
      this.gestureRecognizers,
      this.onMapClick,
      this.onCameraTrackingDismissed,
      this.onCameraTrackingChanged,
      //this.onMapIdle,*/
      {Key ? key}) : super(key: key);
  @override
  _ParcellePageState createState() => new _ParcellePageState(_bloc);
/*
  /// The initial position of the map's camera.
  final CameraPosition initialCameraPosition;
  final MapCreatedCallback onMapCreated;
  final OnStyleLoadedCallback onStyleLoadedCallback;
  /// Called when the location tracking mode changes, such as when the user moves the map
  final OnCameraTrackingDismissedCallback onCameraTrackingDismissed;
  final OnCameraTrackingChangedCallback onCameraTrackingChanged;
  /// Which gestures should be consumed by the map.
  ///
  /// It is possible for other gesture recognizers to be competing with the map on pointer
  /// events, e.g if the map is inside a [ListView] the [ListView] will want to handle
  /// vertical drags. The map will claim gestures that are recognized by any of the
  /// recognizers on this list.
  ///
  /// When this set is empty or null, the map will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;
  final OnMapClickCallback onMapClick;
  /// Called when map view is entering an idle state, and no more drawing will
  /// be necessary until new data is loaded or there is some interaction with
  /// the map.
  /// * No camera transitions are in progress
  /// * All currently requested tiles have loaded
  /// * All fade/transition animations have completed
  //final OnMapIdleCallback onMapIdle;
*/
}

class _ParcellePageState extends State<ParcellePage> {
  final GismoBloc _bloc;
  _ParcellePageState(this._bloc);
  Line ? _selectedLine;
  List<Parcelle?> _myParcelles=[];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    /*
    Geolocator
     */
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  bool _positionStreamStarted = false;
  Position ? _lastPosition;
  LatLng ? _currentPosition;
  /*
  MapBox
   */
  MapboxMapController ? _mapController;
  MapboxMap ? _mapBox;



  void _onMapCreated(MapboxMapController controller) {
    _mapController = controller;
    debug.log("Map created" , name: "_ParcellePageState::_onMapCreated" );
    //mapController.addLine(options);
    /*
    _getLocation()
        .then( (location) => { _drawParcelles(location) })
        .catchError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar( content: Text(error)));
          // error is SecondError
          Sentry.captureException(error, stackTrace : stackTrace);
          debug.log("outer: $error", name:"_ParcellePageState::_onMapCreated");
        });
     */
  }

  void _onUserLocationUpdated(UserLocation location) {
    this._drawParcelles(location.position);
    //location.position.latitude

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Parcelles'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
      ),
      body:
      _mapBoxView()
     );
  }


   Widget _mapBoxView() {
    //MapboxMap map = new MapboxMap(initialCameraPosition: null);
    _mapBox =  MapboxMap(
      accessToken: 'pk.eyJ1IjoieGJlYXUiLCJhIjoiY2s4anVjamdwMGVsdDNucDlwZ2I0bGJwNSJ9.lc21my1ozaQZ2-EriDSY5w',
      onMapCreated: _onMapCreated,
      onMapClick: _onMapClick,
      //cameraTargetBounds: ,
      myLocationEnabled: true,
      styleString: MapboxStyles.SATELLITE,
      onUserLocationUpdated: _onUserLocationUpdated,
      initialCameraPosition: const CameraPosition(target: LatLng(45.26, 5.73), zoom: 14),
    );
    return _mapBox!;
  }

  void _drawParcelles( /*Position*/ /*LocationData*/ LatLng ? location) async {
    if (location == null)
      return;
    /*
    double distance = 0;
    if (_lastPosition != null) {
      distance = _geolocatorPlatform.distanceBetween(
          _lastPosition!.latitude, _lastPosition!.longitude, location.latitude,
          location.longitude);
      debug.log("bearing " + distance.toString());
      this._showMessage("bearing is " + distance.toString() );
    }
    */
    debug.log("" + location.toString(), name: "_ParcellePageState::_drawParcelles" );
    if (this._currentPosition != null)
      return;
    this._currentPosition = location;
    _mapController!.moveCamera(CameraUpdate.newCameraPosition(
      new CameraPosition(
        target: LatLng(location.latitude, location.longitude),
        zoom: 14.0,
      ),));
    _myParcelles =  await _bloc.getParcelles();
    //Map<String, dynamic> parcellesJson =  jsonDecode(parcelles);
    String cadastreStr = await _bloc.getCadastre(location);
    Map<String, dynamic> cadastreJson =  jsonDecode(cadastreStr);
    List<dynamic> featuresJson = cadastreJson['features'];
   featuresJson.forEach((feature) => _drawParcelle(feature));
   //_mapController.onLineTapped.add(_onLineTapped);
    OnMapClickCallback getParcelle = _onMapClick;

  }

  void _onMapClick(Point<double> pt, LatLng coord) async {
    debug.log("coord " + coord.latitude.toString() + " " + coord.longitude.toString(), name:"_ParcellePageState::_onMapClick");
    String cadastreStr = await _bloc.getParcelle(coord);
    Map<String, dynamic> parcelleJson =  jsonDecode(cadastreStr);
    if (parcelleJson['features'].length == 0)
      return;
    Map<String, dynamic> feature = parcelleJson['features'][0];
    Parcelle ? myParcelle = this._myParcelles.firstWhere((parcelle) => parcelle!.idu == feature['properties']['id'], orElse: () => null);
    if (myParcelle == null)
      return;

    debug.log("parcelle " + myParcelle.toString(), name:"_ParcellePageState::_onMapClick");
    Pature pature = await _bloc.getPature(myParcelle.idu);
    var navigationResult = Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaturagePage(this._bloc, pature),)
    );
    navigationResult.then((message) {
      if (message != null)
        _showMessage(message);
    });

  }

  void _showMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _drawParcelle(feature) {
    String lineColor = "#ffffff";
    double lineWidth = 1.0;
    Parcelle ? foundParcelle = _myParcelles.firstWhere((parcelle) => parcelle!.idu == feature['properties']['id'], orElse: () => null);
    if (foundParcelle != null) {
      lineWidth = 6.0;
      lineColor = '#58db72';
    }
    Map<String, dynamic>  geometry = feature['geometry'];
    List coordinates = geometry['coordinates'][0][0];
    List<LatLng> lstLatLng = [];
    coordinates.forEach( (anArray) => lstLatLng.add(LatLng(anArray[1], anArray[0])));
    _mapController!.addLine(LineOptions(
      geometry: lstLatLng,
      lineColor: lineColor,
      lineWidth: lineWidth,
      lineOpacity: 0.5,
    ));
  }

  void _onLineTapped(Line line) {
    if (_selectedLine != null) {
      _updateSelectedLine(
        const LineOptions(
          lineWidth: 28.0,
        ),
      );
    }
    setState(() {
      _selectedLine = line;
    });
    _updateSelectedLine(
      LineOptions(
        lineWidth: 1.0,
          // linecolor: ,
      ),
    );
  }

  void _updateSelectedLine(LineOptions changes) {
    _mapController!.updateLine(_selectedLine!, changes);
  }

  @override
  void initState() {
    super.initState();
    /*
    final positionStream = _geolocatorPlatform.getPositionStream();
    _positionStreamSubscription = positionStream.handleError((error) {
      _positionStreamSubscription?.cancel();
      _positionStreamSubscription = null;
    }).listen((position) =>
        _drawParcelles(position) );
     */
      /*_updatePositionList(
      _PositionItemType.position,
      position.toString(),
      ));*/
    //_positionStreamSubscription?.pause();
  }

  List<LatLng> _buildList(List coordinates) {
    List<LatLng> lstCoordinates = [];
    coordinates[0].forEach((coordinate) => {
      lstCoordinates.add( _build(coordinate))
    });
    return  lstCoordinates;
  }

  LatLng _build(coordinate) {
    double lat = coordinate[1];
    double lng = coordinate[0];
    return new LatLng(lat, lng);
  }

  Future<Position ?> _getLocation() async{
    /*Location Position location = new Position();

    PermissionStatus _permissionGranted;
    */
    bool _serviceEnabled;
    LocationPermission permission;
    //_serviceEnabled = await location.serviceEnabled();
    _serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      throw ("Service de localisation indeisponible");
    }
    debug.log("Service enabled " + _serviceEnabled.toString(), name:"_ParcellePageState::_getLocation");
    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        throw ("Permission de localisation refusée");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      throw ("Permission de localisation refusée");
    }
    /*
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }*/
    try {
      _lastPosition = await _geolocatorPlatform.getLastKnownPosition();
      if (_lastPosition != null)
        debug.log("Last Known Lat " + _lastPosition!.latitude.toString() + " Long " + _lastPosition!.longitude.toString() , name: "_ParcellePageState::_getLocation" );

      /*
      final position = await _geolocatorPlatform.getCurrentPosition( locationSettings:
        AndroidSettings(
          forceLocationManager: true,
      ));

      if (position != null)
        debug.log(" Lat " + position.latitude.toString() + " Long " + position.longitude.toString() , name: "_ParcellePageState::_getLocation" );
      return position;*/
    }
    catch(e, stackTrace) {
      debug.log("Execption " + e.toString(), name:"_ParcellePageState::_getLocation");
      debug.log("Stacktrace " + stackTrace.toString(), name:"_ParcellePageState::_getLocation");
    }
    return _lastPosition;
    /*
    _permissionGranted = await location.hasPermission();
    debug.log("permission Granted " + _permissionGranted.toString(), name:"_ParcellePageState::_getLocation");

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    debug.log("permission  " + _permissionGranted.toString(), name:"_ParcellePageState::_getLocation");
    return location.getLocation();*/
  }


}