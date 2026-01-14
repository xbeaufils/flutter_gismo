import 'dart:developer' as debug;

import 'package:flutter/foundation.dart';
import 'package:flutter_gismo/core/repository/AbstractRepository.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/individu/ui/Bete.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/BuetoothModel.dart';
import 'package:flutter_gismo/model/StatusBluetooth.dart';
import 'package:flutter_gismo/services/BeteService.dart';
import 'package:flutter_gismo/services/BluetoothService.dart';
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class BetePresenter {

  final BeteContract _view;
  final BeteService _service = BeteService();
  final BluetoothGismoService _blService = BluetoothGismoService();
  BetePresenter(this._view);

  Future<void> add (String ? numBoucle, String ? numMarquage, Sex ? sex, String ? nom, String ? obs, String dateEntree, String ? motif) async {
    if (numBoucle == null) {
      this._view.showMessage(S.current.identity_number_warn, true);
      return;
    }
    if (numBoucle.isEmpty){
      this._view.showMessage(S.current.identity_number_warn, true);
      return;
    }
    if (numMarquage == null){
      this._view.showMessage(S.current.flock_number_warn, true);
      return;
    }
    if (numMarquage.isEmpty){
      this._view.showMessage(S.current.flock_number_warn, true);
      return;
    }
    if (sex == null){
      this._view.showMessage(S.current.sex_warn, true);
      return;
    }
    Bete newBete =  Bete( null, numBoucle, numMarquage, nom, obs, DateFormat.yMd().parse(dateEntree), sex, motif);
    bool existant = await this._service.check(newBete);
    if (existant)
      this._view.showMessage(S.current.identity_number_error, true);
    else {
      this._view.bete = newBete;
      this._view.backWithBete();
    }
  }

  Future<String?> save(String ? numBoucle, String ? numMarquage, Sex ? sex, String ? nom, String ? obs, String dateEntree, String ? motif) async {
    Bete newBete =  Bete(this._view.bete==null ? null: this._view.bete?.idBd, numBoucle, numMarquage, nom, obs, DateFormat.yMd().parse(dateEntree), sex, motif);
    try {
      String message = await _service.save(newBete);
      if (this._view.bete != null) {
        this._view.bete!.numBoucle = numBoucle!;
        this._view.bete!.numMarquage = numMarquage!;
        this._view.bete!.sex = sex!;
        this._view.bete!.observations = obs;
        this._view.backWithBete();
      }
      return message;
    } on GismoException catch(e) {
      this._view.showMessage(e.message, true);
    } on MissingNumBoucle {
      this._view.showMessage(S.current.identity_number_warn, true);
    } on MissingNumMarquage {
      this._view.showMessage(S.current.flock_number_warn, true);
    } on MissingSex {
      this._view.showMessage(S.current.sex_warn, true);
    } on ExistingBete {
      this._view.showMessage(S.current.identity_number_error, true);
    }
    return null;
  }

  Future<void> startReadBluetooth() async {
    try {
      StatusBlueTooth status =  await _blService.startReadBluetooth();
      if (status.connectionStatus == 'CONNECTED') {
        await this._blService.readBluetooth();
        this._blService.handleData(this.handleBlueTooth);
      }
    } on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      debug.log(e.toString());
    }

  }

  void handleBlueTooth(StatusBlueTooth event) {
    if ( event.connectionStatus != null)
      debug.log("Status " + event.connectionStatus!, name: "BetePresenter::handleBlueTooth");
    if (this._view.bluetoothState.dataStatus != event.dataStatus
        || this._view.bluetoothState.connectionStatus != event.dataStatus ) {
      if(event.connectionStatus == 'NONE')
        return;
      if (event.dataStatus == 'AVAILABLE') {
        String _foundBoucle = event.data!;
        if (_foundBoucle.length > 15)
          _foundBoucle = _foundBoucle.substring(_foundBoucle.length - 15);
        this._view.updateBoucle(_foundBoucle);
      }
      this._view.bluetoothState = event;
    }
  }

  void stopReadBluetooth() {
    if ((defaultTargetPlatform == TargetPlatform.android)) {
      _blService.stopReadBluetooth();
    }
  }
}

class MissingNumBoucle implements Exception {}

class MissingNumMarquage implements Exception {}

class MissingSex implements Exception {}

class ExistingBete implements Exception {}