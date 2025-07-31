import 'package:flutter/material.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/lamb/presenter/LambingPresenter.dart';

enum View {lot, saillie, all}

class SearchPerePage extends StatefulWidget {
  final LambingModel _lambing;
  const SearchPerePage( this._lambing, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState()=> new _SearchPerePageState(this._lambing);

}
abstract class SearchPereContract {

}

class _SearchPerePageState  extends State<SearchPerePage> implements SearchPereContract{
  final LambingModel _lambing;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _curIndex=0;
  late View _currentView = View.lot;
  late SearchPerePresenter _presenter = SearchPerePresenter(this);

  _SearchPerePageState(this._lambing);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar:
        BottomNavigationBar(
            items: [
              BottomNavigationBarItem(icon: Image.asset("assets/Lot.png"),label: S.of(context).batch),
              BottomNavigationBarItem(icon: Image.asset("assets/saillie.png"),  label: S.of(context).mating),
              BottomNavigationBarItem(icon: Image.asset("assets/ram_inactif.png"), label: S.of(context).all_ram),
            ],
            currentIndex: _curIndex,
            onTap: (index) =>{ _changePage(index)}
        ),
        appBar: new AppBar(
          title:
          Text(S.of(context).search_ram) ,
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
        if (belierSnap.data!.length == 0)
          return Center( child:
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text(S.of(context).title_empty_list),
            subtitle: Text(S.of(context).no_ram_found),
          ),);

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
                        style: TextStyle(fontStyle: FontStyle.italic),),
                    onTap: () => _selectBete(bete),
                );
            }
        );},
      future: this._presenter.getBeliers(_currentView, _lambing),
    );
  }


  void _selectBete(Bete bete) {
    Navigator
        .of(context)
        .pop(bete);
  }
}