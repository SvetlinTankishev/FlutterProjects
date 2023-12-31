import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _greetingMessage = "Fetching...";

  @override
  void initState() {
    super.initState();
    _fetchGreeting();
  }

  _fetchGreeting() async {
    final response = await http.get(Uri.parse('http://localhost:8080/greeting'));
    if (response.statusCode == 200) {
      setState(() {
        _greetingMessage = json.decode(response.body)['message'];
      });
    } else {
      setState(() {
        _greetingMessage = "Failed to fetch greeting";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter & Spring Boot Demo"),
      ),
      body: Center(
        child: Text(_greetingMessage),
      ),
    );
  }
}