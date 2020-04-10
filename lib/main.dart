import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quiz_app/models/quiz.dart';
import 'package:quiz_app/widgets/quiz.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Results> results;

  Future<void> fetchQuestions() async {
    var data = await http.get('https://opentdb.com/api.php?amount=20');
    results = QuizModel.fromJson(jsonDecode(data.body)).results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
        elevation: 0.0,
      ),
      body: FutureBuilder(
        future: fetchQuestions(),
        builder: (BuildContext ctx, AsyncSnapshot snap) {
          switch (snap.connectionState) {
            case ConnectionState.none:
              return Text('Press button to start');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              if (snap.hasError)
                return Container(
                  child: Text('Error!'),
                );
              return Quiz(results);
          }
          return null;
        },
      ),
    );
  }
}
