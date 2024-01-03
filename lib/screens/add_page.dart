import 'package:flutter/material.dart';
import 'package:rest_todo/services/todo_service.dart';
import 'package:rest_todo/utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Todo" : "Add Todo"),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: 'Title',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              hintText: 'Description',
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 10,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: isEdit ? updateData : submitData,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(isEdit ? 'Update' : 'Submit'),
              )),
        ],
      ),
    );
  }

  Future<void> submitData() async {
    //submit data to the server
    final isSuccess = await TodoServices.addTodo(body);

    //show success or failure message based on status
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message: "Creation Success");
    } else {
      showErrorMessage(context, message:"Creation Failed");
    }
  }

  Future<void> updateData() async {
    //Get the data from the form
    final todo = widget.todo;
    if (todo == null) {
      print("You can not call the updated without todo data");
      return;
    }
    final id = todo['_id'];

    //submit updated data to the server
    final isSuccess = await TodoServices.updateTodo(id, body);

    //show success or failure message based on status
    if (isSuccess) {
      showSuccessMessage(context, message: "Updation Success");
    } else {
      showErrorMessage(context, message:"Updation Failed");
    }
  }

  Map get body{
    //Get the data from the form
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
