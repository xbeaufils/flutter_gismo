import 'package:flutter_gismo/bloc/ConfigProvider.dart';
import 'package:flutter_gismo/bloc/NavigationService.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/PeseeModel.dart';
import 'package:flutter_gismo/repository/PeseeRepository.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class PeseeService {
  late PeseeRepository _repository;
  final ConfigProvider _provider = Provider.of<ConfigProvider>(NavigationService.navigatorKey.currentContext!, listen: false);

  EchoService() {
    if (_provider.isSubscribing()) {
      _repository = WebPeseeRepository(_provider.getToken());
    }
    else {
      _repository = LocalPeseeRepository();
    }
  }

  Future<String> savePesee(Bete bete, double poids, DateTime date ) async {
    try {
      Pesee pesee = new Pesee();
      pesee.bete_id = bete.idBd;
      pesee.datePesee = date;
      pesee.poids = poids;
      return this._repository.savePesee(pesee);
    }
    catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //this.reportError(e, stackTrace);
      return "Une erreur et survenue";
    }
  }

  Future<String> savePeseeLamb(LambModel lamb, double poids, DateTime date ) async {
    try {
      Pesee pesee = new Pesee();
      pesee.lamb_id = lamb.idBd!;
      pesee.datePesee = date;
      pesee.poids = poids;
      return this._repository.savePesee(pesee);
    }
    catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //this.reportError(e, stackTrace);
      return "Une erreur et survenue";
    }
  }

}