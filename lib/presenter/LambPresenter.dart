import 'dart:async';

import 'package:flutter_gismo/lamb/Bouclage.dart';
import 'package:flutter_gismo/lamb/LambPage.dart';
import 'package:flutter_gismo/lamb/Mort.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/services/LambingService.dart';
import 'package:flutter_gismo/generated/l10n.dart';

class LambPresenter {
  final LambContract _view;
  final LambingService service = LambingService();
  LambPresenter(this._view);

  void boucle(LambModel lamb) async {
    Bete ? bete = await this._view.showBouclage(lamb);
    if (bete != null) {
      this.service.boucler(lamb, bete);
      if (bete.idBd != null)
        lamb.idDevenir = bete.idBd;
      lamb.numBoucle = bete.numBoucle;
      lamb.numMarquage = bete.numMarquage;
    }

  }

  void mort(LambModel lamb) {
    this._view.showDeath(lamb);
  }
}

class BouclagePresenter {

  final BouclageContract _view;

  BouclagePresenter(this._view);

  void createBete(LambModel lamb, String numBoucle, String numMarquage) async {
    lamb.numMarquage = numMarquage;
    lamb.numBoucle = numBoucle;
    Bete bete = new Bete(null, numBoucle, numMarquage, null, null, null, lamb.sex, 'NAISSANCE');
    this._view.returnBete(bete);
    //Navigator.pop(context, bete);
  }

}

class DeathPresenter {
  final LambingService _service = LambingService();
  final MortContract _view;

  DeathPresenter(this._view);

  Future<String> saveDeath(LambModel lamb, String dateMort, String? motif) async {
    try {
      return this._save(lamb, dateMort, motif);
    }
    on MissingDeathDateException {
      this._view.showError(S.current.no_death_date);
    }
    on MissingMotifException {
      this._view.showError(S.current.death_cause_mandatory);
    }
    throw Exception();
  }

  Future<String> _save(LambModel lamb, String dateMort, String? motif) async {
    if (dateMort.isEmpty) {
      _view.showError(S.current.no_death_date);
      throw MissingDeathDateException();
    }

    if (motif == null) {
      throw MissingMotifException();
    }
    if (motif.isEmpty) {
      throw MissingMotifException();
    }
    String message  = await this._service.mort(lamb, motif, dateMort);
    return message;
  }

}

class MissingDeathDateException implements Exception {}
class MissingMotifException implements Exception {}