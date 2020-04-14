import 'dart:async';
import 'dart:convert';
import 'dart:developer' as debug;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/main.dart';

//import 'package:flutter_map/flutter_map.dart';
//import 'package:latlong/latlong.dart';
//import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:location/location.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class ParcellePage extends StatefulWidget {
  ParcellePage(/* this.initialCameraPosition,
      this.onMapCreated,
      this.onStyleLoadedCallback,
      this.gestureRecognizers,
      this.onMapClick,
      this.onCameraTrackingDismissed,
      this.onCameraTrackingChanged,
      //this.onMapIdle,*/
      {Key key}) : super(key: key);
  @override
  _ParcellePageState createState() => new _ParcellePageState();
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
  //Completer<WebViewController> _controller = Completer<WebViewController>();
  //LocationData _locationData;
  //InAppWebViewController webView;
  String url = "https://cadastre.data.gouv.fr/map?style=ortho#14.87/45.26433/5.7097";
  double progress = 0;

  String ignKey="mv1g555wk9ot6na1nux9u7go";

  Line _selectedLine;

  /*
  MapBox
   */
  MapboxMapController _mapController;
  MapboxMap _mapBox;

  void _onMapCreated(MapboxMapController controller) {
    _mapController = controller;
    var myParcelle = json.decode('{"type":"Feature","id":"383280000C0439","geometry":{"type":"Polygon","coordinates":[[[5.7352156,45.2621557],[5.7353748,45.2620889],[5.735556,45.2624896],[5.7353009,45.2624862],[5.735291,45.262439],[5.7352804,45.2623352],[5.7352703,45.2622814],[5.7352156,45.2621557]]]},"properties":{"id":"383280000C0439","commune":"38328","prefixe":"000","section":"C","numero":"439","contenance":619,"arpente":false,"created":"2003-11-26","updated":"2019-04-26"}}');
    LineOptions options = new LineOptions(lineColor: "#FAD042",
        lineWidth: 4.0,
        lineOpacity: 0.5,
        geometry: _buildList(myParcelle['geometry']['coordinates']));
    debug.log("bounds " + _mapBox.cameraTargetBounds.bounds.toString(), name:"_ParcellePageState::_onMapCreated" );
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
  }

  Widget _mapBoxView() {
    //MapboxMap map = new MapboxMap(initialCameraPosition: null);
    _mapBox =  MapboxMap(
      onMapCreated: _onMapCreated,
      //cameraTargetBounds: ,
      myLocationEnabled: true,
        styleString: MapboxStyles.SATELLITE,
        initialCameraPosition: const CameraPosition(target: LatLng(45.26, 5.73), zoom: 14),
    );
    return _mapBox;
  }

  void _drawParcelles(LocationData location) async {
    debug.log("" + location.toString(), name: "_ParcellePageState::_drawParcelles" );
    _mapController.moveCamera(CameraUpdate.newCameraPosition(
      new CameraPosition(
        target: LatLng(location.latitude, location.longitude),
        zoom: 14.0,
      ),));
    //https://api-adresse.data.gouv.fr/reverse/?lon=5.7354067&lat=45.2627
    String cadastreStr = await gismoBloc.getCadastre(location);
    Map<String, dynamic> cadastreJson =  jsonDecode(cadastreStr);
    List<dynamic> featuresJson = cadastreJson['features'];
    debug.log("Coucou " + cadastreStr);
   featuresJson.forEach((feature) => _drawParcelle(feature));
   _mapController.onLineTapped.add(_onLineTapped);
  }

  void _drawParcelle(feature) {
    Map<String, dynamic>  geometry = feature['geometry'];
    List coordinates = geometry['coordinates'][0][0];
    List<LatLng> lstLatLng = new List();
    coordinates.forEach( (anArray) => lstLatLng.add(LatLng(anArray[1], anArray[0])));
    _mapController.addLine(LineOptions(
      geometry: lstLatLng,
      lineColor: "#ffffff",
      lineWidth: 1.0,
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
    _mapController.updateLine(_selectedLine, changes);
  }

  @override
  void initState() {
  }

  List<LatLng> _buildList(List coordinates) {
    List<LatLng> lstCoordinates = new List();
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

  Future<LocationData> _getLocation() async{
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

    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return null;
      }
    }
    debug.log("permission  " + _permissionGranted.toString(), name:"_ParcellePageState::_getLocation");
    return location.getLocation();
  }


}