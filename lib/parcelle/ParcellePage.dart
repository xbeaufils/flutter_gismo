import 'dart:async';
import 'dart:convert';
import 'dart:developer' as debug;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/bloc/LocationBloc.dart';
import 'package:flutter_gismo/model/ParcelleModel.dart';
import 'package:flutter_gismo/parcelle/PaturagePage.dart';

import 'package:mapbox_gl/mapbox_gl.dart';

class ParcellePage extends StatefulWidget {
  final GismoBloc _bloc;
  ParcellePage( this._bloc, {Key ? key}) : super(key: key);
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

  List<Parcelle?> _myParcelles=[];
  List<dynamic> featuresJson=[];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  /*
  MapBox
   */
  MapboxMapController ? _mapController;
  MapboxMap ? _mapBox;

  LocationBloc _locBloc = new LocationBloc();
  LatLng ? _curentPosition;
  late Stream<LocationResult> _locationStream;
  StreamSubscription<LocationResult> ? _locationSubscription;
  bool _locationProgress = true;
  String _messageProgress="";

  void _onMapCreated(MapboxMapController controller) {
    _mapController = controller;
    //this._initLocation();
    this._drawParcelles(this._curentPosition);
    debug.log("Map created" , name: "_ParcellePageState::_onMapCreated" );
  }

  void _onUserLocationUpdated(UserLocation location) {
    this._drawParcelles(location.position);
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
          Stack(
            children: [
              _mapBoxView(),
              _statusBar(),
            ],)
      //(_locationProgress)?_statusBar(): _mapBoxView()
        /*
        Row(children: [
          _mapBoxView(),
          _statusBar()],)
         */
     );
  }

  Widget _statusBar() {
    if (this._locationProgress)
    return Align(
        alignment: Alignment.center,
        child:
         Container(
           margin: const EdgeInsets.all(4),
           padding: const EdgeInsets.all(8.0),
           color: Colors.white,
           child:
          Row(
            children: [
              (this._locationProgress)? Expanded(child: Text(this._messageProgress)):Container() ,
              (this._locationProgress)? CircularProgressIndicator():Container() ,
          ],)
    ));
    else
      return Container();
  }

  Widget _mapBoxView() {
    _mapBox =  MapboxMap(
      accessToken: 'pk.eyJ1IjoieGJlYXUiLCJhIjoiY2s4anVjamdwMGVsdDNucDlwZ2I0bGJwNSJ9.lc21my1ozaQZ2-EriDSY5w',
      onMapCreated: _onMapCreated,
      onMapClick: _onMapClick,
      myLocationEnabled: true,
      styleString: MapboxStyles.SATELLITE,
      //onUserLocationUpdated: _onUserLocationUpdated,
      initialCameraPosition: const CameraPosition(target: LatLng(45.26, 5.73), zoom: 14),
      //initialCameraPosition: const CameraPosition(target: positionCamera, zoom: 14),
    );
    debug.log("Return mapBox", name: "_ParcellePageState::_mapBoxView]" );
    return _mapBox!;
  }

  Future<LatLng ?> _retrieveParcelles( LatLng ? location) async {
    if (location == null)
      return null;
    //this._showStatus("Recherche des parcelles");
    _myParcelles =  await _bloc.getParcelles();
    //this._showStatus("Recherche du cadastre");
    String cadastreStr = await _bloc.getCadastre(location);
    Map<String, dynamic> cadastreJson =  jsonDecode(cadastreStr);
    featuresJson = cadastreJson['features'];
    return location;
  }

  Future<LatLng ?>  _drawParcelles( LatLng ? location) async {
    if (location == null)
      return location;
    debug.log("" + location.toString(), name: "_ParcellePageState::_drawParcelles" );
    _mapController!.moveCamera(CameraUpdate.newCameraPosition(
      new CameraPosition(
        target: LatLng(location.latitude, location.longitude),
        zoom: 14.0,
      ),));
    featuresJson.forEach((feature) => _drawParcelle(feature));
    return location;
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

  void _showStatus(String message) {
    setState(() {
      this._locationProgress = true;
      this._messageProgress = message;
    });
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

  void _showMap(LatLng location) async {
    debug.log("En attente des parcelles", name: "_ParcellePageState::_showMap");
    this._showStatus("En attente des parcelles");
    await this._retrieveParcelles(location);
    debug.log("Affichage du cadastre", name: "_ParcellePageState::_showMap");
    this._showStatus("Affichage du cadastre");
    await this._drawParcelles(location);
    setState(() {
      this._locationProgress = false;
    });
  }

  @override
  void initState() {
    super.initState();
    this._initLocation();
  }

  void _initLocation() async {
    this._showStatus("Initialisation de la localisation");
    this._locBloc.initLocation();
    this._locationStream = this._locBloc.streamLocation();
    this._locationSubscription = this._locationStream.listen( (LocationResult result) {
      if (result.result) {
        this._curentPosition = result.location!;
        this._locBloc.stopStream();
        this._locationSubscription!.cancel();
        this._showMap(result.location!);
        /*
        this._showStatus("En attente des parcelles");
        this._retrieveParcelles(result.location).then((location)=> {
          this._drawParcelles(location)
        });
        this._curentPosition = result.location;
        this._locBloc.stopStream();
        this._locationSubscription!.cancel();
         */
      }
      else
        this._showStatus("En attente de coordonnées");
    });
  }
}