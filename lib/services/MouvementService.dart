import 'package:flutter_gismo/model/BeteModel.dart';
import 'dart:developer' as debug;

import 'package:flutter_gismo/repository/EntreeRepository.dart';
import 'package:flutter_gismo/repository/SortieRepository.dart';
import 'package:flutter_gismo/services/AuthService.dart';

class EntreeService {
  late EntreeRepository _repository;

  EntreeService() {
    if (AuthService().subscribe ) {
      _repository = WebEntreeRepository(AuthService().token);
    }
    else  {
      _repository = LocalEntreeRepository();
    }
  }

  Future<String> save(DateTime date, String motif, List<Bete> betes ) async {
    debug.log("Motif " + motif + " date " + date.toString() + " nb Betes " + betes.length.toString(), name: "GismoBloc::saveEntree");
    this._repository.save(AuthService().cheptel!, date, motif, betes);
    return "OK";
  }

}

class SortieService {
  late SortieRepository _repository;

  SortieService() {
    if (AuthService().subscribe)
      _repository = WebSortieRepository(AuthService().token);
    else
      _repository = LocalSortieRepository();
  }

  Future<String> saveSortie(DateTime date, String motif, List<Bete> betes ) async {
    debug.log("Motif " + motif + " date " + date.toString() + " nb Betes " + betes.length.toString(), name: "GismoBloc::saveSortie");
    this._repository.save(date, motif, betes);
    return "Enregistrement effectué";
  }

}