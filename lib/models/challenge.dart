class Challenge{

  int id;
  String name;
  String description;
  String completedHours;
  String goalHours;
  
  Challenge(this.id, this.name, this.description, this.completedHours, this.goalHours);
  
  Challenge.createEmpty(){
    this.id = 0;
    this.name  = "";
    this.description = "";
    this.completedHours = "";
    this.goalHours = "";
  }
}