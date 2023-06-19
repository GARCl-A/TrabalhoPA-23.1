import 'package:flutter/material.dart';

class VisualizarPlacar extends StatelessWidget {
  final List<String> columnTitles = ['Nome', 'Pontos', '%V', '%VO', '%VOJ'];

  final List<List<String>> rowData = [
    ['Competidor A', '10', '80%', '75%', '90%'],
    ['Competidor B', '15', '70%', '60%', '85%'],
    ['Competidor C', '8', '90%', '80%', '95%'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualizar Placar'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Titulo do Torneio',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: _buildColumns(),
              rows: _buildRows(),
            ),
          ),
        ],
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return columnTitles
        .map((title) => DataColumn(
              label: Text(title),
            ))
        .toList();
  }

  List<DataRow> _buildRows() {
    return rowData.map((data) {
      return DataRow(
        cells: data
            .map((cellData) => DataCell(
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      cellData,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ))
            .toList(),
      );
    }).toList();
  }
}

void main() {
  runApp(MaterialApp(
    home: VisualizarPlacar(),
  ));
}