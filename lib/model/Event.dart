enum EventType {entree, agnelage, traitement, sortie, NEC, entreeLot, sortieLot, pesee, echo, saillie, memo}

class Event {
   int _idBd;
   EventType _type;
   String _date;
   String _eventName;


   int get idBd => _idBd;

   set idBd(int value) {
      _idBd = value;
   }

   EventType get type => _type;

   set type(EventType value) {
     _type = value;
   }

   String get date => _date;

   set date(String value) {
     _date = value;
   }

   String get eventName => _eventName;

   set eventName(String value) {
     _eventName = value;
   }

   Event.name(this._idBd, this._type, this._date, this._eventName);


}