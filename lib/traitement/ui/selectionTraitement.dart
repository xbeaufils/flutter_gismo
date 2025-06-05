
import 'dart:async';
import 'dart:developer' as debug;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/search/ui/SearchPage.dart';
import 'package:flutter_gismo/search/ui/SelectMultiplePage.dart';
import 'package:flutter_gismo/traitement/ui/Sanitaire.dart';
import 'package:intl/intl.dart';

enum View {fiche, ewe, ram}

class SelectionPage extends StatefulWidget {
   final List<Bete> _lstBete;

  SelectionPage(this._lstBete, {Key ? key}) : super(key: key);
  @override
  _SelectionPageState createState() => new _SelectionPageState( this._lstBete);
}

abstract class SelectionContract extends GismoContract {
  List<Bete> get betes;
}

class _SelectionPageState extends GismoStatePage<SelectionPage> implements SelectionContract {
  List<Bete> _lstBete;
  _SelectionPageState( this._lstBete);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _codeLotCtl = TextEditingController();
  TextEditingController _dateDebutCtl = TextEditingController();
  TextEditingController _dateFinCtl = TextEditingController();
  TextEditingController _dateMvtCtl = TextEditingController();

  @override
  void initState(){
    super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(S.of(context).collective_treatment),
       ),
      floatingActionButton: Column (
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(child: Icon(Icons.check_box), onPressed: _addMultipleBete, heroTag: null,),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(child: Icon(Icons.settings_remote), onPressed: _addBete, heroTag: null,),
        ],),
      body: _listBeteWidget(),
    );
  }

  Widget _fullListBeteWidget() {
    return Column(children: [
      Expanded(child:
          this._listBeteBuilder()
      ),
      Container(
        padding: const EdgeInsets.all(10.0),
        child:
          Center(
            child: Text(S.current.treatment_explanation),)),
      Center(child:
        ElevatedButton(
            child: Text( S.of(context).bt_continue, style: new TextStyle(color: Colors.white, ),),
            //color: Colors.lightGreen[700],
            onPressed: this._openTraitement),
      ),
    ],
    );
  }

  Widget _listBeteWidget() {
    if (_lstBete.length == 0)
      return Container(
          padding: const EdgeInsets.all(10.0),
          child:
          Center(child: Text(S.current.treatment_explanation),));
    return _fullListBeteWidget();
  }

  Widget _listBeteBuilder() {
    return ListView.builder(
        itemCount: _lstBete.length,
        itemBuilder: (context, index) {
          Bete bete = _lstBete[index];
          return
            ListTile(
                title:
                Text(bete.numBoucle,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle:
                Text(bete.numMarquage,
                  style: TextStyle(fontStyle: FontStyle.italic),),
                trailing: IconButton(
                  icon: Icon(Icons.cancel), onPressed: () => { _removeBete(bete)},)
            );
        }
    );

  }

  Future _addMultipleBete() async {
    List<Bete>? betes = await Navigator
        .of(context)
        .push(new MaterialPageRoute<List<Bete>>(
        builder: (BuildContext context) {
          SelectMultiplePage search = new SelectMultiplePage(GismoPage.sanitaire, this._lstBete);
          return search;
        },
        fullscreenDialog: true
    ));
    debug.log("List $betes");
    if (betes != null)
      setState(() {
        this._lstBete =  List.from( betes as Iterable );
      });
  }

  Future _addBete() async {
    //Future _openAddEntryDialog() async {
      Bete ? selectedBete = await Navigator
          .of(context)
          .push(new MaterialPageRoute<Bete>(
            builder: (BuildContext context) {
              SearchPage search = new SearchPage( GismoPage.sanitaire);
              return search;
          },
          fullscreenDialog: true
      ));
      if (selectedBete != null) {
         setState(() {
           Iterable<Bete> existingBete  = _lstBete.where((element) => element.idBd == selectedBete.idBd);
           if (existingBete.isEmpty)
            _lstBete.add(selectedBete);
           else
             ScaffoldMessenger.of(context)
                 .showSnackBar(SnackBar(content: Text(S.of(context).identity_number_error)));
        });
      }
  }

  Future _removeBete(Bete selectedBete) async {
    setState(() {
      _lstBete.remove(selectedBete);
    });
  }


  @override
  void dispose() {
    _codeLotCtl.dispose();
    _dateFinCtl.dispose();
    _dateDebutCtl.dispose();
    _dateMvtCtl.dispose();
    super.dispose();
  }

  void _openTraitement() async {
    var navigationResult = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SanitairePage.collectif( _lstBete )),
    );
    print (navigationResult);
    Navigator
        .of(context)
        .pop(navigationResult);
  }

  List<Bete> get betes {
    return this.widget._lstBete;
  }


}