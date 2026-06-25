import 'package:flutter/material.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/copro.dart';
import 'package:flutter_gismo/traitement/presenter/CoproListPresenter.dart';
import 'package:intl/intl.dart';

class CoproListPage extends StatefulWidget {



  CoproListPage();

  @override
  CoproListPageState createState() => CoproListPageState();

}

abstract class CoproListContract extends GismoContract {
}

class CoproListPageState extends GismoStatePage<CoproListPage> with SingleTickerProviderStateMixin implements CoproListContract {
  late CoproListPresenter _presenter;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(S.of(context).result_copro),
      ),
      body:
      SingleChildScrollView(
        child:
        new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _listCoproWidget(),
            ]

        ),
      ),
      floatingActionButton:
      FloatingActionButton(
        onPressed: this._presenter.createCopro,
        child: Icon(Icons.add),),
    );
  }

  Widget _listCoproWidget() {
    return FutureBuilder(
      builder: (context, AsyncSnapshot prelevementSnap) {
        if (prelevementSnap.connectionState == ConnectionState.none && ! prelevementSnap.hasData) {
          return Container();
        }
        if ( ! prelevementSnap.hasData)
          return Container();
        if (prelevementSnap.connectionState == ConnectionState.waiting)
          return CircularProgressIndicator();
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: prelevementSnap.data.length,
          itemBuilder: (context, index) {
            Prelevement prelev = prelevementSnap.data[index];
            return Card(child:
            ListTile(
                leading:  IconButton(icon: Icon(Icons.delete), onPressed: () =>  this._presenter.delete(prelev), ),
                title: Text(DateFormat.yMd().format(prelev.datePrelevement)),
                subtitle: Text(DateFormat.yMd().format( prelev.datePrelevement)),
                trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: () => this._presenter.viewDetails(prelev), )
            )
            );
          },
        );
      },
      future: this._presenter.getPrelevements(),
    );
  }

  @override
  void initState() {
    super.initState();
    this._presenter = CoproListPresenter(this);
  }
}