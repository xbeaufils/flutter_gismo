import 'package:flutter/widgets.dart';

class WelcomeViewModel extends ChangeNotifier {

  void _parcellePressed() {
    /*
    if (_bloc.user!.subscribe!)
      Navigator.pushNamed(context, '/parcelle');
    else
      this.showMessage("Les parcelles ne sont pas visibles en mode autonome");*/
  }

  void _individuPressed() {
    //Navigator.pushNamed(context, '/search');
  }

  void _sortiePressed() {

    Future<dynamic>  message = Navigator.pushNamed(context, '/sortie')  ;
    message.then((message) {
      showMessage(message);
    }).catchError((message) {
      showMessage(message);
    });
  }

  void _entreePressed() {
    Future<dynamic>  message = Navigator.pushNamed(context, '/entree') ;
    message.then((message) {
      showMessage(message);
    }).catchError((message) {
      showMessage(message);
    });
  }

  void showMessage(String ? message) {
    if (message == null) return;
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _traitementPressed() {
    Navigator.pushNamed(context, '/sanitaire');
  }

  void _echoPressed() {
    Navigator.pushNamed(context, '/echo');
  }

  void _lambingPressed() {
    Navigator.pushNamed(context, '/lambing');
  }

  void _lambPressed() {
    Navigator.pushNamed(context, '/lamb');
  }

  void _necPressed() {
    Navigator.pushNamed(context, '/nec');
  }

  void _peseePressed() {
    Navigator.pushNamed(context, '/pesee');
  }

  void _lotPressed() {
    Navigator.pushNamed(context, '/lot');
  }

  void _sailliePressed() {
    Navigator.pushNamed(context, '/saillie');
  }

}