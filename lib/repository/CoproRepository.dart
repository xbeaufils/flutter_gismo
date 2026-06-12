import 'package:flutter_gismo/core/repository/AbstractRepository.dart';
import 'package:flutter_gismo/env/Environnement.dart';
import 'package:flutter_gismo/model/copro.dart';

abstract class CoproRepository {
  Future<List<Prelevement>> getPrelevements();
}

class WebCoproRepository extends WebRepository implements CoproRepository {

  WebCoproRepository(super.token);

  Future<List<Prelevement>> getPrelevements()  async {
    try {
      final response = await super.doGetList(
          '/copro/prelevements');
      List<Prelevement> tempList = [];
      response.forEach((element) {
        tempList.add(new Prelevement.fromResult(element)); });
      return tempList;
    }catch (e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }
}