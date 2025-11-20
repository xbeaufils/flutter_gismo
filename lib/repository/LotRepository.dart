import 'dart:developer' as debug;
import 'package:flutter_gismo/env/Environnement.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/core/repository/AbstractRepository.dart';
import 'package:flutter_gismo/core/repository/LocalRepository.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:sentry/sentry.dart';
import 'package:sqflite/sqflite.dart';

abstract class LotRepository {
  Future<List<LotModel>> getLots(String cheptel) ;
  Future<LotModel?> saveLot(LotModel lot);
  Future<String> deleteLot(LotModel lot);
  Future<List<Affectation>>getBrebisForLot(int idLot);
  Future<List<Affectation>>getBeliersForLot(int idLot);
  Future<List<Affectation>>getAffectationForBete(int idBete);
  Future<String> updateAffectation(Affectation affect);
  Future<String> addBete(LotModel lot, Bete bete);
  Future<String> deleteAffectation(Affectation affect);
  Future<String> updateAffectationInLot(List<Affectation> toAdd, List<Affectation> toRemove);
}

class WebLotRepository extends WebRepository implements LotRepository {
  WebLotRepository(super.token);

  @override
  Future<List<LotModel>> getLots(String cheptel) async {
    final response = await super.doGetList(
        '/lot/getAll/' + cheptel);
    List<LotModel> tempList =[];
    for (int i = 0; i < response.length; i++) {
      tempList.add(new LotModel.fromResult(response[i]));
    }
    return tempList;
  }

  @override
  Future<List<Affectation>> getBeliersForLot(int idLot) async {
    final response = await super.doGetList(
        '/lot/getBeliers/' + idLot.toString());
    List<Affectation> tempList = [];
    for (int i = 0; i < response.length; i++) {
      tempList.add(new Affectation.fromResult(response[i]));
    }
    return tempList;
  }

  @override
  Future<List<Affectation>> getBrebisForLot(int idLot) async {
    final response = await super.doGetList(
        '/lot/getBrebis/' + idLot.toString());
    List<Affectation> tempList = [];
    for (int i = 0; i < response.length; i++) {
      tempList.add(new Affectation.fromResult(response[i]));
    }
    return tempList;
  }

