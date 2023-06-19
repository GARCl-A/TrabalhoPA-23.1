import 'package:flutter/material.dart';
import '/controller/criar_torneio_controller.dart';


class CriarTorneio extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CriarTorneio();
}
class _CriarTorneio extends State<CriarTorneio> {
  final TextEditingController currentTournamentName = TextEditingController();
  final TextEditingController currentTournamentType = TextEditingController();
  final TextEditingController currentTournamentId = TextEditingController();

  void showCode(newCode) {
    setState(() {
      currentTournamentId.text = newCode;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Torneio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nome do Torneio',
              ),
              onChanged: (value) {
                currentTournamentName.text = value;
              },
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Tipo de Torneio',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Eliminação Simples',
                  child: Text('Eliminação Simples'),
                ),
                DropdownMenuItem(
                  value: 'Duplas',
                  child: Text('Duplas'),
                ),
                // Adicione mais opções de tipo de torneio conforme necessário
              ],
              onChanged: (value) {
                // Lógica para tratar a seleção do tipo de torneio
                currentTournamentType.value = TextEditingValue(text: value ?? '');
              },
            ),
            const SizedBox(height: 16.0),
            Text('Código de Entrada: ${currentTournamentId.text}'), // Exemplo de código de entrada fixo
            ElevatedButton(
              onPressed: () {
                // Lógica para copiar o código de entrada para a área de transferência
              },
              child: const Text('Copiar Código'),
            ),
            const SizedBox(height: 16.0),
            // Text('Jogadores no Torneio:'),
            // Expanded(
            //   child: ListView(
            //     children: [
            //       ListTile(
            //         title: Text('Jogador 1'),
            //         trailing: Row(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             IconButton(
            //               onPressed: () {
            //                 // Lógica para aceitar o jogador
            //               },
            //               icon: Icon(Icons.check),
            //             ),
            //             IconButton(
            //               onPressed: () {
            //                 // Lógica para rejeitar o jogador
            //               },
            //               icon: Icon(Icons.close),
            //             ),
            //           ],
            //         ),
            //       ),
            //       ListTile(
            //         title: Text('Jogador 2'),
            //         trailing: Row(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             IconButton(
            //               onPressed: () {
            //                 // Lógica para aceitar o jogador
            //               },
            //               icon: Icon(Icons.check),
            //             ),
            //             IconButton(
            //               onPressed: () {
            //                 // Lógica para rejeitar o jogador
            //               },
            //               icon: Icon(Icons.close),
            //             ),
            //           ],
            //         ),
            //       ),
            //       // Adicione mais jogadores da lista conforme necessário
            //     ],
            //   ),
            // ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // currentTournamentId.text = await createTournament(currentTournamentName.text, currentTournamentType.text) ?? '';
                showCode(await createTournament(currentTournamentName.text, currentTournamentType.text) ?? '');
              },
              child: const Text('Criar Torneio'),
            ),
          ],
        ),
      ),
    );
  }
}
