import 'package:flutter_gismo/bloc/ConfigProvider.dart';
import 'package:flutter_gismo/bloc/NavigationService.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/NECModel.dart';
import 'package:flutter_gismo/repository/NecRepository.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class NECService {
  late NecRepository _repository;
  final ConfigProvider _provider = Provider.of<ConfigProvider>(NavigationService.navigatorKey.currentContext!, listen: false);

  NECService() {
    if (_provider.isSubscribing()) {
      _repository = WebNecRepository(_provider.getToken());
    }
    else {
      _repository = LocalNecRepository();
    }
  }

  Future<String> saveNec(Bete bete, NEC nec, DateTime date) async{
    try {
      //await Future.delayed(Duration(seconds: 3), () => print('Large Latte'));
      NoteModel note = new NoteModel();
      note.note = nec.note;
      note.date = date;
      note.idBete = bete.idBd!;
      return await this._repository.save(note);

    }
    catch(e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //this.reportError(e, stackTrace);
      return "Une erreur est survenue";
    }
  }

}