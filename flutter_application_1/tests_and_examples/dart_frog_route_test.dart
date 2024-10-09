import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// It works in both ways either since it uses an async ioperation to read a data.

Future<String> getData() async {
  var url = Uri.parse('http://localhost:8080');
  var response = await http.get(url);
  // Map data = jsonDecode(response.body); // this requires import dart:convert
  return response.body;
}
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: newText(),
        ),
      ),
    );
  }
}

class newText extends StatefulWidget{
  const newText({super.key});

  @override
  State<newText> createState() => _newText();
}

class _newText extends State<newText> {

  String value = "Hello";

  @override
  Widget build(BuildContext context) {
    getData().then((value){
      setState((){
        value = value;
      });
    });
    return Text(value);
  }
}