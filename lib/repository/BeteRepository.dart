import 'dart:developer' as debug;

import 'package:flutter_gismo/env/Environnement.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/core/repository/AbstractRepository.dart';
import 'package:flutter_gismo/core/repository/LocalRepository.dart';
import 'package:flutter_gismo/services/AuthService.dart';
import 'package:intl/intl.dart';
import 'package:sentry/sentry.dart';
import 'package:sqflite/sqflite.dart';

abstract class BeteRepository {
  Future<List<Bete>> getBetes(String cheptel);
  Future<String> saveBete(Bete bete);
  Future<bool> checkBete(Bete bete);
  Future<String> saveSortie(DateTime date, String motif, List<Bete> lstBete);
  Future<String> saveEntree(String cheptel, DateTime date, String motif,List<Bete> lstBete);
  Future<Bete?> getMere(Bete bete);
  Future<Bete?> getPere(Bete bete);
  Future<List<Bete>>getBrebis();
  Future<List<Bete>>getBeliers();
}

class WebBeteRepository extends WebRepository implements BeteRepository {

  WebBeteRepository(String? token) : super(token);

  final DateFormat _df = new DateFormat('dd/MM/yyyy');

  Future<List<Bete>> getBetes(String cheptel) async {
    final response = await super.doGetList(
        '/bete/cheptel/' + cheptel);
    List<Bete> tempList = [];
    for (int i = 0; i < response.length; i++) {
      tempList.add(new Bete.fromResult(response[i]));
    }
    return tempList;
  }

