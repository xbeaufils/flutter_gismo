import 'dart:developer' as debug;
import 'package:flutter_gismo/env/Environnement.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/EchographieModel.dart';
import 'package:flutter_gismo/repository/AbstractRepository.dart';
import 'package:flutter_gismo/repository/LocalRepository.dart';
import 'package:sentry/sentry.dart';
import 'package:sqflite/sqflite.dart';

abstract class Echorepository {
  Future<String> saveEcho(EchographieModel echo);
  Future<String> deleteEcho(EchographieModel echo);
  Future<EchographieModel?> searchEcho(int idBd);
  Future<List<EchographieModel>> getEcho(Bete bete);
}

class WebEchoRepository extends WebRepository implements Echorepository {
  WebEchoRepository(super.token);

  @override
  Future<String> saveEcho(EchographieModel echo) async {
    try {
      final response = await super.doPostMessage(
          '/echo/new', echo.toJson());
      return response;
    }  catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  Future<String> deleteEcho(EchographieModel echo) async {
    try {
      final response = await super.doDeleteMessage(
          '/echo/delete', echo.toJson());
      return response;
    }
    catch (e, stacktrace) {
      debug.log("Error", error: e);
      Sentry.captureException(e, stackTrace : stacktrace);
    }
    return "Erreur de suppression";
  }

  @override
  Future<List<EchographieModel>> getEcho(Bete bete) async {
    final response = await super.doGetList(
        '/echo/get/' + bete.idBd.toString());
    List<EchographieModel> tempList = [];
    for (int i = 0; i < response.length; i++) {
      tempList.add(new EchographieModel.fromResult(response[i]));
    }
    return tempList;
  }

  @override
  Future<EchographieModel> searchEcho(int idBd) async {
    final response = await super.doGet(
        '/echo/search/' + idBd.toString());
    return new EchographieModel.fromResult(response);
  }
}

class LocalEchoRepository extends LocalRepository implements Echorepository {
  @override
  Future<String> saveEcho(EchographieModel echo) async {
    try {
      Database db = await this.database;
      await db.insert('Echo', echo.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      return "Enregistrement de l'echographie";
    }
    catch(e,stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //super.bloc.reportError(e, stackTrace);
    }
    return "Erreur d'enregistrement";
  }

  @override
  Future<String> deleteEcho(EchographieModel echo) async {
    try {
      Database db = await this.database;
      int res =   await db.delete("Echo",
          where: "id = ?", whereArgs: <int>[echo.idBd!]);
      return "Suppression OK";
    }
    catch(e,stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
    }
    return "Erreur de suppression";
  }

  @override
  Future<EchographieModel?> searchEcho(int idBd) async {
    Database db = await this.database;
    List<Map<String, dynamic>> futureMaps = await db.query('Echo',where: 'id= ?', whereArgs: [idBd]);
    if (futureMaps.length == 0)
      return null;
    return EchographieModel.fromResult(futureMaps[0]);
  }

  @override
  Future<List<EchographieModel>> getEcho(Bete bete) async {
    Database db = await this.database;
    List<Map<String, dynamic>> futureMaps = await db.query('Echo',where: 'bete_id = ?', whereArgs: [bete.idBd]);
    List<EchographieModel> tempList = [];
    for (int i = 0; i < futureMaps.length; i++) {
      tempList.add(EchographieModel.fromResult(futureMaps[i]));
    }
    return tempList;
  }

}