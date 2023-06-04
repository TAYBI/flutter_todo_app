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
  bool isLoading = true;
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
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchData,
          child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index] as Map;
                final id = todo['_id'] as String;
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(todo['title']),
                  subtitle: Text(todo['description']),
                  trailing: PopupMenuButton(onSelected: (value) {
                    if (value == 'edit') {
                      navigateToEdditpage(context, todo);
                    } else if (value == 'delete') {
                      deleteTodo(id);
                    }
                  }, itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Text('Edit'),
                        value: 'edit',
                      ),
                      PopupMenuItem(
                        child: Text('Delete'),
                        value: 'delete',
                      ),
                    ];
                  }),
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            print('pressed');
            navigateToAddPage(context);
          },
          label: Text('Add Todo')),
    );
  }

  Future<void> navigateToAddPage(BuildContext context) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTODO(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchData();
  }

  Future<void> fetchData() async {
    // setState(() {
    //   isLoading = true;
    // });
    final url = 'http://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        todos = result;
        isLoading = false;
      });
    } else {
      showMessageError('Something went wrong');
    }
  }

  Future<void> deleteTodo(String id) async {
    final url = 'http://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      // delete item from todos list on the ui
      final filtredTodo =
          todos.where((element) => element['_id'] != id).toList();
      setState(() {
        todos = filtredTodo;
      });
    } else {}
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

  void navigateToEdditpage(BuildContext context, Map todo) {
    final route = MaterialPageRoute(
      builder: (context) => AddTODO(todo: todo),
    );
    Navigator.push(context, route);
  }
}
