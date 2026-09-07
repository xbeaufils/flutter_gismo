import 'package:flutter/cupertino.dart';
import 'package:flutter_gismo/individu/presenter/SelectionPresenter.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/search/ui/selectionResult.dart';

class SelectionHybridePage extends SelectionResultPage {

  SelectionHybridePage( List<Bete> lstBete, String explanation, String title, {Key ? key}) : super(lstBete, explanation, title, key: key);

  @override
  _SelectionHybridePage createState() => new _SelectionHybridePage();
}


class _SelectionHybridePage extends SelectionResultPageState {

  _SelectionHybridePage();

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