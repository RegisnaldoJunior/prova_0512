import 'package:flutter/material.dart';
import 'package:prova0512/view/addSerie.dart';
import 'package:prova0512/view/batalhaSerie.dart';
import 'package:prova0512/view/homeScreen.dart';
import 'package:prova0512/view/relatorioSerie.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Séries',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/addSerie': (context) => AddSerieScreen(),
        '/compareSeries': (context) => CompareSeriesScreen(),
        '/reports': (context) => ReportScreen(),
        
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
