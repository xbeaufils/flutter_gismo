import 'package:flutter/material.dart';
import 'package:flutter_gismo/individu/ui/Bete.dart';
import 'package:flutter_gismo/core/device/BluetoothMgr.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/BuetoothModel.dart';
import 'package:flutter_gismo/services/BeteService.dart';
import 'package:flutter_gismo/services/BluetoothService.dart';
import 'package:intl/intl.dart';

class BetePresenter extends ChangeNotifier {

  final BeteContract _view;
  final BeteService _service = BeteService();
  final BluetoothService _bluetoothService = BluetoothService();
  BetePresenter(this._view);

  void save(String ? numBoucle, String ? numMarquage, Sex ? sex, String ? nom, String ? obs, String dateEntree, String ? motif) async {
    if (numBoucle == null) {
      throw MissingNumBoucle();
    }
    if (numBoucle.isEmpty){
      throw MissingNumBoucle();
    }
    if (numMarquage == null){
      throw MissingNumMarquage();
    }
    if (numMarquage.isEmpty){
      throw MissingNumMarquage();
    }
    if (sex == null){
      throw MissingSex();
    }
    bool _existant = false;
    if (this._view.bete == null) {
      this._view.bete = new Bete(
          null, numBoucle, numMarquage, nom, obs, DateFormat.yMd().parse(dateEntree), sex, motif);
      _existant = await _service.check(this._view.bete!);
    }
    else {
      this._view.bete!.numBoucle = numBoucle;
      this._view.bete!.numMarquage = numMarquage;
      this._view.bete!.nom = nom;
      this._view.bete!.observations = obs;
      this._view.bete!.dateEntree =  DateFormat.yMd().parse(dateEntree);
      this._view.bete!.sex = sex;
      if (motif != null)
        this._view.bete!.motifEntree = motif;
      _existant = await _service.check(this._view.bete!);
      if (! _existant)
        _service.save(this._view.bete!);
    }
    if (! _existant)
      this._view.backWithBete();
    else
      throw ExistingBete();

  }

  Future<BluetoothState> startReadBluetooth() {
    return _bluetoothService.startReadBluetooth();
  }

  void stopBluetooth() {
    _bluetoothService.stopBluetooth();
  }

  void stopReadBluetooth() {
    _bluetoothService.startReadBluetooth();
  }
}

class MissingNumBoucle implements Exception {}

class MissingNumMarquage implements Exception {}

class MissingSex implements Exception {}

class ExistingBete implements Exception {}