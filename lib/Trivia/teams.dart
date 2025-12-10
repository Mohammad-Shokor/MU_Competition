class Team {
  List<String> TeamMemgers;
  String TeamName;
  int Level = 0;
  Club club;
  Team(this.TeamMemgers, this.TeamName, this.club, this.Level);
}

enum Club { MUBC, Code_it, Mix }
