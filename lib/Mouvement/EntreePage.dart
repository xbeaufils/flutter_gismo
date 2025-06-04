import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/Bete.dart';
import 'package:flutter_gismo/bloc/ConfigProvider.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/presenter/EntreePresenter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EntreePage extends StatefulWidget {
  EntreePage();
  @override
  _EntreePageState createState() => new _EntreePageState();
}

abstract class EntreeContract extends GismoContract {

}

class _EntreePageState extends GismoStatePage<EntreePage> implements EntreeContract {

  _EntreePageState();

  TextEditingController _dateEntreeCtl = TextEditingController();
  late List<Bete> _sheeps;
  String ?  _currentMotif;
  late List<DropdownMenuItem<String>> _motifEntreeItems;
  BannerAd ? _adBanner;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late EntreePresenter _presenter;

  List<DropdownMenuItem<String>> _getMotifEntreeItems(BuildContext context) {
    List<DropdownMenuItem<String>> items = [];
    items.add( new DropdownMenuItem(value: 'NAISSANCE', child: new Text( S.of(context).entree_birth )));
    items.add( new DropdownMenuItem(value: 'CREATION', child: new Text(S.of(context).entree_creation)));
    items.add( new DropdownMenuItem(value: 'RENOUVELLEMENT', child: new Text(S.of(context).entree_renewal)));
    items.add( new DropdownMenuItem(value: 'ACHAT', child: new Text(S.of(context).entree_purchase)));
    items.add( new DropdownMenuItem(value: 'MUTATION_INTERNE', child: new Text('Mutation interne')));
    items.add( new DropdownMenuItem(value: 'REACTIVATION', child: new Text(S.of(context).entree_reactivation)));
    items.add( new DropdownMenuItem(value: 'PRET_OU_PENSION', child: new Text(S.of(context).entree_loan)));
    items.add( new DropdownMenuItem(value: 'ENTREE_EN_SCI_OU_CE', child: new Text('Entree en SCI ou CE')));
    items.add( new DropdownMenuItem(value: 'REPRISE_EN_SCI_OU_CE', child: new Text('Reprise en SCI ou CE')));
    items.add( new DropdownMenuItem(value: 'INCONNUE', child: new Text(S.of(context).entree_unknown)));
    return items;
  }

  void _changedMotifEntreeItem(String ? selectedMotif) {
    setState(() {
      if (selectedMotif != null)
        _currentMotif= selectedMotif;
    });
  }

  @override
  Widget build(BuildContext context) {
    ConfigProvider provider = Provider.of<ConfigProvider>(context);
    if ( ! provider.isSubscribing()) {
      this._adBanner = BannerAd(
        adUnitId: _getBannerAdUnitId()!, //'<ad unit ID>',
        size: AdSize.banner,
        request: AdRequest(),
        listener: BannerAdListener(),
      );
      this._adBanner!.load();
    }
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(S.of(context).input),
      ),
      body:
      new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Card(key: null,
              child:Column(
                children: <Widget>[
                  new TextFormField(
                      keyboardType: TextInputType.datetime,
                      controller: _dateEntreeCtl,
                      decoration: InputDecoration(
                          labelText: S.of(context).dateEntry,
                          hintText: 'jj/mm/aaaa'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return S.of(context).noEntryDate;
                        }},
                      onSaved: (value) {
                        setState(() {
                          _dateEntreeCtl.text = value!;
                        });
                      },
                      onTap: () async{
                        DateTime date = DateTime.now();
                        FocusScope.of(context).requestFocus(new FocusNode());
                        date = (await showDatePicker(
                          //locale: const Locale("fr","FR"),
                          context: context,
                          initialDate:DateTime.now(),
                          firstDate:DateTime(1900),
                          lastDate: DateTime(2100)))!;
                        if (date != null) {
                          setState(() {
                            _dateEntreeCtl.text = DateFormat.yMd().format(date);
                          });
                        }
                      }),
                  new DropdownButton<String>(
                    key: Key("Motif_Key"),
                    value: _currentMotif,
                    items: _motifEntreeItems,
                    hint: Text(S.of(context).entree_select,style: TextStyle(color: Colors.lightGreen,)),
                    onChanged: _changedMotifEntreeItem,
                  )

                ],
              )),
          Expanded(
            child: Sheeps(this._sheeps, this)),
          ElevatedButton(
            child: Text(S.of(context).bt_save,
                style: new TextStyle(color: Colors.white, ),),
            onPressed: () {
              try {
                this._presenter.save(_dateEntreeCtl.text, _currentMotif, this._sheeps);
              } on MissingDate {
                showError(S.of(context).noEntryDate);
              } on MissingMotif {
                showError(S.of(context).entree_reason_required);
              } on MissingSheeps {
                showError(S.of(context).empty_list);
              }
            }),
          ]

      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _openAddEntryDialog,
        tooltip: S.of(context).tooltip_add_beast,
        child: new Icon(Icons.add),
      ),
    );
  }
