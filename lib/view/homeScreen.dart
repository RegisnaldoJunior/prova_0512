import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciador de Séries'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/addSerie'),
              child: Text('Adicionar Série'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/compareSeries'),
              child: Text('Comparar Séries'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/reports'),
              child: Text('Gerar Relatórios'),
            ),
          ],
        ),
      ),
    );
  }
}