  @override
  Future<String> updateAffectation(Affectation affect) async {
    try {
      final response = await super.doPostMessage(
          '/lot/date', affect.toJson());
      return response;
    } on GismoException catch(e) {
      throw e;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }


  @override
  Future<String> deleteAffectation(Affectation affect) async {
    try {
      final response = await super.doGet(
          '/lot/delete/'+ affect.idAffectation!.toString());
      if (response['error']) {
        throw (response['message']);
      }
      else {
        return response['message'];
      }
    }
    catch ( e) {
      debug.log("Error " + e.toString());
      return "Error " + e.toString();
    }
  }

  @override
  Future<String> addBete(LotModel lot, Bete bete) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["lotId"] = lot.idb;
    data["brebisId"] = bete.idBd;
    try {
      final response = await super.doPostMessage(
          '/lot/add', data);
      return response;
    } on GismoException catch (e){
        throw e;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }

  }
  @override
  Future<String> updateAffectationInLot(List<Affectation> toAdd, List<Affectation> toRemove) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['added'] = toAdd;
      data['removed'] = toRemove;
      final response = await super.doPostMessage(
          '/lot/update', data);
      return response;

    } on GismoException catch(e) {
      throw e;
    } catch (e,stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //      super.bloc.reportError(e, stackTrace);
      return "Une erreur est survenue :" + e.toString();
    }
    return S.current.record_saved;

  }

  @override
  Future<LotModel> saveLot(LotModel lot) async{
    try {
      final response = await super.doPostResult(
          '/lot/create', lot.toJson());
      return LotModel.fromResult(response);
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  Future<String> deleteLot(LotModel lot) async {
    try {
      final response = await super.doDeleteMessage(
          '/lot/suppress', lot.toJson());
      return response;
    }
    catch (e, stacktrace) {
      debug.log("Error", error: e);
      Sentry.captureException(e, stackTrace : stacktrace);
    }
    return "Erreur de suppression";
  }

  @override
  Future<List<Affectation>> getAffectationForBete(int idBete) async {
    try {
      final response = await super.doGetList(
          '/lot/bete/' + idBete.toString());
      List<Affectation> tempList = [];
      for (int i = 0; i < response.length; i++) {
        tempList.add(new Affectation.fromResult(response[i]));
      }
      return tempList;
    }
    catch (e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }

  }

}

class LocalLotRepository extends LocalRepository implements LotRepository {

  @override
  Future<List<LotModel>> getLots(String cheptel) async {
    Database db = await this.database;
    List<Map<String, dynamic>> maps = await db.query('lot' ,where: 'cheptel = ?', whereArgs: [cheptel]);
    List<LotModel> tempList = [];
    for (int i = 0; i < maps.length; i++) {
      tempList.add(new LotModel.fromResult(maps[i]));
    }
    return tempList;
  }

  @override
  Future<List<Affectation>> getBeliersForLot(int idLot) async {
    Database db = await this.database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
        'Select affectation.idBd, affectation.lotId, affectation.brebisId, bete.numBoucle, bete.numMarquage, affectation.dateEntree, affectation.dateSortie '
            'from affectation INNER JOIN bete ON affectation.brebisId = bete.id '
            'where lotId = ' + idLot.toString()
            + " AND bete.sex = 'male' ");
    List<Affectation> tempList = [];
    for (int i = 0; i < maps.length; i++) {
      tempList.add(Affectation.fromResult(maps[i]));
    }
    return tempList;
  }

  @override
  Future<List<Affectation>> getBrebisForLot(int idLot) async {
    Database db = await this.database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
        'Select affectation.idBd, affectation.lotId, affectation.brebisId, bete.numBoucle, bete.numMarquage, affectation.dateEntree, affectation.dateSortie '
            'from affectation INNER JOIN bete ON affectation.brebisId = bete.id '
            'where lotId = ' + idLot.toString()
            + " AND bete.sex = 'femelle' ");
    List<Affectation> tempList = [];
    for (int i = 0; i < maps.length; i++) {
      tempList.add(new Affectation.fromResult(maps[i]));
    }
    return tempList;
  }

  @override
  Future<String> updateAffectation(Affectation affect) async{
    Database db = await this.database;
    Map<String, dynamic> dataDb = new Map.from(affect.toJson());
    dataDb.remove("numBoucle");
    dataDb.remove("numMarquage");
    db.update("affectation", dataDb, where: "idBd = ?", whereArgs: <int>[affect.idAffectation!]);
    return "Suppression OK";
  }

  @override
  Future<String> deleteAffectation(Affectation affect) async {
    Database db = await this.database;
    int res =   await db.delete("affectation",
        where: "idBd = ?", whereArgs: <int>[affect.idAffectation!]);
    return "Suppression OK";
  }

  @override
  Future<LotModel ?> saveLot(LotModel lot) async {
    try {
      Database db = await this.database;
      int id = await db.insert("lot", lot.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      lot.idb = id;
      return lot;
    }
    catch(e, stackTrace) {
      debug.log("Error", error: e);
      Sentry.captureException(e, stackTrace : stackTrace);
      //     super.bloc.sentry.captureException(exception: e, stackTrace: stackTrace);
    }
    return null;
  }

  Future<String> deleteLot(LotModel lot) async {
    try {
      List<Affectation> brebis = await this.getBrebisForLot(lot.idb!);
      if (brebis.isNotEmpty)
        return "Suppression impossible : des brebis ont des affectations";
      List<Affectation> beliers = await this.getBeliersForLot(lot.idb!);
      if (beliers.isNotEmpty)
        return "Suppression impossible : des beliers ont des affectations";
      Database db = await this.database;
      int res =   await db.delete("lot",
          where: "idBd = ?", whereArgs: <int>[lot.idb!]);
      return "Suppression effectuée";
    }
    catch (e, stacktrace) {
      debug.log("Error", error: e);
      Sentry.captureException(e, stackTrace : stacktrace);
    }
    return "Erreur de suppression";
  }


  @override
  Future<String> addBete(LotModel lot, Bete bete) async {
    try {
      Affectation affect = new Affectation();
      affect.lotId = lot.idb!;
      affect.brebisId = bete.idBd!;
      Map<String, dynamic> dataDb = new Map.from(affect.toJson());
      dataDb.remove("numBoucle");
      dataDb.remove("numMarquage");
      Database db = await this.database;
      await db.insert("affectation", dataDb,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    catch (e,stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //      super.bloc.reportError(e, stackTrace);
      return "Une erreur est survenue :" + e.toString();
    }
    return "Enregistrement effectué";
  }

  Future<String> updateAffectationInLot(List<Affectation> toAdd, List<Affectation> toRemove) async {
    Database db = await this.database;
    try {
      for (Affectation affect in toAdd) {
        Map<String, dynamic> dataDb = new Map.from(affect.toJson());
        await db.insert("affectation", dataDb,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      for (Affectation affectation in toRemove) {
        this.deleteAffectation(affectation);
      }
    }
    catch (e,stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //      super.bloc.reportError(e, stackTrace);
      return "Une erreur est survenue :" + e.toString();
    }
    return S.current.record_saved;
  }

  @override
  Future<List<Affectation>> getAffectationForBete(int idBete) async {
    try {
      Database db = await this.database;
      List<Map<String, dynamic>> maps = await db.rawQuery(
          "SELECT affec.*, lot.codeLotLutte as lotName, lot.dateDebutLutte, lot.dateFinLutte FROM affectation affec "
              "LEFT outer JOIN lot lot ON affec.lotId = lot.idBd "
              "WHERE brebisId= " + idBete.toString());
      List<Affectation> tempList = [];
      for (int i = 0; i < maps.length; i++) {
        tempList.add(new Affectation.fromResult(maps[i]));
      }
      return tempList;
    }
    on DatabaseException catch (e,stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //     super.bloc.reportError(e, stackTrace);
      debug.log("message " + e.toString());
      throw e;
    }
  }


}