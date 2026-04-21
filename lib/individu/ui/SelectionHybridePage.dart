import 'package:flutter/cupertino.dart';
import 'package:flutter_gismo/individu/presenter/SelectionPresenter.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/search/ui/selectionResult.dart';

class SelectionPage extends SelectionResultPage {

  SelectionPage( List<Bete> lstBete, String explanation, String title, {Key ? key}) : super(lstBete, explanation, title, key: key);

  @override
  _SelectionPageState createState() => new _SelectionPageState();
}


class _SelectionPageState extends SelectionResultPageState {

  _SelectionPageState();
  late SelectionHybridPresenter _presenter;

  @override
  void initState(){
    super.initState();
    super.presenter = SelectionHybridPresenter(this);
  }



  @override
  void dispose() {
    super.dispose();
  }


}