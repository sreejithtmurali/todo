import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/todo_model.dart';
import 'home.dart';

class Viewtask extends StatefulWidget {
  TodoModel task;
   Viewtask({super.key,required this.task});

  @override
  State<Viewtask> createState() => _ViewtaskState();
}

class _ViewtaskState extends State<Viewtask> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DatabaseHelper _databaseHelper = DatabaseHelper();
  bool _isLoading = false;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController.text=widget.task.title;
    _descriptionController.text=widget.task.description;
  }
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateTask() async {
    setState(() {
      _isLoading=true;
    });
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      TodoModel todo = TodoModel(
        id: widget.task.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        isCompleted: false,
      );
      var result= await _databaseHelper.updateTask(todo);
      if(result>=0){
        setState(() {
          _isLoading=false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data Updated Successfully")));

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(),));
      }
      else{
        setState(() {
          _isLoading=false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data Update Failed")));
      }

    }
  }

  String? _validateTitle(String? value) {
    final title = value?.trim() ?? '';

    if (title.isEmpty) {
      return 'Please enter task title';
    }

    if (title.length < 3) {
      return 'Title must contain at least 3 characters';
    }

    if (title.length > 100) {
      return 'Title cannot exceed 100 characters';
    }

    return null;
  }

  String? _validateDescription(String? value) {
    final description = value?.trim() ?? '';

    if (description.isEmpty) {
      return 'Please enter task description';
    }

    if (description.length < 5) {
      return 'Description must contain at least 5 characters';
    }

    if (description.length > 500) {
      return 'Description cannot exceed 500 characters';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(),));
        }, icon: Icon(Icons.arrow_back_ios)),
        title: const Text(
          'Update Task',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page heading
                const Text(
                  'Update existing Task',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Update a title and description for your task.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),

                const SizedBox(height: 30),

                // Title
                const Text(
                  'Task Title',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  maxLength: 100,
                  decoration: InputDecoration(
                    hintText: 'Enter task title',
                    prefixIcon: const Icon(Icons.task_alt),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(width: 2),
                    ),
                  ),
                  validator: _validateTitle,
                ),

                const SizedBox(height: 20),

                // Description
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _descriptionController,
                  maxLength: 500,
                  maxLines: 6,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: 'Enter task description',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 90),
                      child: Icon(Icons.description_outlined),
                    ),
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(width: 2),
                    ),
                  ),
                  validator: _validateDescription,
                ),

                const SizedBox(height: 30),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateTask,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text(
                          'Update',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
