import 'dart:developer' as debug;

import 'package:flutter/material.dart';
import 'package:flutter_gismo/main.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:intl/intl.dart';

class LotAffectationViewPage extends StatefulWidget {
  LotModel _currentLot;

  LotAffectationViewPage(this._currentLot, {Key key}) : super(key: key);
  @override
  _LotAffectationViewPageState createState() => new _LotAffectationViewPageState();
}

class _LotAffectationViewPageState extends State<LotAffectationViewPage> {
  final _formFicheKey = GlobalKey<FormState>();
  TextEditingController _dateDebutCtl = TextEditingController();
  TextEditingController _dateFinCtl = TextEditingController();
  final _df = new DateFormat('dd/MM/yyyy');

  List<Bete> _betes;

  String _codeLot;
  String _debut;
  String _fin;

  @override
  void initState(){
    super.initState();
    _codeLot = this.widget._currentLot.codeLotLutte;
    _dateDebutCtl.text = this.widget._currentLot.dateDebutLutte;
    _dateFinCtl.text = this.widget._currentLot.dateFinLutte;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
          length: 3,
          child: new Scaffold(
            appBar: new AppBar(
              title: new Text('Lot'),
              bottom:
                new TabBar(
                  tabs: <Widget>[new Text("Fiche"), new Text("Brebis"), new Text("Béliers")]),
            ),
            body:
            new TabBarView(
                children: <Widget>[
                  _getFiche(),
                  _listBrebisWidget(),
                  _listBelierWidget()
                ]

            ),

          )
    );
  }

  Widget _getFiche() {
    return new Container(
        child: new Form(
          key: _formFicheKey,
          child:
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new TextFormField(
                    initialValue: _codeLot,
                    decoration: InputDecoration(labelText: 'Nom lot', hintText: 'Lot'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return "";
                    },
                    onSaved: (value) {
                      setState(() {
                        _codeLot = value;
                      });
                    }
                ),
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
                              _dateDebutCtl.text = _df.format(date);
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
                              _dateFinCtl.text = _df.format(date);
                          },
                        ),
                      )
                    ]

                ),
                RaisedButton(
                  color: Colors.lightGreen[700],
                  child: new Text("Enregistrer",style: TextStyle( color: Colors.white)),
                  onPressed: _save)
              ])
    ));
  }

  Widget _listBelierWidget() {
    return FutureBuilder(
      builder: (context, BelierSnap) {
        if (BelierSnap.connectionState == ConnectionState.none && BelierSnap.hasData == null) {
          return Container();
        }
        if (BelierSnap.connectionState == ConnectionState.waiting)
          return CircularProgressIndicator();
        return ListView.builder(
          shrinkWrap: true,
          itemCount: BelierSnap.data.length,
          itemBuilder: (context, index) {
            Bete bete = BelierSnap.data[index];
            return Column(
              children: <Widget>[
                Card(child:
                    ListTile(
                      title: Text(bete.numBoucle),
                      subtitle: Text(bete.numMarquage),
                      trailing: IconButton(icon: Icon(Icons.delete), onPressed: null, )
                    )
                )
              ],
            );
          },
        );
      },
      future: _getBeliers(this.widget._currentLot.idb),
    );
  }

  Widget _listBrebisWidget() {
    return FutureBuilder(
      builder: (context, BelierSnap) {
        if (BelierSnap.connectionState == ConnectionState.none && BelierSnap.hasData == null) {
          return Container();
        }
        if (BelierSnap.connectionState == ConnectionState.waiting)
          return CircularProgressIndicator();
        return ListView.builder(
          shrinkWrap: true,
          itemCount: BelierSnap.data.length,
          itemBuilder: (context, index) {
            Bete bete = BelierSnap.data[index];
            return Column(
              children: <Widget>[
                Card(child:
                ListTile(
                    title: Text(bete.numBoucle),
                    subtitle: Text(bete.numMarquage),
                    trailing: IconButton(icon: Icon(Icons.delete), onPressed: null, )
                )
                )
              ],
            );
          },
        );
      },
      future: _getBeliers(this.widget._currentLot.idb),
    );
  }

  void _save() {}

  Future<List<LotModel>> _getBeliers(int idLot)  {
    return gismoBloc.getLots();
  }

  Future<List<LotModel>> _getBbrebis(int idLot)  {
    return gismoBloc.getLots();
  }

}