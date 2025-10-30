import 'package:flutter/material.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';
import 'package:flutter_gismo/services/TraitementService.dart';
import 'package:flutter_gismo/traitement/Medic.dart';
import 'package:flutter_gismo/traitement/ui/Sanitaire.dart';
import 'package:intl/intl.dart';

class TraitementPresenter {
  SanitaireContract _view;
  final TraitementService _service = TraitementService();

  TraitementPresenter(this._view);

  void delete () async {
    if (this._view is ModifySanitairePageState) {
      ModifySanitaireContract viewModify = this._view as ModifySanitaireContract;
      if (viewModify.currentTraitement != null) {
        var message = await _service.deleteTraitement(
            viewModify.currentTraitement!.idBd!);
        viewModify.backWithMessage(S.current.record_saved);
      }
      else
        this._view.back();
    }
  }

  void edit(MedicModel medic) {

  }

  void add(BuildContext context) async {
    MedicModel ? newMedic = await Navigator.push(context, MaterialPageRoute( builder: (context) => MedicPage(),),);
    if (newMedic == null) return;
    MultipleSanitaireContract multipleView = this._view as MultipleSanitaireContract;
    multipleView.add(newMedic);
  }


  void saveModify(String debut, String fin, String dose, String intervenant, String observation, String motif, String medicament, String ordonnance, String rythme, String voie) async {
    ModifySanitaireContract modifyView = this._view as ModifySanitaireContract;
    TraitementModel traitement = this._save(debut, fin, intervenant, observation, motif, ordonnance);
    traitement.medic!.dose = dose;
    traitement.medic!.medicament = medicament;
    traitement.medic!.voie = voie;
    traitement.medic!.rythme = rythme;
    traitement.idBete = modifyView.currentTraitement?.idBete;
    traitement.idBd = modifyView.currentTraitement?.idBd;
    await this._service.saveTraitement(traitement);
    this._view.backWithMessage(S.current.record_saved);
  }

  void saveMultiple(String debut, String fin, String intervenant, String observation, String motif, String ordonnance) async {
    MultipleSanitaireContract multipleView = this._view as MultipleSanitaireContract;
    TraitementModel traitement = this._save(debut, fin, intervenant, observation, motif, ordonnance);
    String message = "";
    if (multipleView.betes != null && multipleView.medics != null)
      message = await _service.saveTraitementCollectif(traitement, multipleView.medics!, multipleView.betes!);
    this._view.backWithMessage(S.current.record_saved);
  }

  void saveLamb(String debut, String fin, String dose, String intervenant, String observation, String motif, String medicament, String ordonnance, String rythme, String voie) async {
    LambSanitaireContract lambView = this._view as LambSanitaireContract;
    TraitementModel traitement = this._save(debut, fin, intervenant, observation, motif, ordonnance);
    traitement.medic!.dose = dose;
    traitement.medic!.medicament = medicament;
    traitement.medic!.voie = voie;
    traitement.medic!.rythme = rythme;
    traitement.idLamb = lambView.bebeMalade!.idBd;
    String message = "";
    message = await _service.saveTraitement(traitement);
  }

  TraitementModel _save(String debut, String fin, String intervenant, String observation, String motif, String ordonnance)  {
    TraitementModel traitement = new TraitementModel();
    traitement.debut = DateFormat.yMd().parse(debut);
    traitement.fin = DateFormat.yMd().parse(fin);
    traitement.intervenant= intervenant;
    traitement.observation = observation;
    traitement.motif =motif;
    traitement.ordonnance = ordonnance;
    return traitement;
  }

}