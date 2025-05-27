import 'dart:developer' as debug;

import 'package:flutter_gismo/env/Environnement.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/repository/AbstractRepository.dart';
import 'package:flutter_gismo/repository/LocalRepository.dart';
import 'package:intl/intl.dart';
import 'package:sentry/sentry.dart';
import 'package:sqflite/sqflite.dart';

abstract class LambRepository {
  Future<String> saveLambing(LambingModel lambing );
  Future<String> saveLamb(LambModel lambing );
  Future<String> deleteLamb(int idBd);
  Future<LambingModel?> searchLambing(int idBd);
  Future<List<CompleteLambModel>> getAllLambs(String cheptel);
  Future<List<LambingModel>> getLambs(int idBete) ;
  Future<String> boucler(LambModel lamb, Bete bete);
  Future<void> mort(LambModel lamb, String motif, String date);
  Future<List<Bete>> getSaillieBeliers(LambingModel lambing);
  Future<List<Bete>> getLotBeliers(LambingModel lambing);
}

class WebLambRepository extends WebRepository implements LambRepository {

  final DateFormat _df = new DateFormat('dd/MM/yyyy');

  WebLambRepository(super.token);

  Future<String> saveLambing(LambingModel lambing ) async {
    try {
      final response = await super.doPostMessage('/lamb/add',lambing.toJson());
      return response;
    }
    on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      debug.log(e.toString());
      throw ("Erreur $e");
    }
  }

  Future<String> saveLamb(LambModel lamb ) async {
    try {
      final response = await super.doPostMessage('/lamb/save', lamb.toJson());
      return response;
    }
    on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      debug.log(e.toString());
      throw ("Erreur $e");
    }
  }

  Future<String> deleteLamb(int idBd ) async {
    try {
      final response = await super.doGet('/lamb/del/' + idBd.toString());
      if (response['error']) {
        throw (response['message']);
      }
      else {
        return response['message'];
      }
    }
    on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      debug.log(e.toString());
      throw ("Erreur $e");
    }
  }

  @override
  Future<String> boucler(LambModel lamb, Bete bete) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["lamb"] = lamb.toJson();
    data["bete"] = bete.toJson();
    try {
      final response = await super.doPostMessage(
          '/lamb/boucle',  data);
      return response;
    }
    on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      debug.log(e.toString());
      throw ("Erreur $e");
    }

  }


  @override
  Future<LambingModel> searchLambing(int idBd) async {
    final response = await super.doGet(
        '/lamb/search?idBd=' + idBd.toString());
    return new LambingModel.fromResult(response);
  }

  @override
  Future<String> mort(LambModel lamb, String motif, String date) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["idBb"] = lamb.idBd;
    data["dateDeces"] = _df.format(DateFormat.yMd().parse(date));
    data["motifDeces"] = motif;
    try {
      final response = await super.doPostMessage(
          '/lamb/mort', data);
      return response;
    }
    on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      debug.log(e.toString());
      throw ("Erreur $e");
    }
  }

  @override
  Future<List<CompleteLambModel>> getAllLambs(String cheptel) async {
    //final response = await _dio.get(
    final response = await super.doGetList(
        '/lamb/cheptel/' + cheptel);
    List<CompleteLambModel> tempList = [];
    for (int i = 0; i < response.length; i++) {
      tempList.add(new CompleteLambModel.fromResult(response[i]));
    }
    return tempList;
  }
  @override
  Future<List<LambingModel>> getLambs(int idBete) async {
    final response = await super.doGetList(
        '/lamb/searchAll?idMere=' + idBete.toString());
    List<LambingModel> tempList = [];
    for (int i = 0; i < response.length; i++) {
      tempList.add(new LambingModel.fromResult(response[i]));
    }
    return tempList;
  }


  @override
  Future<List<Bete>> getLotBeliers(LambingModel lambing) async {
    try {
      final response = await super.doPostResult('/lamb/male/lot',lambing.toJson());
      List<Bete> tempList = [];
      for (int i = 0; i < response['beliers'].length; i++) {
        tempList.add(new Bete.fromResult(response['beliers'][i]));
      }
      return tempList;
    }
    on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      debug.log(e.toString());
      throw ("Erreur $e");
    }
  }

  @override
  Future<List<Bete>> getSaillieBeliers(LambingModel lambing) async {
    try {
      final response = await super.doPostResult('/lamb/male/saillie',lambing.toJson());
      List<Bete> tempList = [];
      //tempList = response['beliers'];
      for (int i = 0; i < response['beliers'].length; i++) {
        tempList.add(new Bete.fromResult(response['beliers'][i]));
      }
      return tempList;
    }
    on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      debug.log(e.toString());
      throw ("Erreur $e");
    }
  }
}

