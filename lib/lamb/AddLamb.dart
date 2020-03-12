import 'package:flutter/material.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';

class AddingLambDialog extends StatefulWidget {
  @override
  AddingLambingState createState() => AddingLambingState();
}

class AddingLambingState extends State<AddingLambDialog> {
  //String _dateAgnelage;
  //String _marquageProvisoire;
  TextEditingController _marquageCtrl = TextEditingController();
  Sex _sex = Sex.male;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: const Text('Nouvel agneau'),
        ),
        body:
        new Column(
            children: <Widget>[
              new TextField(
                decoration: InputDecoration(labelText: 'Marquage provisoire'),
                controller: _marquageCtrl,
              ),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Flexible (child:
                    RadioListTile<Sex>(
                      title: const Text('Male'),
                      value: Sex.male,
                      groupValue: _sex,
                      onChanged: (Sex value) { setState(() { _sex = value; }); },
                    ),
                    ),
                    new Flexible( child:
                    RadioListTile<Sex>(
                      title: const Text('Femelle'),
                      value: Sex.femelle,
                      groupValue: _sex,
                      onChanged: (Sex value) { setState(() { _sex = value; }); },
                    ),
                    ),]

              ),

              new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new RaisedButton(
                        onPressed:addLamb,
                        color: Colors.lightGreen[900],
                        child:
                        new Text(
                          "Ajouter",
                          style: new TextStyle(color: Colors.white),
                        )
                    )
                  ]
              ),
            ]
        )
    );
  }

  void addLamb() {
    Navigator
        .of(context)
        .pop(new LambModel(this._marquageCtrl.text, this._sex));
  }
}

