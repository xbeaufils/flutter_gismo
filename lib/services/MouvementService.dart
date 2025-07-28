import 'package:flutter_gismo/model/BeteModel.dart';
import 'dart:developer' as debug;

import 'package:flutter_gismo/repository/EntreeRepository.dart';
import 'package:flutter_gismo/repository/SortieRepository.dart';
import 'package:flutter_gismo/services/AuthService.dart';
import 'package:intl/intl.dart';

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

  Future<String> save(String ?  dateEntree, String ? motif, List<Bete> betes ) async {
    if (dateEntree == null)
      throw MissingDate();
    if (dateEntree.isEmpty) {
      throw MissingDate();
    }

    if ( motif == null) {
      throw MissingMotif();
    }
    if (motif.isEmpty) {
      throw MissingMotif();
    }
    if (betes.length == 0) {
      throw MissingSheeps();
    }
    debug.log("Motif " + motif + " date " + dateEntree + " nb Betes " + betes.length.toString(), name: "GismoBloc::saveEntree");
    DateTime date = DateFormat.yMd().parse(dateEntree);
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

class MissingDate implements Exception {}

class MissingMotif implements Exception {}

class MissingSheeps implements Exception {}