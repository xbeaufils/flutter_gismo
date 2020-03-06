import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/model/NECModel.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';

abstract class DataProvider {

  //Future<String> saveLamb(List<LambModel> lambs );
  Future<String> saveLambing(LambingModel lambing );
  Future<List<Bete>> getBetes(String cheptel) ;
  Future<String> saveBete(Bete bete);
  Future<List<LambingModel>> getLambs(int idBete) ;
  Future<String> saveSortie(String date, String motif, List<Bete> lstBete);
  Future<String> saveEntree(String cheptel, String date, String motif, List<Bete> lstBete);
  Future<String> saveTraitement(TraitementModel traitement);
  Future<List<TraitementModel>> getTraitements(Bete bete);
  Future<String> boucler(LambModel lamb, Bete bete);
  Future<LambingModel> searchLambing(int idBd);
  Future<TraitementModel> searchTraitement(int idBd);
  Future<void> mort(LambModel lamb, String motif, String date);
  Future<String> saveNec(NoteModel node);
  Future<List<NoteModel>> getNec(Bete bete);
  Future<List<LotModel>> getLots(String cheptel) ;
  Future<List<Bete>>getBrebis(int idLot);
  Future<List<Bete>>getBeliers(int idLot);
  Future<void> affect(LotModel lot, Bete bete);
  Future<void> remove(LotModel lot, Bete bete);
}