import 'dart:io';

//import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';

import 'dart:developer' as debug;

import 'package:flutter_gismo/infra/ui/MenuPage.dart';
import 'package:flutter_gismo/infra/presenter/WelcomePresenter.dart';
import 'package:flutter_gismo/model/Dashboard.dart';
import 'package:flutter_gismo/model/MemoModel.dart';
import 'package:flutter_gismo/services/AuthService.dart';
import 'package:flutter_gismo/sheepyGreenScheme.dart';


import 'package:google_mobile_ads/google_mobile_ads.dart';



class WelcomePage extends StatefulWidget {

  WelcomePage();

  @override
  _WelcomePageState createState() => new _WelcomePageState();
}

abstract class WelcomeContract extends GismoContract {
  void viewPage(String path);
  void viewPageMessage(String path);
  BuildContext get context;
}

class _WelcomePageState extends GismoStatePage<WelcomePage> implements WelcomeContract {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late WelcomePresenter _presenter;
  _WelcomePageState();
  BannerAd ? _adBanner;


  @override
  Widget build(BuildContext context) {
    debug.log("Build", name: "Welcome:::build");
    return Scaffold(
        key: _scaffoldKey,
//        backgroundColor: Colors.lightGreen,
        appBar: new AppBar(
            title: Text('Gismo ' + AuthService().cheptel!),
            actions: [
              FutureBuilder(
                future: _presenter.getNbNotes(),
                builder : (BuildContext context, AsyncSnapshot<List<MemoModel>> snapshot) {
                  int nbNotes = 0;
                  if (snapshot.hasData) {
                    nbNotes = snapshot.data!.length;
                  }
                  return IconButton(
                      onPressed: _presenter.notePressed,
                      icon: (nbNotes == 0) ? Icon(Icons.sticky_note_2): Badge(
                          child: Icon(Icons.sticky_note_2),
                          label: Text(nbNotes.toString()),
                      ));
                })],
            // N'affiche pas la touche back (qui revient à la SplashScreen
            automaticallyImplyLeading: true,
             ),
//        bottomNavigationBar: this._navigationBar(),
        body:
        Column(children: [
          Flexible(child:
            FutureBuilder(
              future: _presenter.getDashBoardEffectif(),
              builder : (BuildContext context, AsyncSnapshot<DashBoardEffectif> snapshot) {
                if (snapshot.data == null)
                  return SizedBox(child: CircularProgressIndicator(), width: 60, height: 60,);
                return GridView.count(
                  scrollDirection: Axis.vertical,padding: EdgeInsets.all(10),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  children: <Widget>[
                    _buildTileEffectif( "Femelles", snapshot.data!.nbBrebis),
                    _buildTileEffectif( "Brebis (*)", snapshot.data!.nbBrebisAdulte),
                    _buildTileEffectif( "Agnelles (**)", snapshot.data!.nbBrebisAntenais),
                    _buildTileEffectif( "Males", snapshot.data!.nbBeliers),
                    _buildTileEffectif( "Beliers (*) ", snapshot.data!.nbBeliersAdulte),
                    _buildTileEffectif( "Agneaux (**)", snapshot.data!.nbBeliersAntenais),
                  ]);
              })),
          Expanded(child:
            Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text("* Dont la date de naissance est supérieure à 1 an ou est inconnue",style: TextStyle(fontStyle: FontStyle.italic),),
              Text("** Dont la date de naissance est inférieure à 1 an", style: TextStyle(fontStyle: FontStyle.italic))
            ],)),
          this._getAdmobAdvice(),
          this._getFacebookAdvice(),
        ]),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: sheepyGreenSheme.colorScheme.onPrimaryContainer,
            // backgroundColor: sheepyGreenSheme.colorScheme.onPrimaryContainer, NO RESULT
            type: BottomNavigationBarType.fixed,
          onTap: (index) {
              switch (index) {
                 case 0:
                  this._openMenuEffectif(context);
                  break;
                case 1:
                  this._openMenuBreeding(context);
                  break;
                case 2:
                  this._openMenuHealth();
                  break;
                case 3:
                  this._openMenuOthers();
                  break;
                default:
              }
          } ,
          items: [
            BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/brebis.png")), label: S.of(context).effectif, key: Key("btTroupeau")),
            BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/sheep_lamb.png")), label: S.of(context).reproduction, key: Key("btBreeding")),
            BottomNavigationBarItem(icon: Icon(Icons.health_and_safety), label: S.of(context).sante, key: Key("btSante")),
            BottomNavigationBarItem(icon: Icon(Icons.more_vert), label: S.of(context).other, key: Key("btAutre")),
          ],)
      ,
        drawer: GismoDrawer(),);
  }

  Widget _getAdmobAdvice() {
    if (AuthService().subscribe ) {
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

  Widget _buildTileEffectif(String label, int nb) {
    return GridTile(
      header: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: sheepyGreenSheme.colorScheme.primary,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child:
          Text(label, style: TextStyle(color: Colors.white),),
        /*GridTileBar(
          backgroundColor: sheepyGreenSheme.primaryColor,
          title: Text(label,),
        )*/
      ),
      child:
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: sheepyGreenSheme.colorScheme.primaryContainer ,),
          padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 20.0),
          child: Text(nb.toString(), )),
    );
  }

  Widget _buildGriTile(String imageName, String title, bool needSubscribe, Function() press ) {
    bool afficheBtn = false;
    if (! needSubscribe)
      afficheBtn = true;
    else if (AuthService().subscribe)
      afficheBtn = true;
    if ( afficheBtn)
      return GridTile(child:
        Column(children: [
          FilledButton(
            style: ElevatedButton.styleFrom(
              // The width will be 100% of the parent widget
              // The height will be 60
                minimumSize: const Size.fromHeight(60)),
            child: Image.asset(imageName),
            onPressed : press,),
          Text(title) ]),
        );
    return Container();
  }

  Widget _getFacebookAdvice() {
    if ( AuthService().subscribe   ) {
      return SizedBox(height: 0,width: 0,);
    }
    /*if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android)) {
      return
        //Card(child:
         FacebookBannerAd(
            placementId: '212596486937356_212596826937322',
            bannerSize: BannerSize.STANDARD,
            keepAlive: true,
            listener: (result, value) {}
        //  ),
        );
    }*/
    return Container();
  }

  String _getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-9699928438497749/2969884909';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-9699928438497749/5554017347';
    }
    debug.log("Unable to find plateform");
    return "";
  }

  final ButtonStyle textButtonStyle = TextButton.styleFrom(
    backgroundColor: Colors.white,
    minimumSize: Size(100, 88),
    padding: const EdgeInsets.all(4.0),
    //padding: EdgeInsets.symmetric(horizontal: 16),
    shadowColor:  Colors.grey.withOpacity(0.5),
    elevation: 5,
    shape: const RoundedRectangleBorder(
      //side: BorderSide(color: Colors.red),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  );

  @override
  void initState() {
    super.initState();
    _presenter = WelcomePresenter(this);
    if (! AuthService().subscribe ) {
      this._adBanner = BannerAd(
        adUnitId: _getBannerAdUnitId(), //'<ad unit ID>',
        size: AdSize.banner,
        request: AdRequest(),
        listener: BannerAdListener(),
      )..load();
      // See in https://dev-yakuza.posstree.com/en/flutter/admob/#configure-app-id-on-android
      debug.log("Load Ad Banner");
      //this._adBanner!.load();
      /*FacebookAudienceNetwork.init(
        testingId: "a77955ee-3304-4635-be65-81029b0f5201",
        iOSAdvertiserTrackingEnabled: true,
      );*/
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (this._adBanner != null)
      this._adBanner!.dispose();
  }

  void viewPage(String path) {
    Navigator.pushNamed(context, path);
  }

  void viewPageMessage(String path) {
    Future<dynamic>  message = Navigator.pushNamed(context, path)  ;
    message.then((message) {
      if (message != null)
        showMessage(message);
    }).catchError((message) {
      showMessage(message);
    });

  }
  // AnimationStyle? _animationStyle = ;

  void _openMenuEffectif(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(children: [
            ListTile(
              leading: Image.asset("assets/Lot.png"),
              title: Text(S.of(context).batch),
              onTap: _presenter.lotPressed,),
            ListTile(
              leading: Image.asset("assets/brebis.png"),
              title: Text(S.of(context).sheep),
              onTap: _presenter.individuPressed,),
            ListTile(
              leading: Image.asset("assets/jumping_lambs.png"),
              title: Text(S.of(context).lambs),
              onTap: _presenter.lambPressed,),
            ListTile(
              leading: Image.asset("assets/home.png"),
              title: Text(S.of(context).input),
             onTap: _presenter.entreePressed,),
            ListTile(
              leading: Image.asset("assets/Truck.png"),
              title: Text(S.of(context).output),
              onTap: _presenter.sortiePressed,),
          ],);
        });
  }

  void _openMenuBreeding(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(children: [
            ListTile(
              leading: Image.asset("assets/saillie.png"),
              title: Text(S.of(context).mating),
              onTap: _presenter.sailliePressed,),
            ListTile(
              leading: Image.asset("assets/ultrasound.png"),
              title: Text(S.of(context).ultrasound),
              onTap: _presenter.echoPressed,),
            ListTile(
              leading: Image.asset("assets/lamb.png"),
              title: Text(S.of(context).lambing),
              onTap: _presenter.lambingPressed,),
          ],);
        });
  }

  void _openMenuHealth() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(children: [
            ListTile(
              leading: SizedBox(child: Image.asset("assets/syringe.png"), width: 55,),
              title: Text(S.of(context).treatment),
              onTap: _presenter.traitementPressed,),
            ListTile(
              leading: SizedBox(child: Image.asset("assets/peseur.png"), width: 55,),
              title: Text(S.of(context).weighing),
              onTap: _presenter.peseePressed,),
            ListTile(
              leading: SizedBox(child: Image.asset("assets/etat_corporel.png"), width: 55,),
              title: Text(S.of(context).body_cond),
              onTap: _presenter.necPressed,),
          ]);}
    );
  }

  void _openMenuOthers() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(children: [
            ListTile(
              leading: Image.asset("assets/parcelles.png"),
              title: Text("Parcelles"),
              onTap: _presenter.parcellePressed,),
            ListTile(
              leading: Image.asset("assets/memo.png"),
              title: Text(S.of(context).memo),
              onTap: _presenter.notePressed,),

          ]);
        }
    );
  }
}
