import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:developer' as debug;

import 'package:gismo/bloc/LocationBloc.dart';
import 'package:gismo/model/ParcelleModel.dart';
import 'package:gismo/parcelle/ui/ParcellePage.dart';
import 'package:gismo/parcelle/ui/PaturagePage.dart';
import 'package:gismo/services/ParcelleService.dart';
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
    _mapboxMap.flyTo(
        CameraOptions(
          center:  Point( coordinates: Position(location.lng, location.lat,) ),
          zoom: 14), MapAnimationOptions());
    // featuresJson.forEach((feature) => _drawParcelle(feature));
    await this._drawCadastre();
    return location;
  }

  Future<void> _drawCadastre() async {
    await _mapboxMap.style.removeStyleLayer("cadastre");
    //await _mapController!.removeLayer("cadastre");
    await _mapboxMap.style.removeStyleLayer("cadastre");
    //await _mapController!.removeSource("parcelles");

    await _mapboxMap.style.removeStyleLayer("ownParcelles");
    //await _mapController!.removeLayer("ownParcelles");
    await _mapboxMap.style.removeStyleLayer("ownParcellesSrc");
    //await _mapController!.removeSource("ownParcellesSrc");

    await _mapboxMap.style.addSource( GeoJsonSource(id:"cadastreSourceId",data: json.encode(_cadastreJson)));
    LineLayer parcelleLineLayer =
      LineLayer(id: "modelLayer-cadastre", sourceId: "cadastreSourceId", lineColor: int.parse("#007AFF", radix: 16), lineWidth: 1);
    await _mapboxMap.style.addLayer(parcelleLineLayer);
    Map<String, dynamic> allParcelles = new Map();
    for (var feature in this._cadastreJson!["features"]) {
      allParcelles[ feature['properties']['id'] ] = feature;
    }

    Map<String, dynamic> ownParcellesSrc = new Map();
    ownParcellesSrc["type"] = "FeatureCollection";
    ownParcellesSrc["features"] = [];
    _myParcelles.forEach((parcelle) {
      if (allParcelles[parcelle!.idu] != null )
        _drawParcelle(allParcelles[parcelle!.idu]);
      ownParcellesSrc["features"].add(allParcelles[parcelle!.idu]);
    });
  }

  void _drawParcelle(feature) async {
    double lineWidth = 6.0;
    String lineColor = '#58db72';
    Map<String, dynamic>  geometry = feature['geometry'];
    List coordinates = geometry['coordinates'][0][0];
    List<Position> lstLatLng = [];
    coordinates.forEach( (anArray) => lstLatLng.add(Position( anArray[0],anArray[1])));
    LineLayer parcelleLineLayer =
      LineLayer(id: "modelLayer-parcelle",
          sourceId: "parcelleSourceId",
          lineColor: int.parse("#007AFF", radix: 16),
          lineWidth: 1);
    await _mapboxMap.style.addLayer(parcelleLineLayer);
    /*
    await _mapController!.addLine(LineOptions(
      geometry: lstLatLng,
      lineColor: lineColor,
      lineWidth: lineWidth,
      lineOpacity: 0.5,
    ));*/
  }

  void onMapClick(Point pt, Position coord) async {
    debug.log("coord " + coord.lat.toString() + " " + coord.lng.toString(), name:"_ParcellePageState::_onMapClick");
    String cadastreStr = await _service.getParcelle(coord);
    Map<String, dynamic> parcelleJson =  jsonDecode(cadastreStr);
    if (parcelleJson['features'].length == 0)
      return;
    Map<String, dynamic> feature = parcelleJson['features'][0];
    Parcelle ? myParcelle = this._myParcelles.firstWhere((parcelle) => parcelle.idu == feature['properties']['id'], orElse: null);
    if (myParcelle == null)
      return;

    debug.log("parcelle " + myParcelle.toString(), name:"_ParcellePageState::_onMapClick");
    Pature pature = await _service.getPature(myParcelle.idu);
    this._view.goNextPage(PaturagePage( pature));

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