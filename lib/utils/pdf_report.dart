import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../database/database_helper.dart';

class GenerateSeriesReport {
  Future<void> generatePdf() async {
    final db = await DatabaseHelper().database;

    // Consulta as séries e a quantidade de vitórias em comparações
    final query = '''
      SELECT series.id, series.nome, series.genero, series.descricao, 
             COUNT(comparacoes.melhor_serie_id) AS vitorias
      FROM series
      LEFT JOIN comparacoes ON series.id = comparacoes.melhor_serie_id
      GROUP BY series.id
      ORDER BY vitorias DESC;
    ''';

    final result = await db.rawQuery(query);

    if (result.isEmpty) {
      print("Nenhuma série encontrada para o relatório.");
      return;
    }

    final pdf = pw.Document();

    // Imagem de capa para o PDF

    // Adiciona uma página no PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Container(
                  width: 300,
                  height: 200,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Relatório de Séries',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Séries Ordenadas por Vitórias',
                style: pw.TextStyle(fontSize: 18),
              ),
              pw.SizedBox(height: 10),
              // Lista as séries no PDF
              pw.ListView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  final serie = result[index];
                  return pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 8),
                    child: pw.Text(
                      '${index + 1}. ${serie['nome']} - Gênero: ${serie['genero']} - Vitórias: ${serie['vitorias']}',
                      style: pw.TextStyle(fontSize: 14),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );

    // Salva e gera o PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
