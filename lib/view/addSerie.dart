import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class AddSerieScreen extends StatefulWidget {
  @override
  _AddSerieScreenState createState() => _AddSerieScreenState();
}

class _AddSerieScreenState extends State<AddSerieScreen> {
  final _nomeController = TextEditingController();
  final _generoController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _fotoController = TextEditingController();

  Future<void> _addSerie() async {
    if (_nomeController.text.isEmpty || _generoController.text.isEmpty) {
      return;
    }

    final serie = {
      'nome': _nomeController.text,
      'genero': _generoController.text,
      'descricao': _descricaoController.text,
      'foto': _fotoController.text,
    };

    final db = DatabaseHelper();
    await db.insertSerie(serie);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Série adicionada com sucesso!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Série'), backgroundColor: Colors.deepPurple,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome da Série'),
            ),
            TextField(
              controller: _generoController,
              decoration: InputDecoration(labelText: 'Gênero'),
            ),
            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: _fotoController,
              decoration: InputDecoration(labelText: 'Foto (URL)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addSerie,
              child: Text('Adicionar Série'),
            ),
          ],
        ),
      ),
    );
  }
}
