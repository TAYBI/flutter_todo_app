import 'package:flutter/material.dart';

class AddTODO extends StatefulWidget {
  const AddTODO({super.key});

  @override
  State<AddTODO> createState() => _AddTODOState();
}

class _AddTODOState extends State<AddTODO> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todo"),
      ),
    );
  }
}
