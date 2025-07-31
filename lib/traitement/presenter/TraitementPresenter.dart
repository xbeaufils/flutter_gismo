import 'package:flutter_gismo/model/TraitementModel.dart';
import 'package:flutter_gismo/services/TraitementService.dart';
import 'package:flutter_gismo/traitement/ui/Sanitaire.dart';
import 'package:intl/intl.dart';

class TraitementPresenter {
  SanitaireContract _view;
  final TraitementService _service = TraitementService();

  TraitementPresenter(this._view);

  void delete () async {
    if (this._view.currentTraitement != null) {
      var message  = await _service.deleteTraitement(this._view.currentTraitement!.idBd!);
      this._view.backWithMessage(message);
    }
    else
      this._view.back();
  }

  void save(String debut, String fin, String dose, String intervenant, String observation, String motif, String medicament, String ordonnance, String rythme, String voie) async {
    TraitementModel traitement = new TraitementModel();
    if (this._view.currentTraitement != null) {
      traitement.idBete = this._view.currentTraitement?.idBete;
      traitement.idBd = this._view.currentTraitement?.idBd;
    }
    else {
      if (this._view.malade != null)
        traitement.idBete = this._view.malade!.idBd;
      if (this._view.bebeMalade != null)
        traitement.idLamb = this._view.bebeMalade!.idBd;
    }
    traitement.debut = DateFormat.yMd().parse(debut);
    traitement.dose = dose;
    traitement.fin = DateFormat.yMd().parse(fin);
    traitement.intervenant= intervenant;
    traitement.observation = observation;
    traitement.motif =motif;
    traitement.medicament = medicament;
    traitement.ordonnance = ordonnance;
    traitement.rythme = rythme;
    traitement.voie = voie;
    var message = "";
    if (this._view.betes != null)
      message = await _service.saveTraitementCollectif(traitement, this._view.betes!);
    else
      message  = await _service.saveTraitement(traitement);
    this._view.backWithMessage(message);

  }

}