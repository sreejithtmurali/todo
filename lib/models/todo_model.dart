class TodoModel {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;

  TodoModel({
    this.id,
    required this.title,
    required this.description,
     this.isCompleted=false,
  });

  Map<String,dynamic> toMap(){
    return {"id":id,"title":title,"description":description,"isCompleted":isCompleted};
  }

  static TodoModel fromMap(Map<String,dynamic> map){
    return TodoModel(id:map['id'],title: map['title'], description: map['description'],isCompleted: map['isCompleted']);
  }

}
