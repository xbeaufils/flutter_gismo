import 'package:flutter/material.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';

class MedicPage extends StatefulWidget {
  MedicModel ? _medic;
  @override
  MedicPageState createState() => MedicPageState();
  MedicPage.edit(this._medic);
  MedicPage();
}
abstract class MedicContract {

}

class MedicPageState extends GismoStatePage<MedicPage>  implements MedicContract {
  TextEditingController _medicamentCtl = TextEditingController();
  TextEditingController _voieCtl = TextEditingController();
  TextEditingController _doseCtl = TextEditingController();
  TextEditingController _rythmeCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).medication),
      ),
      body:
        Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
            TextFormField(
              controller: _medicamentCtl,
              decoration: InputDecoration(labelText: S.of(context).medication,),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible( child:
              Padding(padding: const EdgeInsets.all(8.0),
                child:
                TextFormField(
                  controller: _voieCtl,
                  decoration: InputDecoration(labelText: S.of(context).route,),
                ),
              )),
              Flexible( child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                TextFormField(
                  controller: _doseCtl,
                  decoration: InputDecoration(labelText: S.of(context).dose,),
                ),
              )),
              Flexible( child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                TextFormField(
                  controller: _rythmeCtl,
                  decoration: InputDecoration(labelText: S.of(context).rythme,),
                ),
              )),
            ]
        ),
        Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FilledButton(
              child: Text(this._getCaptionButton()),
              key: Key("Enregistrer"), onPressed: () => {_addMedicament()})

            ],)
      ]),
    );
  }

  String _getCaptionButton() {
    if (this.widget._medic == null) return S.of(context).bt_add;
    return S.of(context).bt_update;
  }
  void _addMedicament() {
    Navigator
        .of(context)
        .pop(MedicModel.build(_medicamentCtl.text, _voieCtl.text, _doseCtl.text, _rythmeCtl.text));
  }

  @override
  void initState() {
    super.initState();
    if (this.widget._medic != null){
      _medicamentCtl.text = this.widget._medic!.medicament;
      if (this.widget._medic!.voie != null) _voieCtl.text = this.widget._medic!.voie!;
      if (this.widget._medic!.rythme != null) _rythmeCtl.text = this.widget._medic!.rythme!;
      if (this.widget._medic!.dose != null)_doseCtl.text = this.widget._medic!.dose!;
    }

  }

}
