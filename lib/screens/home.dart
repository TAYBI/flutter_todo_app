import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_todo.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app'),
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
}
