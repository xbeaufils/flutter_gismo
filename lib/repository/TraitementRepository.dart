import 'dart:developer' as debug;

import 'package:flutter_gismo/env/Environnement.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';
import 'package:flutter_gismo/core/repository/AbstractRepository.dart';
import 'package:flutter_gismo/core/repository/LocalRepository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sentry/sentry.dart';

abstract class Traitementrepository {
  Future<String> deleteTraitement(int idBd) ;
  Future<String> saveTraitement(TraitementModel traitement) ;
  Future<String> saveTraitementCollectif(TraitementModel traitement, List<MedicModel> medics, List<Bete> betes) ;
  Future<List<TraitementModel>> getTraitementsForLamb(LambModel lamb);
  Future<List<TraitementModel>> getTraitements(Bete bete) ;
  Future<TraitementModel?> searchTraitement(int idBd);
}

class WebTraitementRepository  extends WebRepository implements Traitementrepository {

  WebTraitementRepository(super.token);

  @override
  Future<String> saveTraitement(TraitementModel traitement) async {
    final Map<String, dynamic> data = traitement.toJson();
    try {
      final response = await super.doPostMessage(
          '/traitement/add', data);
      return response;
    } on GismoException catch(e) {
      throw e;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  @override
  Future<String> saveTraitementCollectif (TraitementModel traitement, List<MedicModel> medics, List<Bete> betes) async {
    TraitementMultiMedic col = new TraitementMultiMedic(traitement, medics, betes);
    final Map<String, dynamic> data = col.toJson();
    try {
      final response = await super.doPostMessage(
          '/traitement/collectif', data);
      return response;
    } on GismoException catch(e) {
      throw e;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  @override
  Future<List<TraitementModel>> getTraitements(Bete bete) async {
    final response = await super.doGetList(
        '/traitement/get?idBete=' + bete.idBd.toString());
    List<TraitementModel> tempList = [];
    for (int i = 0; i < response.length; i++) {
      tempList.add(new TraitementModel.fromResult(response[i]));
    }
    return tempList;
  }

  @override
  Future<List<TraitementModel>> getTraitementsForLamb(LambModel lamb) async {
    final response = await super.doGetList(
        '/traitement/lamb/' + lamb.idBd.toString());
    List<TraitementModel> tempList = [];
    for (int i = 0; i < response.length; i++) {
      tempList.add(new TraitementModel.fromResult(response[i]));
    }
    return tempList;
  }

  @override
  Future<String> deleteTraitement(int idBd) async {
    try {
      final response = await super.doGet('/traitement/del/' + idBd.toString());
      return response['message'];
    }
    catch ( e) {
      debug.log("Error " + e.toString());
      return "Error " + e.toString();
    }
  }

  @override
  Future<TraitementModel> searchTraitement(int idBd) async {
    final response = await super.doGet(
        '/traitement/search?idBd=' + idBd.toString());
    return new TraitementModel.fromResult(response);
  }

}

class LocalTraitementRepository extends LocalRepository implements Traitementrepository {
  @override
  Future<String> saveTraitement(TraitementModel traitement) async{
    try {
      Database db = await this.database;
      await db.insert("traitement", traitement.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return " Enregistrement effectué";
    }
    catch(e,stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //super.bloc.reportError(e, stackTrace);
      debug.log("Error", error: e);
      return "Erreur d'enregistrement";
    }
  }

  Future<String> saveTraitementCollectif(TraitementModel traitement, List<MedicModel> medics, List<Bete> betes) async{
    betes.forEach((bete)  {
      TraitementModel entity = new TraitementModel.fromResult(traitement.toJson());
      medics.forEach((medic) {
        entity.idBete = bete.idBd;
        entity.medic = medic;
        this.saveTraitement(entity);
      });
    });
    return " Enregistrement effectué";
  }

  @override
  Future<List<TraitementModel>> getTraitements(Bete bete) async{
    Database db = await this.database;
    List<Map<String, dynamic>> futureMaps = await db.query('traitement',where: 'beteId = ?', whereArgs: [bete.idBd]);
    List<TraitementModel> tempList = [];
    for (int i = 0; i < futureMaps.length; i++) {
      tempList.add(TraitementModel.fromResult(futureMaps[i]));
    }
    return tempList;
  }

  @override
  Future<List<TraitementModel>> getTraitementsForLamb(LambModel lamb) async{
    Database db = await this.database;
    List<Map<String, dynamic>> futureMaps = await db.query('traitement',where: 'lambId = ?', whereArgs: [lamb.idBd]);
    List<TraitementModel> tempList = [];
    for (int i = 0; i < futureMaps.length; i++) {
      tempList.add(TraitementModel.fromResult(futureMaps[i]));
    }
    return tempList;
  }

  @override
  Future<TraitementModel?> searchTraitement(int idBd) async {
    Database db = await this.database;
    List<Map<String, dynamic>> futureMaps = await db.query('traitement',where: 'idBd = ?', whereArgs: [idBd]);
    if (futureMaps.length == 0)
      return null;
    return TraitementModel.fromResult(futureMaps[0]);
  }


  @override
  Future<String> deleteTraitement(int idBd) async {
    Database db = await this.database;
    db.delete("traitement" , where: 'idBd = ?', whereArgs: [idBd]);
    return " Enregistrement supprimé";
  }

}