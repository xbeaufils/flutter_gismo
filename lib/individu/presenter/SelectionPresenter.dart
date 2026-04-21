import 'package:flutter_gismo/individu/ui/HybridationPage.dart';
import 'package:flutter_gismo/search/presenter/SelectionPresenter.dart';
import 'package:flutter_gismo/search/ui/selectionResult.dart';

class SelectionHybridPresenter extends SelectionPresenter {

  SelectionHybridPresenter(SelectionContract view) : super(view);

  void nextPage() async {
    String ? message = await this.view.goNextPage( HybridationPage(null));
    if (message != null)
      this.view.backWithMessage(message);
    else
      this.view.back();
  }

}