import 'package:flutter_gismo/bloc/ConfigProvider.dart';
import 'package:flutter_gismo/bloc/NavigationService.dart';
import 'package:flutter_gismo/model/EchographieModel.dart';
import 'package:flutter_gismo/repository/EchoRepository.dart';
import 'package:provider/provider.dart';

class EchoService {
  late Echorepository _echoRepository;
  final ConfigProvider _provider = Provider.of<ConfigProvider>(NavigationService.navigatorKey.currentContext!, listen: false);

  EchoService() {
    if (_provider.isSubscribing()) {
       _echoRepository = WebEchoRepository(_provider.getToken());
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