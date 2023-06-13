import 'package:flutter/material.dart';
import 'dart:math';

class TableSize {
  final int rows;
  final int columns;

  TableSize(this.rows, this.columns);
}

double log2(num x) => log(x) / log(2);

TableSize calculateTableSize(int numberOfCompetitors) {
  int rows = (numberOfCompetitors / 2).ceil();
  int columns = (log2(numberOfCompetitors + 1).ceil());

  return TableSize(rows, columns);
}

class HorizontalTablePage extends StatelessWidget {
  final int numberOfCompetitors = 10;

  final List<String> columnTitles = List.generate(
    calculateTableSize(10).columns,
    (index) => 'Header ${index + 1}',
  );

  final List<List<String>> rowData = List.generate(
    calculateTableSize(10).rows,
    (index) => List.generate(
      calculateTableSize(10).columns,
      (subIndex) =>
          'Competitor ${(index * calculateTableSize(10).columns) + subIndex + 1}',
    ),
  );

  HorizontalTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horizontal Table'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            columns: _buildColumns(),
            rows: _buildRows(),
          ),
        ),
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
                    padding: const EdgeInsets.all(8.0),
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

