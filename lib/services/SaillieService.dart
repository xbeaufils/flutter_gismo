import 'package:flutter_gismo/bloc/ConfigProvider.dart';
import 'package:flutter_gismo/bloc/NavigationService.dart';
import 'package:flutter_gismo/model/SaillieModel.dart';
import 'package:flutter_gismo/repository/SaillieRepository.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SaillieService {
  late SaillieRepository _repository;
  final ConfigProvider _provider = Provider.of<ConfigProvider>(NavigationService.navigatorKey.currentContext!, listen: false);

  SaillieService() {
    if (_provider.isSubscribing()) {
      _repository = WebSaillieRepository(_provider.getToken());
    }
    else {
      _repository = LocalSaillieRepository();
    }
  }

  Future<String> saveSaillie(SaillieModel saillie) async {
    try {
      return this._repository.saveSaillie(saillie);
    }
    catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      return "Une erreur est survenue";
    }
  }

}