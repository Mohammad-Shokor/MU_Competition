class Team {
  List<String> Members;
  String TeamName;
  Club club;
  int Level;

  Team(this.Members, this.TeamName, this.club, this.Level);

  Team copy() {
    return Team(
      List<String>.from(Members), // Deep copy the list
      TeamName,
      club,
      Level,
    );
  }

  String GetData() {
    String a = "";
    a += "Team Name : $TeamName, Teamlevel : $Level ";
    return a;
  }
}

enum Club { MUBC, Code_it, Mix }
