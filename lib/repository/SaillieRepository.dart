import 'dart:developer' as debug;
import 'package:flutter_gismo/env/Environnement.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/SaillieModel.dart';
import 'package:flutter_gismo/core/repository/AbstractRepository.dart';
import 'package:flutter_gismo/core/repository/LocalRepository.dart';
import 'package:sentry/sentry.dart';
import 'package:sqflite/sqflite.dart';

abstract class SaillieRepository {
  Future<String> saveSaillie(SaillieModel saillie);
  Future<List<SaillieModel>> getSaillies(Bete bete);
  Future<String> deleteSaillie(int idBd);
}

class WebSaillieRepository extends WebRepository implements SaillieRepository {

  WebSaillieRepository(super.token);

  @override
  Future<String> saveSaillie(SaillieModel saillie) async{
    try {
      final response = await super.doPostMessage(
          '/saillie/new',  saillie.toJson());
      return response;
    } on GismoException catch(e) {
      throw e;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  @override
  Future<List<SaillieModel>> getSaillies(Bete bete) async {
    String ? sex;
    if (bete.sex == Sex.male)
      sex = "male";
    else
      sex = "femelle";
    final response = await super.doGetList(
        '/saillie/'+ sex + '/' + bete.idBd.toString());
    List<SaillieModel> tempList = List.empty(growable: true);
    for (int i = 0; i < response.length; i++) {
      tempList.add(new SaillieModel.fromResult(response[i]));
    }
    return tempList;
    //throw RepositoryTypeException("Not implemented");
  }

  @override
  Future<String> deleteSaillie(int idBd) async {
    try {
      final response = await super.doGet('/saillie/del/' + idBd.toString());
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

class LocalSaillieRepository extends LocalRepository implements SaillieRepository {
  @override
  Future<String> saveSaillie(SaillieModel saillie) async {
    try {
      Database db = await this.database;
      await db.insert('saillie', saillie.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      return "Enregistrement de la saillie";
    }
    catch(e,stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //super.bloc.reportError(e, stackTrace);
    }
    return "Erreur d'enregistrement";
  }

  @override
  Future<String> deleteSaillie(int idBd) async {
    Database db = await this.database;
    int res =   await db.delete("saillie",
        where: "idBd = ?", whereArgs: <int>[idBd]);
    return "Suppression effectuée";
  }

  @override
  Future<List<SaillieModel>> getSaillies(Bete bete) async {
    List<SaillieModel> tempList = [];
    String sqlCritere;
    if (bete.sex == Sex.male)
      sqlCritere = 'and idPere=?';
    else
      sqlCritere = 'and idMere=?';
    try {
      Database db = await this.database;
      List<Map<String, dynamic>> saillies  = await db.rawQuery(
          'select saillie.*,'
              'mere.numBoucle as numBoucleMere, mere.numMarquage as numMarquageMere,'
              'pere.numBoucle as numBouclePere, pere.numMarquage as numMarquagePere '
              'from saillie '
              'cross join bete mere '
              'cross join bete pere '
              'where saillie.idMere = mere.id '
              'and saillie.idPere = pere.id '
              + sqlCritere,
          [bete.idBd!]);
      for (int j = 0; j < saillies.length; j++) {
        SaillieModel lamb = SaillieModel.fromResult(saillies[j]);
        tempList.add(lamb);
      }
    } catch (e,stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //super.bloc.reportError(e, stackTrace);
    }
    return tempList;
  }


}