import 'package:gismo/model/BeteModel.dart';
import 'dart:developer' as debug;

import 'package:gismo/repository/EntreeRepository.dart';
import 'package:gismo/repository/SortieRepository.dart';
import 'package:gismo/services/AuthService.dart';
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
    return this._repository.save(AuthService().cheptel!, date, motif, betes);
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

  Future<String> saveSortie(String ? dateSortie, String ? motif, List<Bete> betes ) async {
    if (dateSortie == null)
      throw MissingDate();

    if (dateSortie.isEmpty) {
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
    DateTime date = DateFormat.yMd().parse(dateSortie);
    debug.log("Motif " + motif + " date " + date.toString() + " nb Betes " + betes.length.toString(), name: "GismoBloc::saveSortie");
    return await this._repository.save(date, motif, betes);
  }

}

class MissingDate implements Exception {}

class MissingMotif implements Exception {}

class MissingSheeps implements Exception {}