import 'dart:developer' as debug;

import 'package:flutter_gismo/core/repository/AbstractRepository.dart';
import 'package:flutter_gismo/core/repository/LocalRepository.dart';
import 'package:flutter_gismo/env/Environnement.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/PeseeModel.dart';
import 'package:sentry/sentry.dart';
import 'package:sqflite/sqflite.dart';

abstract class PeseeRepository {
  Future<String> savePesee(Pesee pesee);
  Future<List<Pesee>> getPesee(Bete bete);
  Future<List<Pesee>> getPeseeForLamb(LambModel lamb);
  Future<String> deletePesee(int idBd);

}

class WebPeseeRepository  extends WebRepository implements PeseeRepository{

  WebPeseeRepository(super.token);

  @override
  Future<String> savePesee(Pesee pesee) async {
    try {
      final response = await super.doPostMessage(
          '/poids/new',  pesee.toJson());
      return response;
    } on GismoException catch(e) {
      throw e;
    } on Exception catch (e) {
        throw GismoException(e.toString());
    }
  }

  @override
  Future<List<Pesee>> getPesee(Bete bete) async {
    final response = await super.doGetList(
        '/poids/get/' + bete.idBd.toString());
    List<Pesee> tempList = List.empty(growable: true);
    for (int i = 0; i < response.length; i++) {
      tempList.add(new Pesee.fromResult(response[i]));
    }
    return tempList;
  }

  @override
  Future<List<Pesee>> getPeseeForLamb(LambModel lamb) async {
    final response = await super.doGetList(
        '/poids/lamb/' + lamb.idBd.toString());
    List<Pesee> tempList = List.empty(growable: true);
    for (int i = 0; i < response.length; i++) {
      tempList.add(new Pesee.fromResult(response[i]));
    }
    return tempList;
  }

  @override
  Future<String> deletePesee(int idBd) async {
    try {
      final response = await super.doGet('/poids/del/' + idBd.toString());
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

}

class LocalPeseeRepository extends LocalRepository implements PeseeRepository {
  static Database ? _database;

  @override
  Future<String> savePesee(Pesee note) async {
    try {
      Database db = await this.database;
      await db.insert('pesee', note.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      return "Enregistrement de la pesée";
    }
    catch(e,stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //      super.bloc.reportError(e, stackTrace);
    }
    return "Erreur d'enregistrement";
  }

  @override
  Future<List<Pesee>> getPesee(Bete bete) async {
    Database db = await this.database;
    List<Map<String, dynamic>> futureMaps = await db.query('pesee',where: 'bete_id = ?', whereArgs: [bete.idBd]);
    List<Pesee> tempList = [];
    for (int i = 0; i < futureMaps.length; i++) {
      tempList.add(Pesee.fromResult(futureMaps[i]));
    }
    return tempList;
  }


  @override
  Future<List<Pesee>> getPeseeForLamb(LambModel lamb) async {
    Database db = await this.database;
    List<Map<String, dynamic>> futureMaps = await db.query('pesee',where: 'lamb_id = ?', whereArgs: [lamb.idBd]);
    List<Pesee> tempList = [];
    for (int i = 0; i < futureMaps.length; i++) {
      tempList.add(Pesee.fromResult(futureMaps[i]));
    }
    return tempList;
  }

  @override
  Future<String> deletePesee(int idBd) async {
    Database db = await this.database;
    int res =   await db.delete("pesee",
        where: "id = ?", whereArgs: <int>[idBd]);
    return "Suppression effectuée";
  }

}