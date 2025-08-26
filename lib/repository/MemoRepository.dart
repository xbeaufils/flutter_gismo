import 'dart:developer' as debug;
import 'package:flutter_gismo/env/Environnement.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/MemoModel.dart';
import 'package:flutter_gismo/core/repository/AbstractRepository.dart';
import 'package:flutter_gismo/core/repository/LocalRepository.dart';
import 'package:sentry/sentry.dart';
import 'package:sqflite/sqflite.dart';

abstract class Memorepository {
  Future<List<MemoModel>> getCheptelMemos(String cheptel) ;
  Future<List<MemoModel>> getMemos(Bete bete) ;
  Future<MemoModel?> searchMemo(int id) ;
  Future<String> save(MemoModel note);
  Future<String> delete(MemoModel note) ;
}

class WebMemoRepository extends WebRepository implements Memorepository {
  WebMemoRepository(super.token);

  Future<List<MemoModel>> getCheptelMemos(String cheptel) async {
    final response = await super.doGetList(
        '/memo/active/' + cheptel);
    List<MemoModel> tempList =[];
    for (int i = 0; i < response.length; i++) {
      tempList.add(new MemoModel.fromResult(response[i]));
    }
    return tempList;
  }

  @override
  Future<List<MemoModel>> getMemos(Bete bete) async {
    final response = await super.doGetList(
        '/memo/get/' + bete.idBd.toString());
    List<MemoModel> tempList =[];
    for (int i = 0; i < response.length; i++) {
      tempList.add(new MemoModel.fromResult(response[i]));
    }
    return tempList;

  }

  Future<String> save(MemoModel note) async {
    try {
      final response = await super.doPostMessage(
          '/memo/new', note.toJson());
      return response;
    } on GismoException catch(e) {
      throw e;
    }  catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  Future<MemoModel?> searchMemo(int id) async {
    final response = await super.doGet(
        '/memo/search/' + id.toString());
    return new MemoModel.fromResult(response);
  }

  @override
  Future<String> delete(MemoModel note) async {
    try {
      final response = await super.doGet(
          '/memo/del/'+ note.id!.toString());
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

class LocalMemoRepository extends LocalRepository implements Memorepository {
  Future<List<MemoModel>> getCheptelMemos(String cheptel) async {
    Database db = await this.database;
    List<Map<String, dynamic>> maps  = await db.rawQuery(
        'SELECT _memo.*, _bete.numBoucle, _bete.numMarquage '
            'FROM memo _memo inner join bete _bete on _memo.bete_id = _bete.id '
            'where _bete.cheptel= ? '
            ' AND _memo.fin is null'
        ,
        [cheptel]);
    List<MemoModel> tempList = [];
    maps.forEach((element) {
      tempList.add(new MemoModel.fromResult(element)); });
    return tempList;
  }
  @override
  Future<List<MemoModel>> getMemos(Bete bete) async {
    Database db = await this.database;
    List<Map<String, dynamic>> maps  = await db.rawQuery(
        'SELECT _note.*, _bete.numBoucle, _bete.numMarquage '
            'FROM memo _note inner join bete _bete on _note.bete_id = _bete.id '
            'where _bete.id= ?',
        [bete.idBd]);
    List<MemoModel> tempList = [];
    for (int i = 0; i < maps.length; i++) {
      tempList.add(new MemoModel.fromResult(maps[i]));
    }
    return tempList;

  }

  Future<String> save(MemoModel note) async {
    try {
      Database db = await this.database;
      await db.insert("memo", note.toJson(),
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

  Future<MemoModel?> searchMemo(int id) async {
    Database db = await this.database;
    List<Map<String, dynamic>> futureMaps = await db.query('memo',where: 'id= ?', whereArgs: [id]);
    if (futureMaps.length == 0)
      return null;
    return MemoModel.fromResult(futureMaps[0]);
  }

  @override
  Future<String> delete(MemoModel note) async {
    Database db = await this.database;
    int res =   await db.delete("memo",
        where: "id = ?", whereArgs: <int>[note.id!]);
    return "Suppression effectuée";
  }

}