class LocalLambRepository extends LocalRepository implements LambRepository {
  final _df = new DateFormat('dd/MM/yyyy');

  @override
  Future<String> saveLambing(LambingModel lambing ) async {
    Database db = await this.database;
    db.transaction((txn) async {
      int idAgnelage = await _saveLambing(lambing, txn);
      lambing.lambs.forEach((lamb) => {
        _saveLamb(lamb, txn, idAgnelage)
      });
    });
    return "Enregistrement effectué";
  }

  Future<int> _saveLambing(LambingModel lambing, Transaction tx) {
    return tx.insert(
        'agnelage',
        lambing.toBdJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }


  Future<int> _saveLamb(LambModel lamb,Transaction tx, int idAgnelage) {
    lamb.idAgnelage = idAgnelage;
    return tx.insert(
        'agneaux',
        lamb.toBdJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String> saveLamb(LambModel lamb ) async {
    Database db = await this.database;
    int res =   await db.update("agneaux", lamb.toJson(),
        where: "id = ?", whereArgs: <int>[lamb.idBd!]);
    return "enregistrement modifié";
  }

  Future<String> deleteLamb(int idBd ) async {
    Database db = await this.database;
    int res =   await db.delete("agneaux",
        where: "id = ?", whereArgs: <int>[idBd]);
    return "Suppression effectuée";
  }

  @override
  Future<LambingModel ?> searchLambing(int idBd) async {
    Database db = await this.database;
    final List<Map<String, dynamic>> futureMaps = await db.query(
        'agnelage', where: 'id = ?', whereArgs: [idBd]);
    if (futureMaps.length == 0) {
      debug.log("Agnelage non trouvé " + idBd.toString(),
          name: "LocalDataProvider::searchLambing");
      return null;
    }
    LambingModel current = new LambingModel.fromResult(futureMaps[0]);
    if (current.idPere != null) {
      Bete ? pere = await this._searchBete(current.idPere!);
      if (pere != null) {
        current.numMarquagePere = pere.numMarquage;
        current.numBouclePere = pere.numBoucle;
      }
    }
    Bete ? mere = await this._searchBete(current.idMere);
    if (mere != null) {
      current.numMarquageMere = mere.numMarquage;
      current.numBoucleMere = mere.numBoucle;
    }
    current.lambs = [];
    List<Map<String, dynamic>> agneaux = await db.query('agneaux',where: 'agnelage_id = ?', whereArgs: [current.idBd]);
    for (int j = 0; j < agneaux.length; j++) {
      LambModel aLamb = LambModel.fromResult(agneaux[j]);
      if (aLamb.idDevenir != null ) {
        Bete ? devenu = await this._searchBete(idBd);
        if (devenu != null) {
          aLamb.numMarquage = devenu.numMarquage;
          aLamb.numBoucle = devenu.numBoucle;
        }
      }
      current.lambs.add(aLamb);
    }
    return current;
  }

  @override
  Future<List<CompleteLambModel>> getAllLambs(String cheptel) async {
    List<CompleteLambModel> tempList = [];
    try {
      Database db = await this.database;
      List<Map<String, dynamic>> agneaux  = await db.rawQuery(
          'select lambentity0_.*, lambingent1_.dateAgnelage, beteentity2_.numBoucle as numBoucleMere, beteentity2_.numMarquage as numMarquageMere '
              'from agneaux lambentity0_ '
          //'left outer join mort_agneaux mortentity3_ on lambentity0_.id=mortentity3_.lamb_id '
              'cross join agnelage lambingent1_ '
              'cross join bete beteentity2_ '
              'where lambentity0_.agnelage_id=lambingent1_.id '
              'and lambingent1_.mere_id=beteentity2_.id '
              'and beteentity2_.cheptel= ? '
              'and (lambentity0_.sante="VIVANT"'
              'and (lambentity0_.dateDeces is NULL)'
              'and (lambentity0_.devenir_id is null))',
          [cheptel]);
      for (int j = 0; j < agneaux.length; j++) {
        CompleteLambModel lamb = CompleteLambModel.fromResult(agneaux[j]);
        tempList.add(lamb);
      }
    } catch (e,stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //super.bloc.reportError(e, stackTrace);
    }
    return tempList;
  }

  @override
  Future<List<LambingModel>> getLambs(int idBete) async {
    List<LambingModel> tempList = [];
    try {
      Database db = await this.database;
      final Future<List<Map<String, dynamic>>> futureMaps = db.query('agnelage',where: 'mere_id = ?', whereArgs: [idBete]);
      var maps = await futureMaps;
      for (int i = 0; i < maps.length; i++) {
        LambingModel current = new LambingModel.fromResult(maps[i]);
        current.lambs = [];
        List<Map<String, dynamic>> agneaux = await db.query('agneaux',where: 'agnelage_id = ?', whereArgs: [current.idBd]);
        for (int j = 0; j < agneaux.length; j++) {
          LambModel lamb = LambModel.fromResult(agneaux[j]);
          if (lamb.idDevenir != null) {
            Bete ? devenu = await this._searchBete(lamb.idDevenir!);
            if (devenu != null) {
              lamb.numBoucle = devenu.numBoucle;
              lamb.numMarquage = devenu.numMarquage;
            }
          }
          current.lambs.add(lamb);
        }
        tempList.add(current);
      }
    } catch (e,stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //super.bloc.reportError(e, stackTrace);
    }
    return tempList;
  }

  @override
  Future<String> boucler(LambModel lamb, Bete bete) async {
    Database db = await this.database;
    LambingModel ? agnelage = await this.searchLambing(lamb.idAgnelage);
    if (agnelage == null)
      return "Agnelage non trouvé";
    bete.dateEntree = agnelage.dateAgnelage!;
    int idBete = await db.insert(
        'bete', bete.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    lamb.idDevenir = idBete;
    db.update('agneaux', lamb.toBdJson(), where: "id = ?",
        whereArgs: <int>[lamb.idBd!]);
    db.rawUpdate(
        'udpate traitement set beteId=? where lambId=?', [idBete, lamb.idBd]);
    db.rawUpdate(
        "UPDATE pesee set bete_id=? where lamb_id=?", [idBete, lamb.idBd]);
    return "Bouclage enregistré";
  }

  @override
  Future<void> mort(LambModel lamb,  String motif, String date) async {
    Database db = await this.database;
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["dateDeces"] = _df.format(DateFormat.yMd().parse(date));
    data["motifDeces"] = motif;
    db.update("agneaux", data, where: "id = ?", whereArgs: <int>[lamb.idBd!]);
  }

  @override
  Future<List<Bete>> getSaillieBeliers(LambingModel lambing) {
    throw UnimplementedError();
  }
  @override
  Future<List<Bete>> getLotBeliers(LambingModel lambing) {
    throw UnimplementedError();
  }

  Future<Bete?> _searchBete(int idBd) async {
    Database db = await this.database;
    List<Map<String, dynamic>> futureMaps = await db.query('bete' ,where: 'id = ?', whereArgs: [idBd]);
    if (futureMaps.length == 0) {
      debug.log("Bete non trouvéé " + idBd.toString(), name: "LocalDataProvider::searchBete");
      return null;
    }
    return Bete.fromResult(futureMaps[0]);
  }

}