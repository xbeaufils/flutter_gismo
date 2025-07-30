import 'package:gismo/model/SaillieModel.dart';
import 'package:gismo/repository/SaillieRepository.dart';
import 'package:gismo/services/AuthService.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SaillieService {
  late SaillieRepository _repository;

  SaillieService() {
    if (AuthService().subscribe)  {
      _repository = WebSaillieRepository(AuthService().token);
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