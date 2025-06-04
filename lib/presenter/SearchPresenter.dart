import 'package:flutter/widgets.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/bloc/NavigationService.dart';
import 'package:flutter_gismo/individu/EchoPage.dart';
import 'package:flutter_gismo/individu/NECPage.dart';
import 'package:flutter_gismo/individu/PeseePage.dart';
import 'package:flutter_gismo/individu/SailliePage.dart';
import 'package:flutter_gismo/individu/TimeLine.dart';
import 'package:flutter_gismo/lamb/lambing.dart';
import 'package:flutter_gismo/memo/MemoPage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/search/SearchPage.dart';
import 'package:flutter_gismo/services/BeteService.dart';

class SearchPresenter {

  final SearchContract _view;

  BeteService _service = BeteService();
  SearchPresenter(this._view);

  void getBetes(Sex ? searchSex) async {
    List<Bete> ? lstBetes ;
    if (searchSex == null) {
      lstBetes = await this._service.getBetes();
    }
    else {
      switch (searchSex) {
        case Sex.femelle:
          lstBetes = await this._service.getBrebis();
          break;
        case Sex.male :
          lstBetes = await this._service.getBeliers();
          break;
        default :
          lstBetes = await this._service.getBetes();
      }
    }
    this._view.fillList(lstBetes);
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

}