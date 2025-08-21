import 'package:flutter/material.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/individu/ui/EventPage.dart';
import 'package:flutter_gismo/individu/ui/TimeLine.dart';
import 'package:flutter_gismo/lamb/presenter/LambPresenter.dart';
import 'package:flutter_gismo/model/LambModel.dart';

class LambTimeLinePage extends StatefulWidget {
  final LambModel _lamb;

  LambModel get lamb => _lamb;

  LambTimeLinePage(this._lamb, {Key ? key}) : super(key: key);
  @override
  LambTimeLinePageState createState() => new LambTimeLinePageState();
}

abstract class LambTimelineContract extends  TimelineContract {
  LambModel get lamb;
}

class LambTimeLinePageState extends GismoStatePage<LambTimeLinePage> with SingleTickerProviderStateMixin implements LambTimelineContract {
  late LambTimeLinePresenter _presenter;

  @override
  Future<String?> editPage(StatefulWidget page) {
    // TODO: implement editPage
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(S.of(context).sheep),
      ),
      body:
      Column (
        children: <Widget>[
          Card(child:
          ListTile(
            title: Text(lamb.marquageProvisoire!),
            // subtitle: (lamb.dateAgnelage!= null) ? Text( DateFormat.yMd().format(_bete.dateEntree)): null,
            leading: Image.asset("assets/lamb.png") ,
            trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: () => this._presenter.view(lamb), ),)
            ,),
          Expanded(child: _getEvents()),
        ],),
    );

  }

  Widget _getEvents() {
    return EventLambPage(this, this.widget._lamb);
  }


  @override
  void initState() {
    super.initState();
    this._presenter  = LambTimeLinePresenter(this);
  }

  LambModel get lamb => this.widget._lamb;
}