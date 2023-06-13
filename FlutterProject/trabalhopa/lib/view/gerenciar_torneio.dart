import 'package:flutter/material.dart';

class GerenciarTorneio extends StatelessWidget {
  final String tituloTorneio = 'Torneio de Exemplo';
  final String codigoTorneio = 'ABCDE12345';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Torneio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tituloTorneio,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              codigoTorneio,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32.0),
            Container(
              width: 300.0,
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para iniciar/parar a partida
                },
                child: const Text('Iniciar/Parar Partida'),
              ),
            ),
            const SizedBox(height: 8.0), // Diminui a distância vertical
            Container(
              width: 300.0,
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para alterar o relógio
                },
                child: const Text('Alterar Relógio'),
              ),
            ),
            const SizedBox(height: 8.0), // Diminui a distância vertical
            Container(
              width: 300.0,
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para voltar à rodada anterior
                },
                child: const Text('Voltar à Rodada'),
              ),
            ),
            const SizedBox(height: 8.0), // Diminui a distância vertical
            Container(
              width: 300.0,
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para gerenciar os participantes
                },
                child: const Text('Gerenciar Participantes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

