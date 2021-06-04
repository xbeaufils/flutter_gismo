import 'dart:async';
import 'dart:convert';
import 'dart:developer' as debug;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/ParcelleModel.dart';
import 'package:flutter_gismo/parcelle/PaturagePage.dart';

import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

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
  MapBox
   */
  MapboxMapController ? _mapController;
  MapboxMap ? _mapBox;

  void _onMapCreated(MapboxMapController controller) {
    _mapController = controller;
     //mapController.addLine(options);
    _getLocation().then( (location) => { _drawParcelles(location) })
        .catchError((error, stackTrace) {
        // error is SecondError
        debug.log("outer: $error", name:"_ParcellePageState::_onMapCreated");
        }   );

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
      //_InAppWebView()
      //_mapBoxView()
    );
  }
/*
  Widget _leaflet() {
    return new FlutterMap(
      options: new MapOptions(
        center: new LatLng(45.2618, 5.7348),
        zoom: 13.0,
      ),
      layers: [
        new TileLayerOptions(
          urlTemplate: //"https://api.tiles.mapbox.com/v4/"
              //"{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
            //"https://wxs.ign.fr/{ignKey}/geoportail/wmts",
            "https://wxs.ign.fr/{ignKey}/geoportail/wmts?"
            "service=WMTS"
            "&request=GetTile"
            "&version=1.0.0"
                "&layer=CADASTRALPARCELS.PARCELS"
                "&style=bdparcellaire_o"
                "&tilematrixSet=PM"
                "&format=image/png"
                "&height=256"
                "&width=256"
                "&tilematrix=16"
                "&tilerow=23508"
                "&tilecol=33815",
        additionalOptions: {
           'ignKey': 'mv1g555wk9ot6na1nux9u7go',
          'debug': 'true',
            'layer': 'ORTHOIMAGERY.ORTHOPHOTOS',
          },
        ),
        new MarkerLayerOptions(
          markers: [
            new Marker(
              width: 80.0,
              height: 80.0,
              point: new LatLng(45.2618, 5.7348),
              builder: (ctx) =>
              new Container(
                child: new FlutterLogo(),
              ),
            ),
          ],
        ),
      ],
    );
  }

 */

  Widget _webView() {
    /*
    new FutureBuilder(
        future: _getLocation(),
        builder:  (BuildContext context, AsyncSnapshot<LocationData> snapshot) {
          if (! snapshot.hasData)
            return Container();
          LocationData loc = snapshot.data;
          String url = "https://cadastre.data.gouv.fr/map?style=ortho#15/" +loc.latitude.toString() + "/"+loc.longitude.toString();
          debug.log("Location " + url);
          return WebView(
            debuggingEnabled: true,
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: url,
            onWebViewCreated: (WebViewController webViewController) {
              //_controller.complete(webViewController);
            },
          );
        }
      //floatingActionButton: _bookmarkButton(),
    );

     */
    return Container();
  }

  Widget _InAppWebView() { /*
    return Container(child:
          Column(children: <Widget>[
            Expanded(
              child: InAppWebView(
              initialUrl: "https://cadastre.data.gouv.fr/map?style=ortho#14.87/45.26433/5.7097",
              initialHeaders: {},
              initialOptions: InAppWebViewWidgetOptions(
                inAppWebViewOptions:
                   InAppWebViewOptions(
                      javaScriptEnabled: true,
                      debuggingEnabled: true,
                  )
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
              },
              onLoadStart: (InAppWebViewController controller, String url) {
                setState(() {
                  this.url = url;
                });
              },
              onLoadStop: (InAppWebViewController controller, String url) async {
                setState(() {
                  this.url = url;
                });
              },
              onProgressChanged: (InAppWebViewController controller, int progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
            ))
        ],)
    );
    */
    return Container();
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
        initialCameraPosition: const CameraPosition(target: LatLng(45.26, 5.73), zoom: 14),
    );
    return _mapBox!;
  }

  void _drawParcelles(LocationData ? location) async {
    if (location == null)
      return;
    debug.log("" + location.toString(), name: "_ParcellePageState::_drawParcelles" );
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
    _mapController!.updateLine(_selectedLine, changes);
  }

  @override
  void initState() {
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

  Future<LocationData?> _getLocation() async{
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    debug.log("Service enabled " + _serviceEnabled.toString(), name:"_ParcellePageState::_getLocation");
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    debug.log("permission Granted " + _permissionGranted.toString(), name:"_ParcellePageState::_getLocation");

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    debug.log("permission  " + _permissionGranted.toString(), name:"_ParcellePageState::_getLocation");
    return location.getLocation();
  }


}