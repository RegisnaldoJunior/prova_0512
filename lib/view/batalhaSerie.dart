import 'dart:io';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class CompareSeriesScreen extends StatefulWidget {
  @override
  _CompareSeriesScreenState createState() => _CompareSeriesScreenState();
}

class _CompareSeriesScreenState extends State<CompareSeriesScreen> {
  List<Map<String, dynamic>> series = [];
  int? selectedSerie1;
  int? selectedSerie2;
  int? selectedMelhorSerie;

  // Carregar as séries do banco de dados
  Future<void> _fetchSeries() async {
    final db = await DatabaseHelper().database;
    final seriesData = await db.query('series');
    setState(() {
      series = seriesData;
    });
  }

  // Registrar a comparação no banco de dados
  Future<void> _compareSeries() async {
    if (selectedSerie1 == null || selectedSerie2 == null || selectedMelhorSerie == null) {
      return;
    }

    final db = await DatabaseHelper().database;

    await db.insert('comparacoes', {
      'serie1_id': selectedSerie1,
      'serie2_id': selectedSerie2,
      'melhor_serie_id': selectedMelhorSerie,
      'data_comparacao': DateTime.now().toString(),
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Comparação registrada com sucesso!')));
    // Limpar as seleções após o registro
    setState(() {
      selectedSerie1 = null;
      selectedSerie2 = null;
      selectedMelhorSerie = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchSeries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Comparar Séries'), backgroundColor: Colors.deepPurple),
      body: SingleChildScrollView(  // Adicionando rolagem
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Dropdown para selecionar a primeira série
              DropdownButton<int>(
                hint: Text("Selecione a primeira série"),
                value: selectedSerie1,
                items: series.map((serie) {
                  return DropdownMenuItem<int>(  // Exibe as opções das séries
                    value: serie['id'],
                    child: Text(serie['nome']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSerie1 = value;
                    selectedMelhorSerie = null; // Resetar a melhor série quando selecionar uma nova série
                  });
                },
              ),
              // Dropdown para selecionar a segunda série
              DropdownButton<int>(
                hint: Text("Selecione a segunda série"),
                value: selectedSerie2,
                items: series.map((serie) {
                  return DropdownMenuItem<int>(  // Exibe as opções das séries
                    value: serie['id'],
                    child: Text(serie['nome']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSerie2 = value;
                    selectedMelhorSerie = null; // Resetar a melhor série quando selecionar uma nova série
                  });
                },
              ),

              // Exibição dos detalhes das séries selecionadas lado a lado
              if (selectedSerie1 != null && selectedSerie2 != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSerieDetails(selectedSerie1!),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildSerieDetails(selectedSerie2!),
                      ),
                    ],
                  ),
                ),

              // Seleção da melhor série
              if (selectedSerie1 != null && selectedSerie2 != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('Escolha a melhor série:', style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<int>(
                              title: Text('Série 1'),
                              value: selectedSerie1!,
                              groupValue: selectedMelhorSerie,
                              onChanged: (value) {
                                setState(() {
                                  selectedMelhorSerie = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<int>(
                              title: Text('Série 2'),
                              value: selectedSerie2!,
                              groupValue: selectedMelhorSerie,
                              onChanged: (value) {
                                setState(() {
                                  selectedMelhorSerie = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: _compareSeries,
                        child: Text("Registrar Comparação"),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para exibir os detalhes de uma série
  Widget _buildSerieDetails(int serieId) {
    final serie = series.firstWhere((s) => s['id'] == serieId);  // Obtém a série selecionada
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${serie['nome']}', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text('Gênero: ${serie['genero']}'),
            if (serie['descricao'] != null && serie['descricao']!.isNotEmpty)
              Text('Descrição: ${serie['descricao']}'),
            if (serie['foto'] != null && serie['foto']!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Image.file(
                  File(serie['foto']),  // Exibe a imagem da série
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
