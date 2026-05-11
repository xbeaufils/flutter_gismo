
class DashBoardEffectif {
    late int _nbBrebis;
    late int _nbBrebisAdulte;
    late int _nbBrebisAntenais;
    late int _nbBeliers;
    late int _nbBeliersAdulte;
    late int _nbBeliersAntenais;


    DashBoardEffectif(this._nbBrebis, this._nbBrebisAdulte,
        this._nbBrebisAntenais, this._nbBeliers, this._nbBeliersAdulte,
        this._nbBeliersAntenais);

    DashBoardEffectif.fromResult(result) {
    _nbBrebis = result["nbBrebis"] ;
    _nbBrebisAdulte = result["nbBrebisAdulte"];
    _nbBrebisAntenais = result["nbBrebisAntenais"];
    _nbBeliers = result["nbBeliers"];
    _nbBeliersAdulte = result["nbBeliersAdulte"];
    _nbBeliersAntenais = result["nbBeliersAntenais"];
  }

  int get nbBrebis => _nbBrebis;
  int get nbBrebisAdulte => _nbBrebisAdulte;
  int get nbBeliersAntenais => _nbBeliersAntenais;
  int get nbBeliersAdulte => _nbBeliersAdulte;
  int get nbBeliers => _nbBeliers;
  int get nbBrebisAntenais => _nbBrebisAntenais;
}