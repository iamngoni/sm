import 'package:flutter/material.dart';
import 'package:school_management/api/index.dart';
import 'package:school_management/views/admin/home.dart';
import 'package:school_management/views/student/home.dart';

final height = (context) => MediaQuery.of(context).size.height;
final width = (context) => MediaQuery.of(context).size.width;

// functions
routeToHome(context) async {
  final _api = new API();
  var accountType = await _api.getAccountType();
  if (accountType == "student") {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => StudentHome(),
      ),
    );
  } else {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AdminHome(),
      ),
    );
  }
}
