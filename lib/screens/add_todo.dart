import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTODO extends StatefulWidget {
  const AddTODO({super.key});

  @override
  State<AddTODO> createState() => _AddTODOState();
}

class _AddTODOState extends State<AddTODO> {
  TextEditingController titleControler = TextEditingController();
  TextEditingController descriptionControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todo"),
      ),
      body: ListView(padding: EdgeInsets.all(16), children: [
        TextField(
          controller: titleControler,
          decoration: InputDecoration(hintText: 'Title'),
        ),
        SizedBox(height: 10),
        TextField(
          controller: descriptionControler,
          decoration: InputDecoration(hintText: 'Description'),
          keyboardType: TextInputType.multiline,
          minLines: 5,
          maxLines: 8,
        ),
        SizedBox(height: 10),
        ElevatedButton(onPressed: submitData, child: Text('Submit'))
      ]),
    );
  }

  void submitData() async {
    // get the data
    final text = titleControler.text;
    final description = descriptionControler.text;
    final body = {
      "title": text,
      "description": description,
      "is_completed": false
    };
    print(body);

    final url = 'http://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      titleControler.text = '';
      descriptionControler.text = '';
      showMessageSuccess('Todo added');
      print(response.body);
    } else {
      showMessageError('Something went wrong');
    }
  }

  void showMessageSuccess(msg) {
    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showMessageError(msg) {
    final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          msg,
          style: TextStyle(color: Colors.white),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
