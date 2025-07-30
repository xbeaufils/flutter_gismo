
import 'dart:convert';

import 'package:gismo/core/repository/AbstractRepository.dart';
import 'package:gismo/env/Environnement.dart';
import 'package:gismo/model/ParcelleModel.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

abstract class ParcelleRepository {
  Future<Pature> getPature(String idu);
  Future<String> getParcelle(Position touchPosition);
  Future<List<Parcelle>> getParcelles();
  Future<String> getCadastre( Position myPosition);
  Future<String> savePature(Pature pature);
}

class WebParcelleRepository  extends WebRepository implements ParcelleRepository{
  WebParcelleRepository(super.token);

  Future<Pature> getPature(String idu) async {
    try {
      final response = await super.doGet(
          '/paturage/' + idu);
      if( response.length>0) {
        Pature pature = Pature.fromResult(response);
        return pature;
      }
      throw ("Pature non trouvée");
    }  catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  Future<String> getParcelle(Position touchPosition) async {
    try {
      final response = await super.doPostParcelle(
          '/map/parcelle', jsonEncode({
        'lattitude': touchPosition.lat,
        'longitude': touchPosition.lng
      }));
      String cadastre =  response;
      return cadastre;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  Future<List<Parcelle>> getParcelles() async {
    try {
      final response = await super.doGetList(
          '/map/parcelles/');
      List<Parcelle> parcelles = [];
      for (int i = 0; i < response.length; i++) {
        parcelles.add(Parcelle.fromResult(response[i]));
      }
      return parcelles;
    } catch ( e) {
      throw ("Erreur de connection à ${Environnement.getUrlTarget()}");
    }
  }

  Future<String> getCadastre( Position myPosition) async {
    try {
      final response = await super.doPostParcelle(
          '/map/cadastre', jsonEncode({
            'lattitude': myPosition.lat,
            'longitude': myPosition.lng
      }));
        String cadastre =  response;
        return cadastre;
    }  catch ( e) {
      throw ("Erreur de connection à ${Environnement.getUrlTarget()}");
    }
  }
  Future<String> savePature(Pature pature) async {
    try {
      final response = await super.doPostMessage(
          '/paturage/save', pature.toJson());
      return response;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }

  }

}