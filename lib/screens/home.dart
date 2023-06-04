import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_todo.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List todos = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app'),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(todo['title']),
                subtitle: Text(todo['description']),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            print('pressed');
            navigateToAddPage(context);
          },
          label: Text('Add Todo')),
    );
  }

  void navigateToAddPage(BuildContext context) {
    final route = MaterialPageRoute(
      builder: (context) => AddTODO(),
    );
    Navigator.push(context, route);
  }

  Future<void> fetchData() async {
    final url = 'http://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        todos = result;
      });
    } else {}
  }
}
