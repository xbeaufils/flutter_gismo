
import 'dart:convert';

import 'package:flutter_gismo/core/repository/AbstractRepository.dart';
import 'package:flutter_gismo/env/Environnement.dart';
import 'package:flutter_gismo/model/ParcelleModel.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

abstract class ParcelleRepository {
  Future<Pature> getPature(String idu);
  Future<String> getParcelle(LatLng touchPosition);
  Future<List<Parcelle>> getParcelles();
  Future<String> getCadastre( LatLng myPosition);
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

  Future<String> getParcelle(LatLng touchPosition) async {
    try {
      final response = await super.doPostParcelle(
          '/map/parcelle', jsonEncode({
        'lattitude': touchPosition.latitude,
        'longitude': touchPosition.longitude
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
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  Future<String> getCadastre( LatLng myPosition) async {
    try {
      final response = await super.doPostParcelle(
          '/map/cadastre', jsonEncode({
            'lattitude': myPosition.latitude,
            'longitude': myPosition.longitude
      }));
        String cadastre =  response;
        return cadastre;
    }  catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
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