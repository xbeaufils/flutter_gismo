
import 'package:flutter_gismo/Exception/EventException.dart';
import 'package:flutter_gismo/bloc/AbstractDataProvider.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/bloc/LocalDataProvider.dart';
import 'package:flutter_gismo/bloc/WebDataProvider.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/EchographieModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/model/NECModel.dart';
import 'package:flutter_gismo/model/PeseeModel.dart';
import 'package:flutter_gismo/model/SaillieModel.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';

enum RepositoryType {web, local}
class GismoRepository {
  late DataProvider _dataProvider;
  final GismoBloc _bloc;
  DataProvider get dataProvider => _dataProvider;

  GismoRepository(this._bloc, RepositoryType type) {
    //_dataProvider = DummyDataProvider(_bloc);
    switch (type) {
      case RepositoryType.web :
        _dataProvider = new WebDataProvider(_bloc);
        break;
      case RepositoryType.local:
        _dataProvider =  new LocalDataProvider(_bloc);
        //( _dataProvider as LocalDataProvider).init();
        break;
    }
  }

}

class DummyDataProvider extends DataProvider {

  DummyDataProvider(GismoBloc bloc):super(bloc){}

  @override
  Future<String> saveLambing(LambingModel lambing) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<String> addBete(LotModel lot, Bete bete, String dateEntree) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<String> remove(Affectation affect) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<List<Bete>> getBeliers() {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<List<Bete>> getBrebis() {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<List<Affectation>> getAffectationForBete(int idBete) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<List<Affectation>> getBeliersForLot(int idLot) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<List<Affectation>> getBrebisForLot(int idLot) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<LotModel> saveLot(LotModel lot) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<List<LotModel>> getLots(String cheptel) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<List<NoteModel>> getNec(Bete bete) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<String> saveNec(NoteModel node) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<List<EchographieModel>> getEcho(Bete bete) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<EchographieModel> searchEcho(int idBd) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<String> saveEcho(EchographieModel echo) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<String> saveSaillie(SaillieModel echo) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<List<SaillieModel>> getSaillies(Bete bete) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<String> deletePesee(int idBd) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<List<Pesee>> getPeseeForLamb(LambModel lamb) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<List<Pesee>> getPesee(Bete bete) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<String> savePesee(Pesee pesee) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<TraitementModel> searchTraitement(int idBd) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<List<TraitementModel>> getTraitementsForLamb(LambModel lamb) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<List<TraitementModel>> getTraitements(Bete bete) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<String> deleteTraitement(int idBd) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<String> saveTraitementCollectif(TraitementModel traitement,
      List<Bete> betes) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<String> saveTraitement(TraitementModel traitement) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<Bete> getMere(Bete bete) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<String> saveEntree(String cheptel, String date, String motif,
      List<Bete> lstBete) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<String> saveSortie(String date, String motif, List<Bete> lstBete) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<String> saveBete(Bete bete) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<List<Bete>> getBetes(String cheptel) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<Function> mort(LambModel lamb, String motif, String date) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<String> boucler(LambModel lamb, Bete bete) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<List<LambingModel>> getLambs(int idBete) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<List<CompleteLambModel>> getAllLambs(String cheptel) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<LambingModel> searchLambing(int idBd) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<String> deleteLamb(int idBd) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<String> saveLamb(LambModel lambing) {
    throw RepositoryTypeException("Type de repository inconnue");
  }

  @override
  Future<String> deleteAffectation(Affectation affect) {
    // TODO: implement deleteAffectation
    throw UnimplementedError();
  }

  @override
  Future<bool> checkBete(Bete bete) {
    // TODO: implement checkBete
    throw RepositoryTypeException("Type de repository inconnue");
  }
}