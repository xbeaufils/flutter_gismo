import 'dart:convert';

import 'package:flutter_gismo/model/ParcelleModel.dart';
import 'package:flutter_gismo/repository/ParcelleRepository.dart';
import 'package:flutter_gismo/services/AuthService.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class ParcelleService {
  late ParcelleRepository _repository;

  ParcelleService() {
    _repository = WebParcelleRepository(AuthService().token);
  }

  Future<String> getCadastre(Position /*Position*/ myPosition) async {
    String cadastre = await this._repository.getCadastre(myPosition);
    return cadastre;
  }

  Future<Pature> getPature(String idu) async {
    Pature pature = await this._repository.getPature(idu);
    return pature;
  }

  Future<List<Pature>> getPaturages() async {
    List<Pature> parcelles = await this._repository.getPaturages(AuthService().cheptel!);
    return parcelles;
  }

  Future<Map<String, dynamic>> getPaturagesJson() async {
    List<Pature> patures = await this._repository.getPaturages(AuthService().cheptel!);
    Map<String, dynamic> _drawPatureJson = new Map();
    _drawPatureJson["type"] = "FeatureCollection";
    _drawPatureJson["features"] = [];
    patures.forEach( (pature)
    {
      Map feature = jsonDecode(pature.centroid!);
      if (pature.lot != null)
        feature["properties"]["lot"] = pature.lot;
      else
        feature["properties"]["lot"] = AuthService().cheptel;
      _drawPatureJson["features"].add(feature);
    });
    return _drawPatureJson;
  }

  Future<String> getParcelle(Position touchPosition) async {
    String cadastre = await this._repository.getParcelle(touchPosition);
    return cadastre;
  }

  Future<List<Parcelle>> getParcelles()  async{
      List<Parcelle> parcelles = await this._repository.getParcelles();
      return parcelles;
  }

  Future<String> savePature(Pature pature) async {
    return await this._repository.savePature(pature);
  }
}