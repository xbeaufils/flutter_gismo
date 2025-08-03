import 'dart:async';
import 'dart:developer' as debug;

import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/LocationBloc.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/model/ParcelleModel.dart';
import 'package:flutter_gismo/parcelle/presenter/ParcellePresenter.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';


class ParcellePage extends StatefulWidget {
  ParcellePage(  {Key ? key}) : super(key: key);
  @override
  _ParcellePageState createState() => _ParcellePageState();
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

abstract class ParcelleContract extends GismoContract {
  void showStatus(String message);
  set locationProgress(bool value);
}


class _ParcellePageState extends GismoStatePage<ParcellePage> implements ParcelleContract {

  _ParcellePageState();
  late ParcellePresenter _presenter;

  List<Parcelle?> _myParcelles=[];
  List<dynamic> featuresJson=[];
  Map<String, dynamic> ? _cadastreJson;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  LocationBloc _locBloc = new LocationBloc();
  Position ? _curentPosition;
  late Stream<LocationResult> _locationStream;
  StreamSubscription<LocationResult> ? _locationSubscription;
  bool _locationProgress = true;

  set locationProgress(bool value) {
    setState(() {
      _locationProgress = value;

    });
  }

  String _messageProgress="";

  void _onMapCreated(MapboxMap map) {
    _presenter.mapboxMap = map;
    debug.log("Map created" , name: "_ParcellePageState::_onMapCreated" );
  }


  _onStyleLoadedCallback(StyleLoadedEventData data) async {
    this._presenter.initLocation();
  }



    @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget = MapWidget(
        key: ValueKey("mapWidget"),
        styleUri: MapboxStyles.STANDARD_SATELLITE,
        cameraOptions: CameraOptions(zoom: 14, center: Point(coordinates: Position( 3.095640494315918, 45.156240837225205))),
        onTapListener:  _presenter.onMapClick,
        onStyleLoadedListener: _onStyleLoadedCallback,
        onMapCreated: this._onMapCreated);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Parcelles'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
      ),

      body:
          Stack(
            children: [
              mapWidget,
              _statusBar(),
            ],)
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

/*  Widget _mapBoxView() {
    _mapBox =  MapboxMap(
      accessToken: 'pk.eyJ1IjoieGJlYXUiLCJhIjoiY2s4anVjamdwMGVsdDNucDlwZ2I0bGJwNSJ9.lc21my1ozaQZ2-EriDSY5w',
      onMapCreated: _onMapCreated,
      onMapClick: _presenter.onMapClick,
      myLocationEnabled: true,
      styleString: MapboxStyles.SATELLITE,
      //onUserLocationUpdated: _onUserLocationUpdated,
      initialCameraPosition: const CameraPosition(target: LatLng(45.26, 5.73), zoom: 14),
      //initialCameraPosition: const CameraPosition(target: positionCamera, zoom: 14),
    );
    debug.log("Return mapBox", name: "_ParcellePageState::_mapBoxView]" );
    return _mapBox!;
  }
*/

  void showStatus(String message) {
    setState(() {
      this._locationProgress = true;
      this._messageProgress = message;
    });
  }

  @override
  void initState() {
    super.initState();
    this._presenter = ParcellePresenter(this);
    //this._presenter.initLocation();
  }
}