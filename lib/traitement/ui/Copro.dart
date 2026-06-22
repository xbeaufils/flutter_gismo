import 'package:flutter/material.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/copro.dart';
import 'package:flutter_gismo/sheepyGreenScheme.dart';
import 'package:flutter_gismo/traitement/presenter/coproPresenter.dart';
import 'package:intl/intl.dart';

class CoproPage extends StatefulWidget {

  Prelevement _copro;


  CoproPage(this._copro);

  @override
  CoproPageState createState() => CoproPageState();

}

abstract class CoproContract extends GismoContract {
  Prelevement get copro;
}

class CoproPageState extends GismoStatePage<CoproPage> with SingleTickerProviderStateMixin implements CoproContract {
  late CoproPresenter _presenter;
  late final TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _dateCoproCtl = TextEditingController();
  TextEditingController _strongleGICtl = TextEditingController();
  TextEditingController _stronglePCtl = TextEditingController();
  TextEditingController _strongyCtl = TextEditingController();
  TextEditingController _nematodeCtl = TextEditingController();
  TextEditingController _trichuresCtl = TextEditingController();
  TextEditingController _pDouveCtl = TextEditingController();
  TextEditingController _gDouveCtl = TextEditingController();
  TextEditingController _paramphCtrl = TextEditingController();
  TextEditingController _teniaCtrl = TextEditingController();
  TextEditingController _coccidiCtrl = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(S.of(context).result_copro),),
        floatingActionButton: this._presenter.currentViewIndex == 0 ? null :
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
                child: Icon(Icons.check_box),
                onPressed: this._presenter.addMultipleBete,
                heroTag: null),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(child: Icon(Icons.settings_remote),
              onPressed: this._presenter.addBete,
              heroTag: null,),
          ],),
        body:
        Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
              child:
              TextField(
                  key: Key("date_prelevement"),
                  keyboardType: TextInputType.datetime,
                  controller: _dateCoproCtl,
                  decoration: InputDecoration(
                      filled: true,
                      labelText: S.of(context).date_prelevement,
                      hintText: 'jj/mm/aaaa'),
                  onChanged: (value) {
                    setState(() {
                      _dateCoproCtl.text = value;
                    });
                  },
                  onTap: () async{
                    FocusScope.of(context).requestFocus(new FocusNode());
                    DateTime ? date = await showDatePicker(
                        //locale: const Locale("fr","FR"),
                        context: context,
                        initialDate:DateTime.now(),
                        firstDate:DateTime(1900),
                        lastDate: DateTime(2100));
                    if (date != null) {
                      setState(() {
                        _dateCoproCtl.text = DateFormat.yMd().format(date);
                      });
                    }
                  }),
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "Resultat"),
              Tab(text: "Effectif"),
            ]
          ),
          Expanded(child:
            TabBarView(
              controller: _tabController,
              children: [
                this._getFicheCopro(),
                this._getListBete(),
              ],
            )),
