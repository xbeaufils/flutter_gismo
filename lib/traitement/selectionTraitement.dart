
import 'package:flutter/material.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/SearchPage.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/traitement/Sanitaire.dart';
import 'package:intl/intl.dart';

enum View {fiche, ewe, ram}

class SelectionPage extends StatefulWidget {
   final GismoBloc _bloc;

  SelectionPage(this._bloc,{Key ? key}) : super(key: key);
  @override
  _SelectionPageState createState() => new _SelectionPageState(this._bloc);
}

class _SelectionPageState extends State<SelectionPage> {
  final GismoBloc _bloc;
  _SelectionPageState(this._bloc);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Bete> lstBete = [];
  TextEditingController _codeLotCtl = TextEditingController();
  TextEditingController _dateDebutCtl = TextEditingController();
  TextEditingController _dateFinCtl = TextEditingController();
  TextEditingController _dateMvtCtl = TextEditingController();
  final _df = new DateFormat('dd/MM/yyyy');


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
      floatingActionButton:  FloatingActionButton(child: Icon(Icons.add), onPressed: _addBete),
      body: _listBeteWidget(),
    );
  }

  Widget _listBeteWidget() {
    return Column(children: [
      Expanded(child:
        ListView.builder(
          itemCount: lstBete.length,
          itemBuilder: (context, index) {
            if (lstBete.length == 0)
              return Center(child: Text(""),);
            Bete bete = lstBete[index];
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
        ),
      ),
      Center(child:
        ElevatedButton(
            child: Text( S.of(context).bt_continue, style: new TextStyle(color: Colors.white, ),),
            //color: Colors.lightGreen[700],
            onPressed: _openTraitement),
      )
    ],

    );
  }

  Future _addBete() async {
    //Future _openAddEntryDialog() async {
      Bete ? selectedBete = await Navigator.of(context).push(new MaterialPageRoute<Bete>(
          builder: (BuildContext context) {
            SearchPage search = new SearchPage(this._bloc, GismoPage.lot);
            return search;
          },
          fullscreenDialog: true
      ));
      if (selectedBete != null) {
         setState(() {
            lstBete.add(selectedBete);
        });
      }
  }

  Future _removeBete(Bete selectedBete) async {
    setState(() {
      lstBete.remove(selectedBete);
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
          builder: (context) => SanitairePage.collectif(this.widget._bloc, lstBete )),
    );
    print (navigationResult);
    Navigator
        .of(context)
        .pop(navigationResult);
  }


}