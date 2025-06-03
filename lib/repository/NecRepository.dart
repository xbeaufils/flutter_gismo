import 'dart:developer' as debug;

import 'package:flutter_gismo/env/Environnement.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/NECModel.dart';
import 'package:flutter_gismo/repository/AbstractRepository.dart';
import 'package:flutter_gismo/repository/LocalRepository.dart';
import 'package:sentry/sentry.dart';
import 'package:sqflite/sqflite.dart';

abstract class NecRepository {
  Future<String> save(NoteModel node);
  Future<List<NoteModel>> get(Bete bete);
  Future<String> delete(int idBd);
}

class WebNecRepository extends WebRepository implements NecRepository{
  WebNecRepository(super.token);
  @override
  Future<String> save(NoteModel note) async {
    try {
      final response = await super.doPostMessage(
          '/nec/new', note.toJson());
      return response;
    }catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  @override
  Future<List<NoteModel>> get(Bete bete) async {
    final response = await super.doGetList(
        '/nec/get?idBete=' + bete.idBd.toString());
    List<NoteModel> tempList = List.empty(growable: true);
    for (int i = 0; i < response.length; i++) {
      tempList.add(new NoteModel.fromResult(response[i]));
    }
    return tempList;
  }

  @override
  Future<String> delete(int idBd) async {
    try {
      final response = await super.doGet('/nec/del/' + idBd.toString());
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

class LocalNecRepository extends LocalRepository implements NecRepository {
  @override
  Future<String> save(NoteModel note) async {
    try {
      Database db = await this.database;
      await db.insert('NEC', note.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      return "Enregistrement de la note";
    }
    catch(e,stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //super.bloc.reportError(e, stackTrace);
    }
    return "Erreur d'enregistrement";
  }

  @override
  Future<List<NoteModel>> get(Bete bete) async {
    Database db = await this.database;
    List<Map<String, dynamic>> futureMaps = await db.query('NEC',where: 'bete_id = ?', whereArgs: [bete.idBd]);
    List<NoteModel> tempList = [];
    for (int i = 0; i < futureMaps.length; i++) {
      tempList.add(NoteModel.fromResult(futureMaps[i]));
    }
    return tempList;
  }

  @override
  Future<String> delete(int idBd) async {
    Database db = await this.database;
    int res =   await db.delete("NEC",
        where: "idBd = ?", whereArgs: <int>[idBd]);
    return "Suppression effectuée";
  }

}