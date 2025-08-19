import 'package:flutter/material.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/model/ParcelleModel.dart';
import 'package:flutter_gismo/parcelle/presenter/PaturagePresenter.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as debug;

class PaturagePage extends StatefulWidget {
  PaturagePage( this._pature, {Key ? key}) : super(key: key);
  final Pature _pature;
  int ? _currentLotId;

  @override
  _PaturagePageState createState() => new _PaturagePageState();
}

abstract class PaturageContract extends GismoContract {
  Pature get pature;
  int ? get currentLotId;
  set currentLotId(int ? value);
}

class _PaturagePageState extends GismoStatePage<PaturagePage> implements PaturageContract {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _dateDebutCtl = TextEditingController();
  TextEditingController _dateFinCtl = TextEditingController();
  late List<DropdownMenuItem<LotModel>> _dropdownMenuLots;

  late PaturagePresenter _presenter;

  final df = new DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Paturage'),
        ),
        body:
        Column(children: <Widget>[
          Card( child:
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                          TextFormField(
                            controller: _dateDebutCtl,
                            decoration: InputDecoration(
                            labelText: S.of(context).date_debut,),
                            onTap: () async {
                              DateTime ? date = DateTime.now();
                              FocusScope.of(context).requestFocus(new FocusNode());
                              date = await showDatePicker(
                              context: context,
                              initialDate:DateTime.now(),
                              firstDate:DateTime(1900),
                              lastDate: DateTime(2100));
                              if (date != null)
                                _dateDebutCtl.text = df.format(date);
                            }),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                          TextFormField(
                            controller: _dateFinCtl,
                            decoration: InputDecoration(
                            labelText: S.of(context).date_fin,),
                            onTap: () async{
                              DateTime ? date = DateTime.now();
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
                        ))
                  ]),
                FutureBuilder<List<LotModel>>(
                  future: this._presenter.getLots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return Container();
                    }
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    return DropdownButton(
                      hint: Text('Lot en paturage'),
                      items: snapshot.data.map <DropdownMenuItem<int>>((LotModel lot) {
                        return DropdownMenuItem(
                          child: Text( ( lot.codeLotLutte==null)?"": lot.codeLotLutte! ),
                          value: lot.idb,);
                      }).toList(),
                      value: currentLotId,
                      onChanged: (int ? value) {
                        setState(() {
                          currentLotId = value;
                        });
                      },
                    );
                  }
              ),
              ])),
              Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FilledButton(key:null, onPressed:()  {_presenter.save(_dateDebutCtl.text , _dateFinCtl.text);},
                      //color: Colors.lightGreen[700],
                      child: new Text(S.of(context).bt_save,))
                  ])

          ]),
        );
  }

  @override
  void initState() {
    super.initState();
    _presenter = PaturagePresenter(this);
    currentLotId = this.widget._pature.lotId;
    if (this.widget._pature.debut != null)
      _dateDebutCtl.text = DateFormat.yMd().format(this.widget._pature.debut!);
    if (this.widget._pature.fin != null)
      _dateFinCtl.text = DateFormat.yMd().format(this.widget._pature.fin!);
  }

  Pature get pature => this.widget._pature;
  set currentLotId(int ? value) {
    this.widget._currentLotId = value;
  }

  @override
  // TODO: implement currentLotId
  int? get currentLotId => this.widget._currentLotId;

}