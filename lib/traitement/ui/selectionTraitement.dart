import 'package:flutter/material.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/traitement/presenter/SelectionPresenter.dart';

enum View {fiche, ewe, ram}

class SelectionPage extends StatefulWidget {
   List<Bete> _lstBete;

  SelectionPage(this._lstBete, {Key ? key}) : super(key: key);
  @override
  _SelectionPageState createState() => new _SelectionPageState();
}

abstract class SelectionContract extends GismoContract {
  List<Bete> get betes;
  set betes (List<Bete> value);
}

class _SelectionPageState extends GismoStatePage<SelectionPage> implements SelectionContract {
  _SelectionPageState();
  late SelectionPresenter _presenter;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState(){
    super.initState();
    _presenter = SelectionPresenter(this);
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
          FloatingActionButton(child: Icon(Icons.check_box), onPressed: this._presenter.addMultipleBete, heroTag: null,),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(child: Icon(Icons.settings_remote), onPressed: this._presenter.addBete, heroTag: null,),
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
            onPressed: this._presenter.openTraitement),
      ),
    ],
    );
  }

  Widget _listBeteWidget() {
    if (this.betes.length == 0)
      return Container(
          padding: const EdgeInsets.all(10.0),
          child:
          Center(child: Text(S.current.treatment_explanation),));
    return _fullListBeteWidget();
  }

  Widget _listBeteBuilder() {
    return ListView.builder(
        itemCount: this.betes.length,
        itemBuilder: (context, index) {
          Bete bete = this.betes[index];
          return
            ListTile(
                title:
                Text(bete.numBoucle,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle:
                Text(bete.numMarquage,
                  style: TextStyle(fontStyle: FontStyle.italic),),
                trailing: IconButton(
                  icon: Icon(Icons.cancel), onPressed: () =>
                    { setState(() {
                      this._presenter.removeBete(bete);
                    }) },
                )
            );
        }
    );

  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Bete> get betes {
    return this.widget._lstBete;
  }

  set betes (List<Bete> value) {
    setState(() {
      this.widget._lstBete = value;
    });
  }

}