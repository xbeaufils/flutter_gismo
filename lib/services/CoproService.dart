import 'package:flutter_gismo/model/copro.dart';
import 'package:flutter_gismo/repository/CoproRepository.dart';
import 'package:flutter_gismo/services/AuthService.dart';

class CoproService {

  late CoproRepository _repository;

  Future<List<Prelevement>> getPrelevements()  async {
    return _repository.getPrelevements();
  }

  Future<String> delete(Prelevement prelevement) async {
    return "";
  }

  CoproService() {
      _repository = WebCoproRepository(AuthService().token);
  }
}