/*
  Widget _getAdmobAdvice() {
    if (this._bloc.isLogged() ! ) {
      return Container();
    }
    if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android)) {
      return Card(
            child: Container(
                height:  this._adBanner!.size.height.toDouble(),
                width:  this._adBanner!.size.width.toDouble(),
                child: AdWidget(ad:  this._adBanner!)));
    }
    return Container();
  }

*/
  String ? _getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-9699928438497749/2969884909';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-9699928438497749/7971231462';
    }
    return null;
  }
/*
  void _saveEntree() {
    if (_dateEntreeCtl.text.isEmpty) {
      showError(S.of(context).noEntryDate);
      return;
    }

    if ( _currentMotif == null) {
      showError(S.of(context).entree_reason_required);
      return;
    }
    if (_currentMotif!.isEmpty) {
      showError(S.of(context).entree_reason_required);
      return;
    }
    if (_sheeps.length == 0) {
      showError(S.of(context).empty_list);
      return;
    }
    var message  = this.bloc.saveEntree(DateFormat.yMd().parse(_dateEntreeCtl.text), _currentMotif!, this._sheeps);
    message
      .then( (message) {goodSaving(message);})
      .catchError( (message) {showError(message);});
  }
*/
  void showError(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context)..showSnackBar(snackBar);
  }

  void goodSaving(String message) {
    message = S.of(context).input + " : " + message;
    Navigator.pop(context, message);
  }

  Future _openAddEntryDialog() async {
      Bete? selectedBete = await Navigator.of(context).push(new MaterialPageRoute<Bete>(
          builder: (BuildContext context) {
            return new BetePage(null);
          },
          fullscreenDialog: true
      )) ;
      if (selectedBete != null) {
        setState(() {
          _sheeps.add(selectedBete);
        });
      }
  }

  @override
  void initState() {
    super.initState();
    _presenter = EntreePresenter(this);
    _sheeps = [];
    //_motifEntreeItems = _getMotifEntreeItems();
    _dateEntreeCtl.text = DateFormat.yMd().format(DateTime.now());
    /*
    new Future.delayed(Duration.zero,() {
      _motifEntreeItems = _getMotifEntreeItems(context);
    });*/
    /*
    ConfigProvider provider = Provider.of<ConfigProvider>(context);
    if ( ! provider.isSubscribing()) {
      this._adBanner = BannerAd(
        adUnitId: _getBannerAdUnitId()!, //'<ad unit ID>',
        size: AdSize.banner,
        request: AdRequest(),
        listener: BannerAdListener(),
      );
      this._adBanner!.load();
    }*/
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    _motifEntreeItems  = this._getMotifEntreeItems(context);
  }

  @override
  void dispose() {
    super.dispose();
    //this._adBanner!.dispose();
  }

  void removeBete(int index) {
    setState(() {
      _sheeps.removeAt(index);
    });

  }
}

class Sheeps extends StatelessWidget {
  final List<Bete> _sheeps;
  _EntreePageState _entree;
  Sheeps(this._sheeps, this._entree);

  Widget _buildLambItem(BuildContext context, int index) {
    return Card(
      child: ListTile(
            title: Text(_sheeps[index].numBoucle),
            subtitle: Text(_sheeps[index].numMarquage),
            trailing: IconButton(icon: Icon(Icons.clear), onPressed:() {  _entree.removeBete(index);} ),
          ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _buildLambItem,
      itemCount: _sheeps.length,
    );
  }
}
