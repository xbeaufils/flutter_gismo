class Report {
 String cheptel;
 int betes;
 int agnelages;
 int agneaux;
 int sorties;
 int entrees;
 int traitements;
 int nec;
 int lots;
 int affectations;

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