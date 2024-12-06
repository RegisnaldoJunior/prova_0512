import 'package:flutter/material.dart';
import '../utils/pdf_report.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool _isLoading = false;

  Future<void> _generateReport() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Instanciar a classe GenerateSeriesReport para gerar o relatório
      final pdfGenerator = GenerateSeriesReport();

      // Gerar o relatório PDF
      await pdfGenerator.generatePdf();

      // Informar ao usuário que o relatório foi gerado com sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Relatório gerado com sucesso!')),
      );
    } catch (e) {
      // Se houver erro durante a geração do relatório
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao gerar o relatório: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatório de Comparações de Séries'), backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator() // Mostrar loading enquanto o relatório está sendo gerado
            : ElevatedButton(
                onPressed: _generateReport,
                child: Text('Gerar Relatório'),
              ),
      ),
    );
  }
}
