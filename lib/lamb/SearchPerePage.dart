import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';

enum View {lot, saillie, all}

class SearchPerePage extends StatefulWidget {
  final GismoBloc _bloc;
  final LambingModel _lambing;
  const SearchPerePage( this._bloc, this._lambing, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState()=> new _SearchPerePageState(this._bloc, this._lambing);

}

class _SearchPerePageState  extends State<SearchPerePage> {
  final GismoBloc _bloc;
  final LambingModel _lambing;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _curIndex=0;
  late View _currentView = View.saillie;

  _SearchPerePageState(this._bloc, this._lambing);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar:
        BottomNavigationBar(
            items: [
              BottomNavigationBarItem(icon: Image.asset("assets/Lot.png"),label:"Lots"),
              BottomNavigationBarItem(icon: Image.asset("assets/saillie.png"),  label: "Saillie"),
              BottomNavigationBarItem(icon: Image.asset("assets/ram_inactif.png"), label: "Tout beliers"),
            ],
            currentIndex: _curIndex,
            onTap: (index) =>{ _changePage(index)}
        ),
        appBar: new AppBar(
          title:
          Text("Recherche du père") ,
        ),
        body:
        _listBelierWidget()
    );
  }

  void _changePage(int index) {
    setState(() {
      _curIndex = index;
      switch (_curIndex) {
        case 0:
          _currentView = View.lot;
          break;
        case 1:
          _currentView = View.saillie;
          break;
        case 2:
          _currentView = View.all;
          break;
      }
    });

  }

  Widget _listBelierWidget() {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<List<Bete>> belierSnap) {
        if (belierSnap.connectionState == ConnectionState.none && belierSnap.hasData == null) {
          return Container();
        }
        if (belierSnap.connectionState == ConnectionState.waiting)
          return Center(child:CircularProgressIndicator());
        if (belierSnap.data == null)
          return Container();
        return ListView.builder(
            itemCount: belierSnap.data!.length,
            itemBuilder: (context, index) {
              Bete bete = belierSnap.data![index];
              return
                ListTile(
                    title:
                      Text(bete.numBoucle,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle :
                      Text(bete.numMarquage,
                        style: TextStyle(fontStyle: FontStyle.italic),)

                );
            }
        );},
      future: _getBeliers(),
    );
  }

  Future<List<Bete>> _getBeliers()  {
    switch (_currentView) {
      case View.lot:
        return this._bloc.getLotBeliers(_lambing);
       case View.saillie :
        return  this._bloc.getSaillieBeliers(_lambing) ;
      case View.all:
        return this._bloc.getBeliers();
    }
  }

}