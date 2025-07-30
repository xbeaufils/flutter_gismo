import 'package:gismo/model/EchographieModel.dart';
import 'package:gismo/repository/EchoRepository.dart';
import 'package:gismo/services/AuthService.dart';

class EchoService {
  late Echorepository _echoRepository;

  EchoService() {
    if (AuthService().subscribe ) {
       _echoRepository = WebEchoRepository(AuthService().token);
    }
    else {
      _echoRepository = LocalEchoRepository();
    }
  }

  Future<String> delete(EchographieModel echo) async {
    return this._echoRepository.deleteEcho(echo);
  }

  Future<String> save(EchographieModel echo) async {
    return this._echoRepository.saveEcho(echo);
  }
}