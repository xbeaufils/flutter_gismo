class Report {
 late String cheptel;
 late int betes;
 late int agnelages;
 late int agneaux;
 late int sorties;
 late int entrees;
 late int traitements;
 late int nec;
 late int lots;
 late int affectations;

 Map<String, dynamic> toJson() {
   final Map<String, dynamic> data = new Map<String, dynamic>();
   data["cheptel"] = cheptel;
   data["betes"] = betes;
   data["agnelages"] = agnelages;
   data["agneaux"] = agneaux;
   data["traitements"] = traitements;
   data["nec"] = nec;
   data["lots"] = lots;
   data["affectations"] = affectations;
   return data;
 }

}