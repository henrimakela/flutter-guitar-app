class Challenge{

  int id;
  String name;
  String description;
  int completedMinutes;
  int goalMinutes;
  
  Challenge(this.id, this.name, this.description, this.completedMinutes, this.goalMinutes);
  
  Challenge.createEmpty(){
    this.id = 0;
    this.name  = "";
    this.description = "";
    this.completedMinutes = 0;
    this.goalMinutes = 0;
  }
}