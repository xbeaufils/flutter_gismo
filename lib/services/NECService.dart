import 'package:gismo/model/BeteModel.dart';
import 'package:gismo/model/NECModel.dart';
import 'package:gismo/repository/NecRepository.dart';
import 'package:gismo/services/AuthService.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class NECService {
  late NecRepository _repository;

  NECService() {
    if (AuthService().subscribe ) {
      _repository = WebNecRepository(AuthService().token);
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