import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/database/database_helper.dart';
import 'package:todo/views/addtask.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseHelper _databaseHelper=DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todos"),),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Addtask(),));
      },child: Text("ADD"),),
    );
  }
}
