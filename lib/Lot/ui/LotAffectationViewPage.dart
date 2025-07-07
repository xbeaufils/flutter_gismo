
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gismo/Lot/presenter/LotAffectationPresenter.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:intl/intl.dart';

enum View {fiche, ewe, ram}

class LotAffectationViewPage extends StatefulWidget {
  LotModel  _currentLot;

  LotAffectationViewPage(this._currentLot, {Key? key}) : super(key: key) ;

  @override
  _LotAffectationViewPageState createState() => new _LotAffectationViewPageState();
}

abstract class LotAffectationContract extends GismoContract {
  LotModel get currentLot;
  set currentLot(LotModel value);
  set currentView(View value);
  Future<String?> showDateDialog(String title, String helpMessage, String label);
}

class _LotAffectationViewPageState extends GismoStatePage<LotAffectationViewPage> implements LotAffectationContract {
  late final LotAffectionPresenter _presenter ;
  _LotAffectationViewPageState();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formFicheKey = GlobalKey<FormState>();
  TextEditingController _codeLotCtl = TextEditingController();
  TextEditingController _dateDebutCtl = TextEditingController();
  TextEditingController _dateFinCtl = TextEditingController();
  TextEditingController _dateMvtCtl = TextEditingController();
  TextEditingController _campagneCtrl = TextEditingController();
  final _df = new DateFormat('dd/MM/yyyy');

  late View _currentView;

  View get currentView => _currentView;

  set currentView(View value) {
    setState(() {
      _currentView = value;
    });
  }

  LotModel get currentLot => this.widget._currentLot;

  set currentLot(LotModel value) {
    setState(() {
      this.widget._currentLot = value;
    });
  }