/*
          Expanded(child:
            SingleChildScrollView(child:
              Card(child:
                    Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                      TextField(  decoration: InputDecoration(labelText: S.current.strongles_gastro_intestinaux) ,controller: _strongleGICtl,)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                      TextField(decoration: InputDecoration(labelText: S.current.strongle_pulm), controller: _stronglePCtl,)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                      TextField(decoration: InputDecoration(labelText: S.current.strongyloide), controller: _strongyCtl,)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                      TextField(decoration: InputDecoration(labelText: S.current.nemanotode), controller: _nematodeCtl,)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                      TextField(decoration: InputDecoration(labelText: S.current.trichure), controller: _trichuresCtl,)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                      TextField(decoration: InputDecoration(labelText: S.current.petite_douve), controller: _pDouveCtl,)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                      TextField(decoration: InputDecoration(labelText: S.current.grande_douve), controller: _gDouveCtl,)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                      TextField(decoration: InputDecoration(labelText: S.current.paramphistome), controller: _paramphCtrl,)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                      TextField(decoration: InputDecoration(labelText: S.current.tenia), controller: _teniaCtrl,)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                      TextField(decoration: InputDecoration(labelText: S.current.coccidie), controller: _coccidiCtrl,)),
                    ],)
                    ,))),
  */
          FilledButton(
            onPressed: () {this._presenter.save( _dateCoproCtl.text, _strongleGICtl.text, _stronglePCtl.text,
                _strongyCtl.text, _nematodeCtl.text, _trichuresCtl.text, _pDouveCtl.text, _gDouveCtl.text,
                _paramphCtrl.text, _teniaCtrl.text, _coccidiCtrl.text);},
            child: Text(S.of(context).bt_save),)
            ],));
  }

  @override
  void initState() {
    super.initState();
    this._presenter = CoproPresenter(this);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => this._presenter.changeTab(_tabController.index));
    _dateCoproCtl.text = DateFormat.yMd().format(this.widget._copro.datePrelevement);
    this.widget._copro.resultats.forEach((result) {
      switch (result.parasite) {
        case Parasite.STRONGLES_GASTRO_INTESTINAUX:
          _strongleGICtl.text = result.quantite.toString();
          break;
        case Parasite.STRONGLES_PULMONAIRES:
          _stronglePCtl.text = result.quantite.toString();
          break;
        case Parasite.STRONGYLOIDES:
          _strongyCtl.text = result.quantite.toString();
          break;
        case Parasite.NEMATODIRUS:
          _nematodeCtl.text = result.quantite.toString();
          break;
        case Parasite.TRICHURES:
          _trichuresCtl.text = result.quantite.toString();
          break;
        case Parasite.PETITES_DOUVES:
          _pDouveCtl.text = result.quantite.toString();
          break;
        case Parasite.GRANDES_DOUVES:
          _gDouveCtl.text = result.quantite.toString();
          break;
        case Parasite.PARAMPHISTOMES:
          _paramphCtrl.text = result.quantite.toString();
          break ;
        case Parasite.TAENIA:
          _teniaCtrl.text = result.quantite.toString();
          break;
        case Parasite.COCCIDIES:
          _coccidiCtrl.text = result.quantite.toString();
          break;
        case null:
          // TODO: Handle this case.
          break;
      }
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(() => this._presenter.changeTab(_tabController.index));
    _tabController.dispose();
    super.dispose();
  }

  Prelevement get copro => this.widget._copro;

  Widget _getFicheCopro() {
    return Column(children: [
 /*     Padding(
        padding: const EdgeInsets.all(8.0),
        child:
          TextField(
            key: Key("date_prelevement"),
            keyboardType: TextInputType.datetime,
            controller: _dateCoproCtl,
            decoration: InputDecoration(
            filled: true,
            labelText: S.of(context).date_prelevement,
            hintText: 'jj/mm/aaaa'),
            onChanged: (value) {
              setState(() {
              _dateCoproCtl.text = value;
              });
            },
            onTap: () async{
              FocusScope.of(context).requestFocus(new FocusNode());
              DateTime ? date = await showDatePicker(
                //locale: const Locale("fr","FR"),
                context: context,
                initialDate:DateTime.now(),
                firstDate:DateTime(1900),
                lastDate: DateTime(2100));
              if (date != null) {
                setState(() {
                  _dateCoproCtl.text = DateFormat.yMd().format(date);
                });
              }
            }),
            ),
   */   Expanded(child:
        SingleChildScrollView(child:
          Card(child:
            Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                  TextField(  decoration: InputDecoration(labelText: S.current.strongles_gastro_intestinaux) ,controller: _strongleGICtl,)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                  TextField(decoration: InputDecoration(labelText: S.current.strongle_pulm), controller: _stronglePCtl,)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                  TextField(decoration: InputDecoration(labelText: S.current.strongyloide), controller: _strongyCtl,)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                  TextField(decoration: InputDecoration(labelText: S.current.nemanotode), controller: _nematodeCtl,)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                  TextField(decoration: InputDecoration(labelText: S.current.trichure), controller: _trichuresCtl,)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                  TextField(decoration: InputDecoration(labelText: S.current.petite_douve), controller: _pDouveCtl,)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                  TextField(decoration: InputDecoration(labelText: S.current.grande_douve), controller: _gDouveCtl,)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                  TextField(decoration: InputDecoration(labelText: S.current.paramphistome), controller: _paramphCtrl,)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                  TextField(decoration: InputDecoration(labelText: S.current.tenia), controller: _teniaCtrl,)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                  TextField(decoration: InputDecoration(labelText: S.current.coccidie), controller: _coccidiCtrl,)),
            ],)
    ,))),

  ]);}

  Widget _getListBete() {
    // TODO: implement build
    return ListView.builder(
        itemCount: this.widget._copro.betes.length,
        itemBuilder: (context, index) {
          Bete ? bete = this.widget._copro.betes[index];
          return //Card(child:
            ListTile(
              tileColor: (index % 2 == 0) ? sheepyGreenSheme.colorScheme
                  .primaryContainer : sheepyGreenSheme.colorScheme.surface,
              leading: (bete.sex == Sex.male) ? ImageIcon(
                  AssetImage("assets/male.png")) : ImageIcon(
                  AssetImage("assets/female.png")),
              title: Text(bete.numBoucle),
              subtitle: Text(bete.numMarquage),);
        }
    );
  }
}