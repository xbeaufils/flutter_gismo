import 'package:flutter_gismo/core/repository/AbstractRepository.dart';
import 'package:flutter_gismo/env/Environnement.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/copro.dart';

abstract class CoproRepository {
  Future<List<Prelevement>> getPrelevementsForBete(Bete bete);
  Future<List<Prelevement>> getPrelevementsForCheptel(String cheptel);
  Future<Prelevement> getPrelevement(int idCopro);
  Future<String> save(Prelevement copro);
}

class WebCoproRepository extends WebRepository implements CoproRepository {

  WebCoproRepository(super.token);

  Future<List<Prelevement>> getPrelevementsForBete(Bete bete)  async {
    try {
      final response = await super.doGetList(
          '/copro/bete/' + bete.idBd.toString());
      List<Prelevement> tempList = [];
      response.forEach((element) {
        tempList.add(new Prelevement.fromResult(element)); });
      return tempList;
    }catch (e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }
  Future<List<Prelevement>> getPrelevementsForCheptel(String cheptel)  async {
    try {
      final response = await super.doGetList(
          '/copro/cheptel/' + cheptel);
      List<Prelevement> tempList = [];
      response.forEach((element) {
        tempList.add(new Prelevement.fromResult(element)); });
      return tempList;
    }catch (e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  Future<Prelevement> getPrelevement(int idCopro)  async {
    try {
      final response = await super.doGet(
        '/copro/get/' + idCopro.toString());
      return new Prelevement.fromResult(response);
    }catch (e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }
  Future<String> save(Prelevement copro) async{
    return await super.doPostMessage('/copro/save', copro);
    throw UnimplementedError();

  }
}