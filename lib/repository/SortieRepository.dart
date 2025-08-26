import 'package:flutter_gismo/core/repository/AbstractRepository.dart';
import 'package:flutter_gismo/core/repository/LocalRepository.dart';
import 'package:flutter_gismo/env/Environnement.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

abstract class SortieRepository {
  Future<String> save(DateTime date, String motif, List<Bete> lstBete);
}

class WebSortieRepository  extends WebRepository  implements SortieRepository {
  final DateFormat _df = new DateFormat('dd/MM/yyyy');

  WebSortieRepository(super.token);

  Future<String> save(DateTime date, String motif, List<Bete> lstBete) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cause'] = motif;
    data['dateSortie'] = _df.format(date);
    data['lstBete'] = lstBete.map((bete) => bete.toJson()).toList();
    try {
      final response = await super.doPostMessage(
          '/bete/sortie', data);
      return response;
    } on GismoException catch(e) {
      throw e;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

}

class LocalSortieRepository extends LocalRepository implements SortieRepository {
  final DateFormat _df = new DateFormat('dd/MM/yyyy');
  @override
  Future<String> save( DateTime date, String motif, List<Bete> lstBete) async {
    Database db = await this.database;
    Batch batch = db.batch();
    lstBete.forEach((bete) =>  _updateSortie(batch, date, motif, bete));
    var results = await batch.commit();
    print(results);
    return "Sortie enregistrée";
  }

  void _updateSortie(Batch batch, DateTime date, String motif, Bete bete) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["motifSortie"] = motif;
    data["dateSortie"] = _df.format( date );
    batch.update("bete", data , where: "id = ?", whereArgs: <int>[bete.idBd!]);
  }

}