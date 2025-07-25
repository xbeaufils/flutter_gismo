import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:developer' as debug;

import 'package:flutter_gismo/bloc/LocationBloc.dart';
import 'package:flutter_gismo/model/ParcelleModel.dart';
import 'package:flutter_gismo/parcelle/ui/ParcellePage.dart';
import 'package:flutter_gismo/parcelle/ui/PaturagePage.dart';
import 'package:flutter_gismo/services/ParcelleService.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class ParcellePresenter {
  ParcelleContract _view;
  List<Parcelle> _myParcelles=[];
  List<dynamic> featuresJson=[];
  Map<String, dynamic> ? _cadastreJson;
  ParcelleService _service = ParcelleService();
  LocationBloc _locBloc = new LocationBloc();
  LatLng ? _curentPosition;
  late Stream<LocationResult> _locationStream;
  StreamSubscription<LocationResult> ? _locationSubscription;

  late MapboxMapController _mapController;

  set mapController(MapboxMapController value) {
    _mapController = value;
  }

  ParcellePresenter(this._view);


  Future<LatLng ?> retrieveParcelles( LatLng ? location) async {
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

  Future<LatLng ?>  _drawParcelles( LatLng ? location) async {
    if (location == null)
      return location;
    debug.log("" + location.toString(), name: "_ParcellePageState::_drawParcelles" );
    _mapController!.moveCamera(CameraUpdate.newCameraPosition(
      new CameraPosition(
        target: LatLng(location.latitude, location.longitude),
        zoom: 14,
      ),));
    // featuresJson.forEach((feature) => _drawParcelle(feature));
    await this._drawCadastre();
    return location;
  }

  Future<void> _drawCadastre() async {
    await _mapController!.removeLayer("cadastre");
    await _mapController!.removeSource("parcelles");

    await _mapController!.removeLayer("ownParcelles");
    await _mapController!.removeSource("ownParcellesSrc");

    await _mapController!.addSource("parcelles", GeojsonSourceProperties(data: this._cadastreJson));
    await _mapController!.addLineLayer(
      "parcelles",
      "cadastre",
      const LineLayerProperties(
        lineColor: '#007AFF',
        lineWidth: 1,
      ),
    );
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
    List<LatLng> lstLatLng = [];
    coordinates.forEach( (anArray) => lstLatLng.add(LatLng(anArray[1], anArray[0])));
    await _mapController!.addLine(LineOptions(
      geometry: lstLatLng,
      lineColor: lineColor,
      lineWidth: lineWidth,
      lineOpacity: 0.5,
    ));
  }

  void onMapClick(Point<double> pt, LatLng coord) async {
    debug.log("coord " + coord.latitude.toString() + " " + coord.longitude.toString(), name:"_ParcellePageState::_onMapClick");
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

  Future<LatLng ?> _retrieveParcelles( LatLng ? location) async {
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

  void _showMap(LatLng? location) async {
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