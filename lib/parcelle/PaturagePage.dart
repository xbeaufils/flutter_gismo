import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/main.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/model/ParcelleModel.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as debug;

class PaturagePage extends StatefulWidget {
  PaturagePage(this._pature, {Key key}) : super(key: key);
  final Pature _pature;

  @override
  _PaturagePageState createState() => new _PaturagePageState();
}

class _PaturagePageState extends State<PaturagePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _dateDebutCtl = TextEditingController();
  TextEditingController _dateFinCtl = TextEditingController();
  List<DropdownMenuItem<LotModel>> _dropdownMenuLots;
  int _currentLot;

  final df = new DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Paturage'),
        ),
        body: Column(children: <Widget>[
          new Card( child:
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Flexible(
                  child:
                  new TextFormField(
                    controller: _dateDebutCtl,
                    decoration: InputDecoration(
                      labelText: "Date de début",),
                    onTap: () async{
                      DateTime date = DateTime.now();
                      FocusScope.of(context).requestFocus(new FocusNode());

                      date = await showDatePicker(
                          context: context,
                          initialDate:DateTime.now(),
                          firstDate:DateTime(1900),
                          lastDate: DateTime(2100));
                      if (date != null)
                        _dateDebutCtl.text = df.format(date);
                    },
                  ),
                ),
                new Flexible(
                  child:
                  new TextFormField(
                    controller: _dateFinCtl,
                    decoration: InputDecoration(
                      labelText: "Date de Fin",),
                    onTap: () async{
                      DateTime date = DateTime.now();
                      FocusScope.of(context).requestFocus(new FocusNode());

                      date = await showDatePicker(
                          context: context,
                          initialDate:DateTime.now(),
                          firstDate:DateTime(1900),
                          lastDate: DateTime(2100));
                      if (date != null)
                        _dateFinCtl.text = df.format(date);
                    },
                  ),
                )
              ]

            ),
          ),
          new Card(
            child: new FutureBuilder<List<LotModel>>(
                future: gismoBloc.getLots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return new Container();
                  } else if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  return DropdownButton<int>(
                    hint: Text('Lot en paturage'),
                    items: snapshot.data
                        .map((lot) => DropdownMenuItem<int>(
                            child: Text(lot.codeLotLutte),
                            value: lot.idb,
                          )
                        ).toList(),
                    value: _currentLot,
                    onChanged: (int value) {
                      setState(() {
                        _currentLot = value;
                      });
                    },
                  );
                }
            ),
          ),
          new Card(
            child:
              Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new RaisedButton(key:null, onPressed:_save,
                      color: Colors.lightGreen[700],
                      child: new Text("Enregistrer",style: TextStyle( color: Colors.white)),)
                  ]
              )
          )
        ]));
  }

  void _save() async {
    debug.log("Message", name: "_PaturagePageState::_save");
    this.widget._pature.lotId = _currentLot;
    this.widget._pature.debut = _dateDebutCtl.text;
    if ( _dateFinCtl.text.isNotEmpty)
      this.widget._pature.fin = _dateFinCtl.text;
    String message = await gismoBloc.savePature(this.widget._pature);
    Navigator.pop(context, message);
  }

  Future<List<LotModel>> _getLots()  {
    return gismoBloc.getLots();
  }

  @override
  void initState() {
    _currentLot = this.widget._pature.lotId;
    _dateDebutCtl.text = this.widget._pature.debut;
    if (this.widget._pature.fin != null)
      _dateFinCtl.text = this.widget._pature.fin;
  }

}