  Future<String> saveBete(Bete bete) async {
    String action;
    if (bete.idBd == null)
      action = "new";
    else
      action = "update";
    try {
      final response = await super.doPostMessage(
          '/bete/' + action,
          bete.toJson());
      return response;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }


  @override
  Future<bool> checkBete(Bete bete) async {
    try {
      final response = await super.doPostResult(
          '/bete/check' ,
          bete.toJson());
      return response["value"];
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  @override
  Future<Bete?>  getMere(Bete bete) async {
    try {
      final response = await super.doGet(
          '/bete/mere/' + bete.idBd.toString());
      if (response.length ==0)
        return null;
      Bete mere = new Bete.fromResult(response);
      return mere;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  @override
  Future<Bete?> getPere(Bete bete) async {
    try {
      final response = await super.doGet(
          '/bete/pere/' + bete.idBd.toString());
      if (response.length ==0)
        return null;
      Bete pere = new Bete.fromResult(response);
      return pere;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  @override
  Future<String> saveSortie(DateTime date, String motif, List<Bete> lstBete) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cause'] = motif;
    data['dateSortie'] = _df.format(date);
    data['lstBete'] = lstBete.map((bete) => bete.toJson()).toList();
    try {
      final response = await super.doPostMessage(
          '/bete/sortie', data);
      return response;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  @override
  Future<String> saveEntree(String cheptel, DateTime date, String motif, List<Bete> lstBete) async {

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cheptel'] = cheptel;
    data['cause'] = motif;
    data['dateEntree'] = _df.format( date );
    data['lstBete'] = lstBete.map((bete) => bete.toJson()).toList();
    try {
      final response = await super.doPostMessage(
          '/bete/entree', data);
      return response;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }
  @override
  Future<List<Bete>> getBeliers() async {
    try {
      final response = await super.doGetList(
          '/bete/getBeliers/');
      List<Bete> tempList = [];
      for (int i = 0; i < response.length; i++) {
        tempList.add(new Bete.fromResult(response[i]));
      }
      return tempList;
    }
    catch (e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }

  }

  @override
  Future<List<Bete>> getBrebis() async {
    final response = await super.doGetList(
        '/bete/getBrebis/');
    List<Bete> tempList = [];
    for (int i = 0; i < response.length; i++) {
      tempList.add(new Bete.fromResult(response[i]));
    }
    return tempList;
  }

}

class LocalBeteRepository extends LocalRepository implements BeteRepository {
  final _df = new DateFormat('dd/MM/yyyy');

  Future<Bete?> _searchBete(int idBd) async {
    Database db = await this.database;
    List<Map<String, dynamic>> futureMaps = await db.query('bete' ,where: 'id = ?', whereArgs: [idBd]);
    if (futureMaps.length == 0) {
      debug.log("Bete non trouvéé " + idBd.toString(), name: "LocalBeteRepository::searchBete");
      return null;
    }
    return Bete.fromResult(futureMaps[0]);
  }

  @override
  Future<bool> checkBete(Bete bete) async {
    Database db = await this.database;
    List<Map<String, dynamic>> futureMaps = await db.query('bete' ,where: 'numBoucle = ? and numMarquage = ?',
        whereArgs: [bete.numBoucle, bete.numMarquage]);
    if (futureMaps.length == 0) {
      debug.log("Bete non trouvéé " , name: "BeteRepository::searchBete");
      return false;
    }
    Bete beteBd = Bete.fromResult(futureMaps[0]);
    return  (bete.idBd != beteBd.idBd);
  }

  @override
  Future<List<Bete>> getBetes(String cheptel) async {
    Database db = await this.database;
    //deleteDatabase(join(await getDatabasesPath(), 'gismo_database.db'));
    final Future<List<Map<String, dynamic>>> futureMaps = db.query('bete', where: 'cheptel = ? AND dateSortie IS NULL', whereArgs: [cheptel], orderBy: 'numBoucle');
    //final Future<List<Map<String, dynamic>>> futureMaps = client.query('car', where: 'id = ?', whereArgs: [id]);
    //futureMaps.then(onValue)
    var maps = await futureMaps;
    List<Bete> tempList = [];
    for (int i = 0; i < maps.length; i++) {
      tempList.add(new Bete.fromResult(maps[i]));
    }
    return tempList;
  }

  @override
  Future<Bete?> getMere(Bete bete) async {
    try {
      Database db = await this.database;
      List<Map<String, dynamic>> agneaux = await db.query('agneaux',where: 'devenir_id = ?', whereArgs: [bete.idBd]);
      if (agneaux.isEmpty)
        return null;
      LambModel agneau = new LambModel.fromResult(agneaux[0]);
      final List<Map<String, dynamic>> agnelages = await db.query('agnelage',where: 'id = ?', whereArgs: [ agneau.idAgnelage]);
      if (agnelages.isEmpty)
        return null;
      LambingModel agnelage = new LambingModel.fromResult(agnelages[0]);
      Bete ? mere = await this._searchBete(agnelage.idMere);
      return mere;
    } catch (e,stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //super.bloc.reportError(e, stackTrace);
      throw (e);
    }
  }

  @override
  Future<Bete?> getPere(Bete bete) async {
    try {
      Database db = await this.database;
      List<Map<String, dynamic>> agneaux = await db.query(
          'agneaux', where: 'devenir_id = ?', whereArgs: [bete.idBd]);
      if (agneaux.isEmpty)
        return null;
      LambModel agneau = new LambModel.fromResult(agneaux[0]);
      final List<Map<String, dynamic>> agnelages = await db.query(
          'agnelage', where: 'id = ?', whereArgs: [ agneau.idAgnelage]);
      if (agnelages.isEmpty)
        return null;
      LambingModel agnelage = new LambingModel.fromResult(agnelages[0]);
      if (agnelage.idPere != null) {
        Bete ? pere = await this._searchBete(agnelage.idPere!);
        return pere;
      }
      return null;
    } catch (e,stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //super.bloc.reportError(e, stackTrace);
      throw (e);
    }
 }

  @override
  Future<String> saveBete(Bete bete) async {
    Database db = await this.database;
    int res =   await db.update("bete", bete.toJson(),
        where: "id = ?", whereArgs: <int>[bete.idBd!]);
    return res.toString() + S.current.record_saved;
  }


  @override
  Future<String> saveEntree(String cheptel, DateTime date, String motif, List<Bete> lstBete) async {
    Database db = await this.database;
    Batch batch = db.batch();
    lstBete.forEach((bete) => { _insertEntree(batch, cheptel, date, motif, bete)});
    var results = await batch.commit();
    print(results);
    return S.current.record_saved;
  }

  void _insertEntree(Batch batch, String cheptel, DateTime date, String motif, Bete bete) async {
    //Database db = await this.database;
    bete.cheptel = cheptel;
    bete.motifEntree = motif;
    bete.dateEntree = date;
    batch.insert(
        'bete',
        bete.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<String> saveSortie(DateTime date, String motif, List<Bete> lstBete) async {
    Database db = await this.database;
    Batch batch = db.batch();
    lstBete.forEach((bete) => { _updateSortie(batch, date, motif, bete)});
    var results = await batch.commit();
    print(results);
    return S.current.record_saved;
  }

  void _updateSortie(Batch batch, DateTime date, String motif, Bete bete) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["motifSortie"] = motif;
    data["dateSortie"] = _df.format( date );
    batch.update("bete", data , where: "id = ?", whereArgs: <int>[bete.idBd!]);
  }

  @override
  Future<List<Bete>> getBeliers() async{
    Database db = await this.database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
        'Select * from bete '
            + "WHERE bete.sex = 'male' "
            "AND cheptel = '" + AuthService().cheptel! + "'");
    List<Bete> tempList = [];
    for (int i = 0; i < maps.length; i++) {
      tempList.add(new Bete.fromResult(maps[i]));
    }
    return tempList;
  }

  @override
  Future<List<Bete>> getBrebis() async {
    Database db = await this.database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
        'Select * from bete '
            + "WHERE bete.sex = 'femelle' "
            "AND cheptel = '" + AuthService().cheptel! + "'");
    List<Bete> tempList = [];
    for (int i = 0; i < maps.length; i++) {
      tempList.add(new Bete.fromResult(maps[i]));
    }
    return tempList;
  }

}