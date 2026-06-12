import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/copro.dart';
import 'package:flutter_gismo/repository/CoproRepository.dart';
import 'package:flutter_gismo/services/AuthService.dart';

class CoproService {

  late CoproRepository _repository;

  Future<void> save(Prelevement copro) async {
    _repository.save(copro);
  }

  Future<List<Prelevement>> getPrelevementsForCheptel()  async {
    return _repository.getPrelevementsForCheptel(AuthService().cheptel!);
  }

  Future<List<Prelevement>> getPrelevementsForBete(Bete bete)  async {
    return _repository.getPrelevementsForBete(bete);
  }
  Future<Prelevement> getPrelevement(int idCopro) {
    return _repository.getPrelevement(idCopro);
  }

  Future<String> delete(Prelevement prelevement) async {
    return "";
  }

  CoproService() {
      _repository = WebCoproRepository(AuthService().token);
  }
}