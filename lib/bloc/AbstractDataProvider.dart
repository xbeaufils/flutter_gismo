import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/EchographieModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/model/NECModel.dart';
import 'package:flutter_gismo/model/PeseeModel.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';

abstract class DataProvider {
  GismoBloc _bloc;

  GismoBloc get bloc => _bloc;

  DataProvider(this._bloc);
  String get cheptel => this._bloc.user.cheptel;
  String get token => this._bloc.user.token;

  //Future<String> saveLamb(List<LambModel> lambs );
  // Agnelage et agneaux
  Future<String> saveLambing(LambingModel lambing );
  Future<String> saveLamb(LambModel lambing );
  Future<String> deleteLamb(int idBd);
  Future<LambingModel> searchLambing(int idBd);
  Future<List<CompleteLambModel>> getAllLambs(String cheptel);
  Future<List<LambingModel>> getLambs(int idBete) ;
  Future<String> boucler(LambModel lamb, Bete bete);
  Future<void> mort(LambModel lamb, String motif, String date);
  // Bete
  Future<List<Bete>> getBetes(String cheptel) ;
  Future<String> saveBete(Bete bete);
  Future<String> saveSortie(String date, String motif, List<Bete> lstBete);
  Future<String> saveEntree(String cheptel, String date, String motif, List<Bete> lstBete);
  Future<Bete> getMere(Bete bete);
  // Traitement
  Future<String> saveTraitement(TraitementModel traitement);
  Future<String> deleteTraitement(int idBd);
  Future<List<TraitementModel>> getTraitements(Bete bete);
  Future<List<TraitementModel>> getTraitementsForLamb(LambModel lamb);
  Future<TraitementModel> searchTraitement(int idBd);
  // Pesee
  Future<String> savePesee(Pesee pesee);
  Future<List<Pesee>> getPesee(Bete bete);
  Future<List<Pesee>> getPeseeForLamb(LambModel lamb);
  Future<String> deletePesee(int idBd);
  // Echographie
  Future<String> saveEcho(EchographieModel echo);
  Future<EchographieModel> searchEcho(int idBd);
  Future<List<EchographieModel>> getEcho(Bete bete);
  // Note etat corporel
  Future<String> saveNec(NoteModel node);
  Future<List<NoteModel>> getNec(Bete bete);
  // Lots
  Future<List<LotModel>> getLots(String cheptel) ;
  Future<LotModel> saveLot(LotModel lot);
  Future<List<Affectation>>getBrebisForLot(int idLot);
  Future<List<Affectation>>getBeliersForLot(int idLot);
  Future<List<Affectation>>getAffectationForBete(int idBete);
  Future<List<Bete>>getBrebis();
  Future<List<Bete>>getBeliers();
  Future<void> remove(Affectation affect);
  Future<String> addBete(LotModel lot, Bete bete, String dateEntree);
}