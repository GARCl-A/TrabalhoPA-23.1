import 'package:flutter/material.dart';

class CriarTorneio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Torneio'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Nome do Torneio',
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Tipo de Torneio',
              ),
              items: [
                DropdownMenuItem(
                  value: 'Tipo 1',
                  child: Text('Tipo 1'),
                ),
                DropdownMenuItem(
                  value: 'Tipo 2',
                  child: Text('Tipo 2'),
                ),
                // Adicione mais opções de tipo de torneio conforme necessário
              ],
              onChanged: (value) {
                // Lógica para tratar a seleção do tipo de torneio
              },
            ),
            SizedBox(height: 16.0),
            Text(
                'Código de Entrada: 12345'), // Exemplo de código de entrada fixo
            ElevatedButton(
              onPressed: () {
                // Lógica para copiar o código de entrada para a área de transferência
              },
              child: Text('Copiar Código'),
            ),
            SizedBox(height: 16.0),
            Text('Jogadores no Torneio:'),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text('Jogador 1'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            // Lógica para aceitar o jogador
                          },
                          icon: Icon(Icons.check),
                        ),
                        IconButton(
                          onPressed: () {
                            // Lógica para rejeitar o jogador
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text('Jogador 2'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            // Lógica para aceitar o jogador
                          },
                          icon: Icon(Icons.check),
                        ),
                        IconButton(
                          onPressed: () {
                            // Lógica para rejeitar o jogador
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  // Adicione mais jogadores da lista conforme necessário
                ],
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Lógica para adicionar jogador manualmente
              },
              child: Text('Adicionar Jogador Manualmente'),
            ),
          ],
        ),
      ),
    );
  }
}
