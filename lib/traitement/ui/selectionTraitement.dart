import 'package:flutter/material.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/search/ui/selectionResult.dart';
import 'package:flutter_gismo/traitement/presenter/SelectionPresenter.dart';

class SelectionPage extends SelectionResultPage {

  SelectionPage( List<Bete> lstBete, String explanation, String title, {Key ? key}) : super(lstBete, explanation, title, key: key);

  @override
  _SelectionPageState createState() => new _SelectionPageState();
}


class _SelectionPageState extends SelectionResultPageState {

  _SelectionPageState();

  @override
  void initState(){
    super.initState();
    super.presenter = SelectionTraitementPresenter(this);
    }



  @override
  void dispose() {
    super.dispose();
  }


}