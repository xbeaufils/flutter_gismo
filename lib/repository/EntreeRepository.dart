
import 'package:gismo/env/Environnement.dart';
import 'package:gismo/model/BeteModel.dart';
import 'package:gismo/core/repository/AbstractRepository.dart';
import 'package:gismo/core/repository/LocalRepository.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

abstract class EntreeRepository {
  Future<String> save(String cheptel, DateTime date, String motif, List<Bete> lstBete);
}

class WebEntreeRepository  extends WebRepository  implements EntreeRepository {
  final DateFormat _df = new DateFormat('dd/MM/yyyy');
  WebEntreeRepository(super.token);

  @override
  Future<String> save(String cheptel, DateTime date, String motif, List<Bete> lstBete) async {
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

}

class LocalEntreeRepository extends LocalRepository implements EntreeRepository {

  Future<String> save(String cheptel, DateTime date, String motif, List<Bete> lstBete) async {
    Database db = await this.database;
    Batch batch = db.batch();
    lstBete.forEach((bete) =>  _insertEntree(batch, cheptel, date, motif, bete));
    var results = await batch.commit();
    print(results);
    return "Entrée enregistrée";
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

}