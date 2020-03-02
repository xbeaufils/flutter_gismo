class NECNotFoundException implements Exception {}

class NEC {
  int _note;
  String _description;
  String _label;


  int get note => _note;
  String get description => _description;
  String get label => _label;

  NEC(this._note, this._label, this._description);

  static NEC level0 = NEC(0, "Extrêmement émacié",
      "impossibilité de détecter des tissus musculaires ou adipeux entre la peau et lʼos."
      " http://www.inn-ovin.fr/note-detat-corporel-nec/");
  static NEC level1 = NEC(1, "Brebis très maigre",
      "Les apophyses épineuses sont saillantes et pointues. Les apophyses transverses sont également pointues, "
      "les doigts passant facilement sous leurs extrémités et il est possible de les engager entre elles."
      "La noix du muscle est peu épaisse et on ne détecte pas de gras de couverture."
      " (http://www.inn-ovin.fr/note-detat-corporel-nec/)");
  static NEC level2 = NEC(2, "Brebis maigre", "Les apophyses épineuses sont encore proéminentes, mais sans « rugosité »."
      "Chaque apophyse est sentie au toucher simplement comme une ondulation. Les apophyses transverses sont également "
      "arrondies et sans rugositéet il est possible, en exerçant une légère pression, dʼengager les doigts entre leurs extrémités."
      "La noix du muscle est dʼépaisseur moyenne avec une faible couverture adipeuse."
      " (http://www.inn-ovin.fr/note-detat-corporel-nec/");
  static NEC level3 = NEC(3, "Brebis en état", " Les apophyses épineuses forment seulement de très légères ondulations souples ;"
      "chacun de ces os ne peut être individualisé que sous lʼeffet dʼune pression des doigts. "
      "Les apophyses transverses sont très bien couvertes et seule une forte pression permet dʼen sentir les extrémités."
      " La noix du muscle est « pleine » et sa couverture adipeuse est moyenne."
      " (http://www.inn-ovin.fr/note-detat-corporel-nec/");
  static NEC level4 = NEC(4, "Brebis grasse",
    "Seule la pression permet de détecter les apophyses épineuses sous la forme dʼune ligne dure entre les deux muscles"
    "(recouverts de gras) qui forment une surface continue. On ne peut pas sentir les extrémités des apophyses transverses."
    "La noix du muscle est « pleine » avec une épaisse couverture adipeuse."
    " (http://www.inn-ovin.fr/note-detat-corporel-nec/");
  static NEC level5 = NEC(5, "Brebis très grasse",
    "Les apophyses épineuses ne peuvent être détectées, même avec une pression ferme. Les deux muscles"
    " recouverts de graisse sont proéminents et on observe une dépression le long de la ligne médiane du dos. Les "
    "apophyses transverses ne peuvent être détectées. La noix des muscles est très « pleine » avec une très "
    "épaisse couverture adipeuse. Dʼimportantes masses de graisse se sont déposées sur la croupe et la queue"
    " (http://www.inn-ovin.fr/note-detat-corporel-nec/)");

  static NEC getNEC(int value) {
    switch (value) {
      case 0: return level0;
      case 1: return level1;
      case 2: return level2;
      case 3: return level3;
      case 4: return level4;
    }
    throw new NECNotFoundException();
  }

}

class NoteModel {
  int _idBd;
  String _date;
  int _note;
  int _idBete;

  NoteModel() {}

  NoteModel.fromResult(result) {
    _idBd= result["idBd"] ;
    _date = result["date"];
    _note = result["note"];
    _idBete = result["bete_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (_idBd != null)
      data["idBd"] = _idBd ;
    data["date"] = _date;
    data["note"] = _note.toString();
    data["bete_id"] = _idBete.toString();
    return data;
  }

  int get idBete => _idBete;

  set idBete(int value) {
    _idBete = value;
  }

  int get note => _note;

  set note(int value) {
    _note = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  int get idBd => _idBd;

  set idBd(int value) {
    _idBd = value;
  }

}