import 'dart:async';
import 'dart:developer' as debug;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/core/device/BluetoothMgr.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/individu/ui/EchoPage.dart';
import 'package:flutter_gismo/individu/ui/NECPage.dart';
import 'package:flutter_gismo/individu/ui/PeseePage.dart';
import 'package:flutter_gismo/individu/ui/SailliePage.dart';
import 'package:flutter_gismo/individu/ui/TimeLine.dart';
import 'package:flutter_gismo/lamb/ui/lambing.dart';
import 'package:flutter_gismo/memo/ui/MemoPage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/BuetoothModel.dart';
import 'package:flutter_gismo/search/ui/SearchPage.dart';
import 'package:flutter_gismo/services/BeteService.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

enum mode{typing, ready}

class SearchPresenter {

  final SearchContract _view;
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";

  List<Bete> _filteredBetes = <Bete>[];
  List<Bete> _betes = <Bete>[];
  BeteService _service = BeteService();
  BluetoothManager _mgr = BluetoothManager();
  StreamSubscription<BluetoothState> ? _bluetoothSubscription;

  SearchPresenter(this._view){
    _filter.addListener(() =>this.filtre());
  }

  void filtre() {
    String searchText = _filter.text;
    _filteredBetes.clear();
    if (searchText.isNotEmpty) {
      for (int i = 0; i < _betes.length; i++) {
        if (_betes[i].numBoucle.toLowerCase().contains(
            searchText.toLowerCase())) {
          _filteredBetes.add(_betes[i]);
        }
      }

    } else {
      _filteredBetes.addAll(_betes);
    }
    this._view.filteredBetes = _filteredBetes;
  }

  mode _mode = mode.ready;

  void getBetes(Sex ? searchSex) async {
    if (searchSex == null) {
      _betes = await this._service.getBetes();
    }
    else {
      switch (searchSex) {
        case Sex.femelle:
          _betes = await this._service.getBrebis();
          break;
        case Sex.male :
          _betes = await this._service.getBeliers();
          break;
        default :
          _betes = await this._service.getBetes();
      }
    }
    _filteredBetes.addAll(_betes);
    //this._view.betes = _betes;
    this._view.filteredBetes = _betes;
  }

  void buildSearchBar() {
    if (this._mode == mode.typing) {
      this._view.toggleSearchBar(Icon(Icons.close),
          TextField(
            autofocus: true,
            controller: _filter,
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
                prefixIcon: new Icon(Icons.search),
                hintText: S.current.earring
            ),
          ));
    } else {
      this._view.toggleSearchBar(Icon(Icons.search), Text( S.current.earring_search ));
    }

  }

  void searchPressed() {
      if (this._mode == mode.ready) {
        _mode = mode.typing;
        this.buildSearchBar();
      } else {
        _mode = mode.ready;
        _filteredBetes = this._betes;
        _filter.clear();
        this.buildSearchBar();
      }
  }

  void selectBete(Bete bete) async {
    StatefulWidget ? page;
    switch (this._view.nextPage) {
      case GismoPage.lamb:
        page = LambingPage(bete);
        break;
    /*case GismoPage.sanitaire:
        page = SanitairePage(this._bloc, bete, null);
        break; */
      case GismoPage.individu:
        page = TimeLinePage( bete);
        break;
      case GismoPage.etat_corporel:
        page = NECPage( bete);
        break;
      case GismoPage.pesee:
        page = PeseePage( bete, null);
        break;
      case GismoPage.echo:
        page = EchoPage(bete);
        break;
      case GismoPage.saillie:
        page = SailliePage(bete);
        break;
      case GismoPage.note:
        page = MemoPage(bete);
        break;
      case GismoPage.sortie:
      case GismoPage.lot:
      case GismoPage.sailliePere:
      case GismoPage.sanitaire:
        page = null;
        break;
    }

    if (page  == null) {
      this._view.goPreviousPage(bete);
      //Navigator.of(context).pop(bete);
    }
    else {
      String ? message = await this._view.goNextPage(page);
      if (message != null)
        this._view.showMessage(message);
    }
  }

  Future<void> startService() async{
    try {
      debug.log("Start service ", name: "_SearchPageState::_startService");
      BluetoothState _bluetoothState = BluetoothState.fromResult(null); //await this._bloc.startReadBluetooth();
      if (_bluetoothState.status != null)
        debug.log("Start status " + _bluetoothState.status!, name: "_SearchPageState::_startService");
      if (_bluetoothState.status == BluetoothManager.CONNECTED
          || _bluetoothState.status == BluetoothManager.STARTED) {
        Stream<BluetoothState> bluetoothStream = this._mgr.streamReadBluetooth();
        this._bluetoothSubscription = bluetoothStream.listen(
                (BluetoothState event) {
              if ( event.status != null)
                debug.log("Status " + event.status!, name: "_SearchPageState::_startService");
              if (this._view.bluetoothState != event.status)
                //setState(() {
                  this._view.bluetoothState = event.status!;
                  if (event.status == 'AVAILABLE') {
                    String _foundBoucle = event.data!;
                    if (_foundBoucle.length > 15)
                      _foundBoucle =
                          _foundBoucle.substring(_foundBoucle.length - 15);
                    _foundBoucle =
                        _foundBoucle.substring(_foundBoucle.length - 5);
                    this._view.setBoucle(_foundBoucle);
                  }
                //});
            });
      }
    } on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      debug.log(e.toString());
    }
  }

  void dispose() {
    if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android)) {
      this._mgr.stopReadBluetooth();
      if (this._bluetoothSubscription != null)
        this._bluetoothSubscription?.cancel();
    }

  }
}