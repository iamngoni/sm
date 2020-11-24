import 'package:flutter/material.dart';
import 'package:school_management/api/index.dart';

class Classes extends StatefulWidget {
  @override
  _ClassesState createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  final _api = new API();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Classes"),
      ),
      body: FutureBuilder(
        future: _api.getClasses(),
        builder: (context, snapshot) {
          while (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var data = snapshot.data["classes"];
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Text("${index + 1}"),
                ),
                title: Text(data[index]["name"]),
              );
            },
          );
        },
      ),
    );
  }
}
