import 'package:flutter_gismo/search/presenter/SelectionPresenter.dart';
import 'package:flutter_gismo/search/ui/selectionResult.dart';
import 'package:flutter_gismo/traitement/ui/Sanitaire.dart';

class SelectionTraitementPresenter extends SelectionPresenter {

  SelectionTraitementPresenter(SelectionContract view) : super(view);

  void nextPage() async {
    String ? message = await this.view.goNextPage( MultipleSanitairePage( this.view.betes ));
    if (message != null)
      this.view.backWithMessage(message);
    else
      this.view.back();
  }

}