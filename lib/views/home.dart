import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todo/database/database_helper.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/views/addtask.dart';
import 'package:todo/views/viewTask.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todos")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Addtask()),
          );
        },
        child: Text("ADD"),
      ),
      body: FutureBuilder(
        future: _databaseHelper.getAllTodos(),
        builder:
            (
              BuildContext context,
              AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Shimmer.fromColors(
                  direction: ShimmerDirection.ltr,
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade600,
                  enabled: true,
                  child: ListView.builder(
                    itemCount: 20,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          title: Container(
                            color: Colors.blue,
                            height: 20,
                            width: double.maxFinite,
                          ),
                          subtitle: Container(
                            color: Colors.blue,
                            height: 20,
                            width: double.maxFinite,
                          ),
                          trailing: Container(
                            color: Colors.blue,
                            height: 20,
                            width: 20,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              }
              if (snapshot.hasData) {
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(child: Text("No Data"));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    TodoModel todoModel = TodoModel.fromMap(
                      snapshot.data![index],
                    );
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Viewtask(task: todoModel),
                            ),
                          );
                        },
                        title: Text("${todoModel.title}"),
                        subtitle: Text("${todoModel.description}", maxLines: 1),
                        trailing: Container(
                          child: Column(
                            mainAxisAlignment: .spaceAround,
                            children: [
                              Text(
                                todoModel.isCompleted == true
                                    ? "Completed"
                                    : "pending",
                                style: TextStyle(
                                  color: todoModel.isCompleted == true
                                      ? Colors.green
                                      : Colors.orange,
                                  fontSize: 12,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  await _databaseHelper.deleteTask(
                                    todoModel.id!,
                                  );
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.delete,
                                  size: 24,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text("No Data"));
              }
            },
      ),
    );
  }
}