  @override
  void initState(){
    super.initState();
    _presenter = LotAffectionPresenter(this, this.currentLot);
    _currentView = View.fiche;
    if (currentLot.codeLotLutte != null)
      _codeLotCtl.text = currentLot.codeLotLutte!;
    if (currentLot.dateDebutLutte != null)
      _dateDebutCtl.text = DateFormat.yMd().format(currentLot.dateDebutLutte!);
    if (currentLot.dateFinLutte != null)
      _dateFinCtl.text = DateFormat.yMd().format(currentLot.dateFinLutte!);
    if (currentLot.campagne == null)
      _campagneCtrl.text = DateTime.now().year.toString();
    else
      _campagneCtrl.text = currentLot.campagne!;
   }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
            bottomNavigationBar:
              BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.edit),label: S.of(context).bt_edition),
                    BottomNavigationBarItem(icon: Image.asset("assets/ram_inactif.png"), activeIcon: Image.asset("assets/ram_actif.png") ,label: S.of(context).ram),
                    BottomNavigationBarItem(icon: Image.asset("assets/ewe_inactif.png"), activeIcon: Image.asset("assets/ewe_actif.png") , label: S.of(context).ewe),
                  ],
                currentIndex: this._presenter.currentViewIndex.index,
                onTap: (index)  {
                    switch( index) {
                      case 0 :
                        this._presenter.changePage(view.Lot);
                        break;
                      case 1:
                        this._presenter.changePage(view.male);
                        break;
                      case 2:
                        this._presenter.changePage(view.femelle);
                        break;
                    }
                }
              ),
            appBar: new AppBar(
              title:
              (this.currentLot.codeLotLutte == null) ? Text("Nouveau lot") : Text('Lot ' + this.currentLot.codeLotLutte!),
            ),
            floatingActionButton: this._presenter.currentViewIndex == view.Lot ? null :
            Column (
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                  child: Icon(Icons.check_box),onPressed: this._presenter.addMultipleBete, heroTag: null),
                  SizedBox(
                    height: 10,
                  ),
                  FloatingActionButton(child: Icon(Icons.settings_remote), onPressed: this._presenter.addBete, heroTag: null,),
                ],),
            body:
              _getCurrentView()
    );
  }


  Widget _getCurrentView() {
    switch (_currentView) {
      case View.fiche:
        return _getFiche();
      case View.ewe :
        return _listBrebisWidget();
      case View.ram:
        return _listBelierWidget();
    }
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
                      controller: _codeLotCtl,
                      decoration: InputDecoration(labelText: S.of(context).batch_name, hintText: S.of(context).batch),
                   ),

                  new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Flexible( child:
                          TextFormField(
                            controller: _campagneCtrl,
                            decoration: InputDecoration(labelText: S.of(context).batch_campaign),
                            enabled: false,
                          ),
                        )
                      ]
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
                              labelText: S.of(context).date_debut,),
                            onTap: () async{
                              DateTime ? date = DateTime.now();
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
                                _dateFinCtl.text = _df.format(date);
                            },
                          ),
                        )
                      ]

                  ),
                  ElevatedButton(
                      //color: Colors.lightGreen[700],
                      child: new Text(S.of(context).bt_save,style: TextStyle( color: Colors.white)),
                      onPressed: () { this._presenter.save(_campagneCtrl.text, _codeLotCtl.text, _dateDebutCtl.text, _dateFinCtl.text);})
                ])
        ));

  }

  Widget _listBelierWidget() {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<List<Affectation>> belierSnap) {
        if (belierSnap.connectionState == ConnectionState.none && belierSnap.hasData == null) {
          return Container();
        }
        if (belierSnap.connectionState == ConnectionState.waiting)
          return Center(child:CircularProgressIndicator());
        return  Column(
            mainAxisSize: MainAxisSize.max,
            children:  [
          _showCount( (belierSnap.data == null? "0 ": belierSnap.data!.length.toString()) + " béliers"),
          Expanded(child: _showList(belierSnap))
            ]);
      },
      future: this._presenter.getBeliers(this.widget._currentLot.idb!),
    );
  }

  Widget _listBrebisWidget() {
    return FutureBuilder(
        builder: (context, AsyncSnapshot<List<Affectation>> brebisSnap) {
          if (brebisSnap.connectionState == ConnectionState.none &&
              brebisSnap.hasData == null) {
            return Container();
          }
          if (brebisSnap.connectionState == ConnectionState.waiting)
            return Center(child:  CircularProgressIndicator(),);
          return
            Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
              _showCount((brebisSnap.data == null? "0 ": brebisSnap.data!.length.toString()) + " brebis"),
              Expanded(child: _showList(brebisSnap))
            ],);
        },
      future: this._presenter.getBrebis(this.widget._currentLot.idb!),
    );
  }

  Widget _showCount(String libelle) {
    return Row(children: <Widget>[
      Expanded(child:
        Card( color: Theme.of(context).primaryColor,  child:
          Center(child:
            Text( libelle, style: TextStyle(fontSize: 16.0, color: Colors.white),),),
        ),
      ),
    ],);
  }

  Widget _showList(AsyncSnapshot<List<Affectation>> snap) {
    if (snap.data == null)
      return Container();
    return ListView.builder(
      itemCount: snap.data!.length,
      itemBuilder: (context, index) {
        Affectation bete = snap.data![index];
       return //Card(child:
        ListTile(
            title:
              Row(children: <Widget>[
                Text(bete.numBoucle!,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 20,),
                Text(bete.numMarquage!,
                  style: TextStyle(fontStyle: FontStyle.italic),)
              ],),
            subtitle:
              Column(children: <Widget>[
                bete.dateEntree == null ? Text(
                    DateFormat.yMd().format(this.widget._currentLot.dateDebutLutte!)) : Text(
                  "Entrée le : " + DateFormat.yMd().format(bete.dateEntree!),),
                SizedBox(width: 20,),
                bete.dateSortie == null ? Text(
                    DateFormat.yMd().format(this.widget._currentLot.dateFinLutte!)) : Text(
                    "Sortie le : " + DateFormat.yMd().format(bete.dateSortie!))
              ], ),
            trailing:
            Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: Icon(Icons.delete), onPressed: () => { _showDialog(context, bete) } ),
                  IconButton(icon: Icon(Icons.edit), onPressed: () => { _presenter.edit(bete) }, ),
                  //IconButton(icon: Icon(Icons.launch), onPressed: () => { this._presenter.removeBete(bete)},)
        ])
        );
      }
    );
  }

  Future _showDialog(BuildContext context, Affectation affect) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).title_delete),
          content: Text(S.of(context).text_delete),
          actions: [
            _cancelButton(),
            _deleteButton(affect),
          ],
        );
      },
    );
  }
  // set up the buttons

  Widget _cancelButton() {
    return TextButton(
      child: Text(S.of(context).bt_cancel),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _deleteButton(Affectation affectation) {
    return TextButton(
      child: Text(S.of(context).bt_delete),
      onPressed: () {
        setState(() {
          this._presenter.deleteAffectation(affectation);
          Navigator.of(context).pop();
        });
      },
    );
  }

  Future<String?> showDateDialog(String title, String helpMessage, String label) async {
    return showDialog<String>(
        context: context,
        barrierDismissible: false,
        // dialog is dismissible with a tap on the barrier
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(title),
                content:
                new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(helpMessage),
                    /* new Expanded(
                    child:*/
                    new TextFormField(
                      controller: _dateMvtCtl,
                      decoration: InputDecoration(
                        labelText: label,),
                      onTap: () async {
                        DateTime ? date = DateTime.now();
                        FocusScope.of(context).requestFocus(new FocusNode());
                        date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));
                        if (date != null)
                          _dateMvtCtl.text = _df.format(date);
                        //dateEntree = _df.format(date);
                      },
                    ),
                    //)
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(S.of(context).bt_save),
                    onPressed: () {
                      Navigator.of(context).pop(_dateMvtCtl.text);
                    },
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _dateMvtCtl.text="";
                        });
                      },
                      child: Text("Effacer")),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(S.of(context).bt_cancel)),
                ],
              );
            },
          );
        });
  }

  @override
  void dispose() {
    _campagneCtrl.dispose();
    _codeLotCtl.dispose();
    _dateFinCtl.dispose();
    _dateDebutCtl.dispose();
    _dateMvtCtl.dispose();
    super.dispose();
  }
}

