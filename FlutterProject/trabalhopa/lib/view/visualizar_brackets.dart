import 'package:flutter/material.dart';
import 'dart:math';
import '/controller/visualizar_brackets_controller.dart';

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

class HorizontalTablePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HorizontalTablePage();
}

class _HorizontalTablePage extends State<HorizontalTablePage> {
  bool _validTournament = false;
  final TextEditingController _tournamentId = TextEditingController();
  // Map<String, dynamic> _tournamentData = {};
  List<List<String>> rowData = [];
  List<String> columnTitles = [];

  void showData(newTournamentData) {
    setState(() {
      _validTournament = true;
    });
    // setState(() {
    //   _tournamentData = newTournamentData;
    // });
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

  SingleChildScrollView showTournamentData() {
    dynamic returnComponent;

    // if (_tournamentData["competitors"].length > 0) {
        TableSize dimensions = calculateTableSize(7); // calculateTableSize(_tournamentData["competitors"].length);

        rowData = List.generate(
            dimensions.rows,
            (index) => List.generate(
                dimensions.columns,
                (subIndex) => //'${(_tournamentData["competitors"][(index * dimensions.columns) + subIndex + 1])}',
                'Competitor ${(index * dimensions.columns) + subIndex + 1}',
            ),
        );
        columnTitles = List.generate(
            dimensions.columns,
            (index) => 'Etapa ${index + 1}',
        );

        returnComponent = SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                columns: _buildColumns(),
                rows: _buildRows(),
            )
        ); 
    // } 
    // else {
    //     returnComponent = const SingleChildScrollView(
    //         scrollDirection: Axis.horizontal,
    //         child: Text("Sem competidores.")
    //     ); 
    // }
    


    return returnComponent;
  }

  // dynamic tournamentIdPrompt() {
  //   return Center(
  //       child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //               const SizedBox(height: 20),
  //               SizedBox(
  //                   width: 300, // Max width for TextField
  //                   child: TextField(
  //                       controller: _tournamentId,
  //                       decoration: InputDecoration(
  //                           labelText: 'Código do Torneio',
  //                           filled: true,
  //                           fillColor: Colors.white,
  //                           contentPadding: const EdgeInsets.all(8.0),
  //                           border: OutlineInputBorder(
  //                               borderRadius: BorderRadius.circular(10.0),
  //                           ),
  //                       ),
  //                   ),
  //               ),
  //               const SizedBox(height: 16.0),
  //               ElevatedButton(
  //                   onPressed: () async {
  //                       // check if tournament exists
  //                       var res = await getTorneioInfo(_tournamentId.text);
  //                       if (res.sucesso) {
  //                           showData(res.tournamentData);
  //                       }
  //                   },
  //                   child: const Text('Ver Brackets'),
  //               )
  //           ]
  //       )
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horizontal Table'),
      ),
      //body: _validTournament ? showTournamentData() : tournamentIdPrompt(),
      body: showTournamentData(),
    );
  }  
}