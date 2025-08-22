import 'package:flutter/material.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:intl/intl.dart';

class NumBoucleView extends StatelessWidget {
  final Bete _bete;

  NumBoucleView(this._bete);

  @override
  Widget build(BuildContext context) {
    return
    Card(
      elevation: 5,
      child: ListTile(
        title: Text(_bete.numBoucle + " " + _bete.numMarquage),
        subtitle: (_bete.dateEntree!= null) ? Text( DateFormat.yMd().format(_bete.dateEntree)): null,
        leading: Image.asset("assets/brebis.png")),);
    }

}

class NumLambView extends StatelessWidget {
  final LambModel _lamb;

  NumLambView(this._lamb);

  @override
  Widget build(BuildContext context) {
    return
      Card(
        elevation: 5,
        child: ListTile(
            title: (_lamb.marquageProvisoire != null) ? Text(_lamb.marquageProvisoire! ) : Text("Agneau non identifié"),
            //subtitle: (_bete.dateEntree!= null) ? Text( DateFormat.yMd().format(_bete.dateEntree)): null,
            leading: Image.asset("assets/lamb.png")),);
  }

}