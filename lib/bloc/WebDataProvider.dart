
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_gismo/Environnement.dart';
import 'package:flutter_gismo/bloc/AbstractDataProvider.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/EchographieModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/model/NECModel.dart';
import 'package:flutter_gismo/model/ParcelleModel.dart';
import 'package:flutter_gismo/model/PeseeModel.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';
import 'package:flutter_gismo/model/User.dart';

import 'dart:developer' as debug;

import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';


class WebDataProvider extends DataProvider {
  static BaseOptions options = new BaseOptions(
    baseUrl: Environnement.getUrlTarget(),
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );
  final Dio _dio = new Dio(options);

  WebDataProvider(GismoBloc bloc) : super(bloc) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) => requestInterceptor(options),
      //onResponse: (Response response) => responseInterceptor(response),
      onError: (DioError dioError) => onError(dioError)
    ));
  }

  dynamic requestInterceptor(RequestOptions options)  {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //String token = prefs.getString("token");
    options.headers.addAll({"Token": super.token});
    return options;
  }

  FutureOr<dynamic> onError(DioError dioError) {
    debug.log("dioError " + dioError.toString(), name: "WebDataProvider::onError");
    return dioError;
  }

  Future<User> auth(User user) async {
    try {
      final response = await _dio.post( Environnement.getUrlTarget() + '/user/auth', data: user.toMap());
      debug.log("Send authentication", name: "WebDataProvider::auth");
      if (response.data['error']) {
        throw (response.data['message']);
      }
      else {
        user.setCheptel(response.data['result']["cheptel"]);
      }
    } on DioError catch (e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
    debug.log("User is $user.cheptel", name: "WebDataProvider::auth");
    return user;
  }

  Future<String> saveLambing(LambingModel lambing ) async {
    try {
      final response = await _dio.post('/lamb/add', data: lambing.toJson());
      if (response.data['error']) {
        throw (response.data['message']);
      }
      else {
        return response.data['message'];
      }
    }
    on DioError catch ( e) {
      debug.log("Error " + e.message);
      return "Error " + e.message;
    }
  }

   Future<String> saveLamb(LambModel lamb ) async {
    try {
      final response = await _dio.post('/lamb/save', data: lamb.toJson());
      if (response.data['error']) {
        throw (response.data['message']);
      }
      else {
        return response.data['message'];
      }
    }
    on DioError catch ( e) {
      debug.log("Error " + e.message);
      return "Error " + e.message;
    }
  }

  Future<String> deleteLamb(int idBd ) async {
    try {
      final response = await _dio.get('/lamb/del/' + idBd.toString());
      if (response.data['error']) {
        throw (response.data['message']);
      }
      else {
        return response.data['message'];
      }
    }
    on DioError catch ( e) {
      debug.log("Error " + e.message);
      return "Error " + e.message;
    }
  }


  Future<List<Bete>> getBetes(String cheptel) async {
    final response = await _dio.get(
        '/bete/searchAll?cheptel=' + cheptel);
    List<Bete> tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(new Bete.fromResult(response.data[i]));
    }
    return tempList;
  }

  Future<String> saveBete(Bete bete) async {
    String action;
    if (bete.idBd == null)
      action = "new";
    else
      action = "update";
    try {
      final response = await _dio.post(
          '/bete/' + action,
          data: bete.toJson());
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return response.data['message'];
      }
    } on DioError catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    } on TypeError catch( e) {
      throw ("Oulala" +  Environnement.getUrlTarget());
    }
  }


  @override
  Future<Bete> getMere(Bete bete) async {
    try {
      final response = await _dio.get(
          '/bete/mere/' + bete.idBd.toString());
      Bete mere = new Bete.fromResult(response.data);
      return mere;
    } on DioError catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  Future<User> login(User user) async {
    try {
      final response = await _dio.post(
          '/user/login', data: user.toMap());
      if (response.data['error']) {
        throw (response.data['message']);
      }
      user.setCheptel (response.data['result']["cheptel"]);
      user.setToken(response.data['result']["token"]);
      user.subscribe = true;
    } on DioError catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
    return user;
  }

  @override
  Future<List<LambingModel>> getLambs(int idBete) async {
    final response = await _dio.get(
        '/lamb/searchAll?idMere=' + idBete.toString());
    List<LambingModel> tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(new LambingModel.fromResult(response.data[i]));
    }
    return tempList;
  }

  @override
  Future<List<CompleteLambModel>> getAllLambs(String cheptel) async {
    final response = await _dio.get(
        '/lamb/cheptel/' + cheptel);
    List<CompleteLambModel> tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(new CompleteLambModel.fromResult(response.data[i]));
    }
    return tempList;
  }

  @override
  Future<String> saveSortie(String date, String motif, List<Bete> lstBete) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cause'] = motif;
    data['dateSortie'] = date;
    data['lstBete'] = lstBete.map((bete) => bete.toJson()).toList();
    try {
      final response = await _dio.post(
      '/bete/sortie', data: data);
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return response.data['message'];
      }
    } on DioError catch ( e) {
        throw ("Erreur de connection à " +  Environnement.getUrlTarget());
      }
    }

  @override
  Future<String> saveEntree(String cheptel, String date, String motif, List<Bete> lstBete) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cheptel'] = cheptel;
    data['cause'] = motif;
    data['dateEntree'] = date;
    data['lstBete'] = lstBete.map((bete) => bete.toJson()).toList();
    try {
      final response = await _dio.post(
          '/bete/entree', data: data);
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return response.data['message'];
      }
    } on DioError catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  @override
  Future<String> saveTraitement(TraitementModel traitement) async {
    final Map<String, dynamic> data = traitement.toJson();
    try {
      final response = await _dio.post(
          '/traitement/add', data: data);
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return response.data['message'];
      }
    } on DioError catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  @override
  Future<String> saveTraitementCollectif (TraitementModel traitement, List<Bete> betes) async {
    TraitementCollectif col = new TraitementCollectif(traitement, betes);
    final Map<String, dynamic> data = col.toJson();
    try {
      final response = await _dio.post(
          '/traitement/collectif', data: data);
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return response.data['message'];
      }
    } on DioError catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }
  @override
  Future<List<TraitementModel>> getTraitements(Bete bete) async {
    final response = await _dio.get(
        '/traitement/get?idBete=' + bete.idBd.toString());
    List<TraitementModel> tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(new TraitementModel.fromResult(response.data[i]));
    }
    return tempList;
  }

  @override
  Future<List<TraitementModel>> getTraitementsForLamb(LambModel lamb) async {
    final response = await _dio.get(
        '/traitement/lamb/' + lamb.idBd.toString());
    List<TraitementModel> tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(new TraitementModel.fromResult(response.data[i]));
    }
    return tempList;
  }


  @override
  Future<String> deleteTraitement(int idBd) async {
    try {
      final response = await _dio.get('/traitement/del/' + idBd.toString());
      if (response.data['error']) {
        throw (response.data['message']);
      }
      else {
        return response.data['message'];
      }
    }
    on DioError catch ( e) {
      debug.log("Error " + e.message);
      return "Error " + e.message;
    }
  }

  @override
  Future<TraitementModel> searchTraitement(int idBd) async {
    final response = await _dio.get(
        '/traitement/search?idBd=' + idBd.toString());
    return new TraitementModel.fromResult(response.data);
  }

  @override
  Future<String> boucler(LambModel lamb, Bete bete) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["lamb"] = lamb.toJson();
    data["bete"] = bete.toJson();
    try {
      final response = await _dio.post(
          '/lamb/boucle', data: data);
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return response.data['message'];
      }
    } on DioError catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }


  @override
  Future<LambingModel> searchLambing(int idBd) async {
    final response = await _dio.get(
        '/lamb/search?idBd=' + idBd.toString());
    return new LambingModel.fromResult(response.data);
  }

  @override
  Future<void> mort(LambModel lamb, String motif, String date) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["idBb"] = lamb.idBd;
    data["dateDeces"] = date;
    data["motifDeces"] = motif;
    try {
      final response = await _dio.post(
          '/lamb/mort', data: data);
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return response.data['message'];
      }
    } on DioError catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  @override
  Future<String> saveNec(NoteModel note) async {
    try {
      final response = await _dio.post(
          '/nec/new', data: note.toJson());
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return response.data['message'];
      }
    } on DioError catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  @override
  Future<List<NoteModel>> getNec(Bete bete) async {
    final response = await _dio.get(
        '/nec/get?idBete=' + bete.idBd.toString());
    List<NoteModel> tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(new NoteModel.fromResult(response.data[i]));
    }
    return tempList;
  }

  @override
  Future<String> savePesee(Pesee pesee) async {
    try {
      final response = await _dio.post(
          '/poids/new', data: pesee.toJson());
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return response.data['message'];
      }
    } on DioError catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  @override
  Future<List<Pesee>> getPesee(Bete bete) async {
    final response = await _dio.get(
        '/poids/get/' + bete.idBd.toString());
    List<Pesee> tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(new Pesee.fromResult(response.data[i]));
    }
    return tempList;
  }

  @override
  Future<List<Pesee>> getPeseeForLamb(LambModel lamb) async {
    final response = await _dio.get(
        '/poids/lamb/' + lamb.idBd.toString());
    List<Pesee> tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(new Pesee.fromResult(response.data[i]));
    }
    return tempList;
  }

  @override
  Future<String> deletePesee(int idBd) async {
    try {
      final response = await _dio.get('/poids/del/' + idBd.toString());
      if (response.data['error']) {
        throw (response.data['message']);
      }
      else {
        return response.data['message'];
      }
    }
    on DioError catch ( e) {
      debug.log("Error " + e.message);
      return "Error " + e.message;
    }
  }

  @override
  Future<String> saveEcho(EchographieModel echo) async {
    try {
      final response = await _dio.post(
          '/echo/new', data: echo.toJson());
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return response.data['message'];
      }
    } on DioError catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  @override
  Future<List<EchographieModel>> getEcho(Bete bete) async {
    final response = await _dio.get(
        '/echo/get/' + bete.idBd.toString());
    List<EchographieModel> tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(new EchographieModel.fromResult(response.data[i]));
    }
    return tempList;
  }

  @override
  Future<EchographieModel> searchEcho(int idBd) async {
    final response = await _dio.get(
        '/echo/search/' + idBd.toString());
    return new EchographieModel.fromResult(response.data);
  }

  @override
  Future<List<LotModel>> getLots(String cheptel) async {
    final response = await _dio.get(
        '/lot/getAll/' + cheptel);
    List<LotModel> tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(new LotModel.fromResult(response.data[i]));
    }
    return tempList;
  }

  @override
  Future<List<Affectation>> getBeliersForLot(int idLot) async {
    final response = await _dio.get(
        '/lot/getBeliers/' + idLot.toString());
    List<Affectation> tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(new Affectation.fromResult(response.data[i]));
    }
    return tempList;
  }

  @override
  Future<List<Affectation>> getBrebisForLot(int idLot) async {
    final response = await _dio.get(
        '/lot/getBrebis/' + idLot.toString());
    List<Affectation> tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(new Affectation.fromResult(response.data[i]));
    }
    return tempList;
  }

  @override
  Future<Function> remove(Affectation affect) async {
      try {
        final response = await _dio.post(
            '/lot/del', data: affect.toJson());
        if (response.data['error']) {
          throw (response.data['error']);
        }
        else {
          return response.data['message'];
        }
      } on DioError catch ( e) {
        throw ("Erreur de connection à " +  Environnement.getUrlTarget());
      }
  }

  @override
  Future<String> addBete(LotModel lot, Bete bete, String dateEntree) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["lotId"] = lot.idb;
    data["brebisId"] = bete.idBd;
    data["dateEntree"] = dateEntree;
    try {
      final response = await _dio.post(
          '/lot/add', data: data);
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return response.data['message'];
      }
    } on DioError catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }

  }

  @override
  Future<LotModel> saveLot(LotModel lot) async{
    try {
      final response = await _dio.post(
          '/lot/create', data: lot.toJson());
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return LotModel.fromResult(response.data['result']);
      }
    } on DioError catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  @override
  Future<List<Affectation>> getAffectationForBete(int idBete) async {
    try {
      final response = await _dio.get(
          '/lot/bete/' + idBete.toString());
      List<Affectation> tempList = new List();
      for (int i = 0; i < response.data.length; i++) {
        tempList.add(new Affectation.fromResult(response.data[i]));
      }
      return tempList;
    }
    catch (e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }

  }

  @override
  Future<List<Bete>> getBeliers() async {
    try {
      final response = await _dio.get(
          '/bete/getBeliers/');
      List<Bete> tempList = new List();
      for (int i = 0; i < response.data.length; i++) {
        tempList.add(new Bete.fromResult(response.data[i]));
      }
      return tempList;
    }
    catch (e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }

  }

  @override
  Future<List<Bete>> getBrebis() async {
    final response = await _dio.get(
        '/bete/getBrebis/');
    List<Bete> tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(new Bete.fromResult(response.data[i]));
    }
    return tempList;
  }

  Future<String> getCadastre(LocationData myPosition) async {
    try {
      final response = await _dio.post(
          '/map/cadastre', data: {
            'lattitude': myPosition.latitude,
            'longitude': myPosition.longitude
      });
        String cadastre =  response.data;
        return cadastre;
    } on DioError catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  Future<String> getParcelle(LatLng touchPosition) async {
    try {
      final response = await _dio.post(
          '/map/parcelle', data: {
        'lattitude': touchPosition.latitude,
        'longitude': touchPosition.longitude
      });
      String cadastre =  response.data;
      return cadastre;
    } on DioError catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  Future<List<Parcelle>> getParcelles() async {
    try {
      final response = await _dio.get(
          '/map/parcelles/');
      List<Parcelle> parcelles = new List();
      for (int i = 0; i < response.data.length; i++) {
        parcelles.add(Parcelle.fromResult(response.data[i]));
      }
      return parcelles;
    } on DioError catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }
  Future<Pature> getPature(String idu) async {
    try {
      final response = await _dio.get(
          '/paturage/' + idu);
      if( response.data.length>0) {
        Pature pature = Pature.fromResult(response.data);
        return pature;
      }
      throw ("Pature non trouvée");
    } on DioError catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }
  Future<String> savePature(Pature pature) async {
    try {
      final response = await _dio.post(
          '/paturage/save', data: pature.toJson());
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return response.data['message'];
      }
    } on DioError catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }

  }
}