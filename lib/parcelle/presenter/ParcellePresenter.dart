import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:developer' as debug;
import 'dart:ui';

import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/LocationBloc.dart';
import 'package:flutter_gismo/model/ParcelleModel.dart';
import 'package:flutter_gismo/parcelle/ui/ParcellePage.dart';
import 'package:flutter_gismo/parcelle/ui/PaturagePage.dart';
import 'package:flutter_gismo/services/ParcelleService.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class ParcellePresenter {
  ParcelleContract _view;
  List<Parcelle> _myParcelles=[];
  List<dynamic> featuresJson=[];
  Map<String, dynamic> ? _cadastreJson;
  ParcelleService _service = ParcelleService();
  LocationBloc _locBloc = new LocationBloc();
  Position ? _curentPosition;
  late Stream<LocationResult> _locationStream;
  StreamSubscription<LocationResult> ? _locationSubscription;

  //late MapboxMapController _mapController;
  late MapboxMap _mapboxMap;

  set mapboxMap(MapboxMap value) {
    _mapboxMap = value;
  }

  ParcellePresenter(this._view);

  /*onStyleLoadedCallback(StyleLoadedEventData data) async {
    var data = await rootBundle
        .loadString('assets/from_crema_to_council_crest.geojson');

    await _mapboxMap?.style.addSource(GeoJsonSource(id: "line", data: data));
    await _mapboxMap?.style.addLayer(LineLayer(
        id: "line_layer",
        sourceId: "line",
        lineJoin: LineJoin.ROUND,
        lineCap: LineCap.ROUND,
        // lineColor: Colors.red.value,
        lineWidth: 6.0));
  }*/

  Future<Position ?> retrieveParcelles( Position ? location) async {
    if (location == null)
      return null;
    //this._showStatus("Recherche des parcelles");
    _myParcelles =  await _service.getParcelles();
    //this._showStatus("Recherche du cadastre");
    String cadastreStr = await _service.getCadastre(location);
    /*Map<String, dynamic>*/ _cadastreJson =  jsonDecode(cadastreStr);
    featuresJson = _cadastreJson!['features'];
    return location;
  }

  Future<Position ?>  _drawParcelles( Position ? location) async {
    if (location == null)
      return location;
    debug.log("" + location.toString(), name: "_ParcellePageState::_drawParcelles" );
    // _mapboxMap.coordinateForPixel

    /*  await _mapboxMap.flyTo(
       CameraOptions(
          center:  Point(coordinates: Position(-122.486052, 37.830348),), //Point( coordinates: Position(location.lng, location.lat,) ),
          zoom: 14), MapAnimationOptions(duration: 2000, startDelay: 0));
    // featuresJson.forEach((feature) => _drawParcelle(feature));
    var data = await rootBundle
        .loadString('assets/from_crema_to_council_crest.geojson');

    await _mapboxMap?.style.addSource(GeoJsonSource(id: "line", data: data));
    await _mapboxMap?.style.addLayer(LineLayer(
        id: "line_layer",
        sourceId: "line",
        lineJoin: LineJoin.ROUND,
        lineCap: LineCap.ROUND,
        lineColor: Colors.red.value,
        lineWidth: 6.0));

    await Future.delayed(Duration(seconds: 5));*/
    await _mapboxMap.flyTo(
        CameraOptions(
            center:  Point( coordinates: Position(location.lng, location.lat,) ),
            zoom: 14), MapAnimationOptions(duration: 2000, startDelay: 0));

    await this._drawCadastre();
    return location;
  }

  Future<void> _drawCadastre() async {
    await _mapboxMap.style.addSource(  GeoJsonSource(id:"cadastreSrc",data: json.encode(_cadastreJson)));
    LineLayer cadastreLayer =
        LineLayer(id: "cadastreLayer",
          sourceId: "cadastreSrc",
          lineColor: Colors.red.value, // int.parse("007AFF", radix: 16),
          lineJoin: LineJoin.ROUND,
          lineCap: LineCap.ROUND,
          lineWidth: 1.0);

    await _mapboxMap.style.addLayer(cadastreLayer);

    Map<String, dynamic> allParcelles = new Map();
    for (var feature in this._cadastreJson!["features"]) {
      allParcelles[ feature['properties']['id'] ] = feature;
    }

    Map<String, dynamic> ownParcellesSrc = new Map();
    ownParcellesSrc["type"] = "FeatureCollection";
    ownParcellesSrc["features"] = [];
    _myParcelles.forEach((parcelle) {
      if (allParcelles[parcelle!.idu] != null ) {
        //_drawParcelle(allParcelles[parcelle!.idu]);
        ownParcellesSrc["features"].add(allParcelles[parcelle!.idu]);
      }
    });

    await _mapboxMap.style.addSource(  GeoJsonSource(id:"parcelleSrc",data: json.encode(ownParcellesSrc)));
    LineLayer parcelleLayer =
      LineLayer(id: "parcelleLayer",
        sourceId: "parcelleSrc",
        lineColor: Colors.lightGreenAccent.value, // int.parse("007AFF", radix: 16),
        lineJoin: LineJoin.ROUND,
        lineCap: LineCap.ROUND,
        lineWidth: 4.0);
    await _mapboxMap.style.addLayer(parcelleLayer);
  }

  void _drawParcelle(Map feature) async {
    double lineWidth = 6.0;
    String lineColor = '#58db72';
    Map<String, dynamic>  geometry = feature['geometry'];
    List coordinates = geometry['coordinates'][0][0];
    List<Position> lstLatLng = [];
    coordinates.forEach( (anArray) => lstLatLng.add(Position( anArray[0],anArray[1])));
    var newFeature = Feature(
        id: feature["id"],
        geometry: LineString(coordinates:  lstLatLng /*[
          Position(-122.483696, 37.833818),
          Position(-122.4861, 37.828802),
          Position(-122.493782, 37.833683),
          Position(-122.48959, 37.8366109),
          Position(-122.483696, 37.833818)
        ]*/));
   /* await _mapboxMap.style
        .addGeoJSONSourceFeatures("line", "new_line", [newFeature]);


    await _mapController!.addLine(LineOptions(
      geometry: lstLatLng,
      lineColor: lineColor,
      lineWidth: lineWidth,
      lineOpacity: 0.5,
    ));*/
  }

  void onMapClick(MapContentGestureContext context) async {
    this._view.showStatus("Recherche des données de paturage");
    debug.log("coord $context.point.lat  $context.point.lng", name:"_ParcellePageState::_onMapClick");
    print("OnTap coordinate: {${context.point.coordinates.lng}, ${context.point.coordinates.lat}}" +
        " point: {x: ${context.touchPosition.x}, y: ${context.touchPosition.y}}" +
        " state: ${context.gestureState}");
    try {
      debug.log(
          "coord $context.point.coordinate.lat.toString() $context.point.coordinate.lng.toString()",
          name: "_ParcellePageState::_onMapClick");
      String cadastreStr = await _service.getParcelle(
          context.point.coordinates);
      Map<String, dynamic> parcelleJson = jsonDecode(cadastreStr);
      if (parcelleJson['features'].length == 0)
        return;
      Map<String, dynamic> feature = parcelleJson['features'][0];
      Parcelle ? myParcelle = this._myParcelles.firstWhere((
          parcelle) => parcelle.idu == feature['properties']['id'],
          orElse: null);
      if (myParcelle == null)
        return;

      debug.log("parcelle " + myParcelle.toString(),
          name: "_ParcellePageState::_onMapClick");
      Pature pature = await _service.getPature(myParcelle.idu);
      this._view.goNextPage(PaturagePage(pature));
    } finally {
      this._view.locationProgress=false;
    }
  }

  Future<Position ?> _retrieveParcelles( Position ? location) async {
    if (location == null)
      return null;
    //this._showStatus("Recherche des parcelles");
    _myParcelles =  await _service.getParcelles();
    //this._showStatus("Recherche du cadastre");
    String cadastreStr = await _service.getCadastre(location);
    _cadastreJson =  jsonDecode(cadastreStr);
    featuresJson = _cadastreJson!['features'];
    return location;
  }

  void _showMap(Position? location) async {
    try {
      debug.log(
          "En attente des parcelles", name: "_ParcellePageState::_showMap");
      this._view.showStatus("En attente des parcelles");
      await this._retrieveParcelles(location);
      debug.log("Affichage du cadastre", name: "_ParcellePageState::_showMap");
      this._view.showStatus("Affichage du cadastre");
      this._drawParcelles(location);
    }
    finally {
      this._view.locationProgress = false;
    }

  }

  void initLocation() async {
    this._view.showStatus("Initialisation de la localisation");
    _mapboxMap.location.updateSettings(LocationComponentSettings(enabled: true));
    this._locBloc.initLocation();
    this._locationStream = this._locBloc.streamLocation();
    this._locationSubscription = this._locationStream.listen( (LocationResult result) {
      if (result.result) {
        this._curentPosition = result.location!;
        this._locBloc.stopStream();
        this._locationSubscription!.cancel();
        this._showMap(result.location!);
      }
      else
        this._view.showStatus("En attente de coordonnées");
    });
  }
}