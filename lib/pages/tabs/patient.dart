import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Patient extends StatefulWidget {
  const Patient({Key? key}) : super(key: key);

  @override
  PatientState createState() => PatientState();
}

class PatientState extends State<Patient> {
  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: Center(
        child: Text('patient'),
      ),
    );
  }
}
