import 'package:flutter_gismo/bloc/ConfigProvider.dart';
import 'package:flutter_gismo/bloc/NavigationService.dart';
import 'package:flutter_gismo/model/EchographieModel.dart';
import 'package:flutter_gismo/repository/EchoRepository.dart';
import 'package:flutter_gismo/services/AuthService.dart';
import 'package:provider/provider.dart';

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