import 'package:flutter/material.dart';

class TournamentInfo {
  final String name;
  final int participants;
  final DateTime startDate;

  TournamentInfo(this.name, this.participants, this.startDate);
}

class EntrarTorneio extends StatelessWidget {
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  final ValueNotifier<TournamentInfo> tournamentInfo =
      ValueNotifier<TournamentInfo>(TournamentInfo("", 0, DateTime.now()));
  EntrarTorneio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Entrar em um Torneio'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder<TournamentInfo>(
                valueListenable: tournamentInfo,
                builder: (context, value, child) {
                  return Container(
                    constraints: const BoxConstraints(
                      maxWidth: 300, // Set your desired maximum width here
                    ),
                    child: Card(
                      elevation: 2.0, // This adds a small shadow
                      child: Padding(
                        // This adds padding inside the Card
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Text('Nome do Torneio: ${value.name}',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                            const Divider(), // This creates a line separation
                            Text('Numero de Participantes: ${value.participants}'),
                            const Divider(),
                            Text('Data de Início: ${value.startDate.toString()}'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 300, // Max width for TextField
                child: TextField(
                  controller: nicknameController,
                  decoration: InputDecoration(
                    labelText: 'Nome do Competidor',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 300, // Max width for TextField
                child: TextField(
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: 'Código do Torneio',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Get the values from your text fields or your server
                  String name = codeController.text; // This is just an example
                  int participants =
                      0; // This should be fetched from your server
                  DateTime startDate =
                      DateTime.now(); // This should be fetched from your server

                  // Create a new TournamentInfo object and assign it to tournamentInfo
                  tournamentInfo.value =
                      TournamentInfo('Nome', participants, startDate);
                },
                child: const Text('Enter'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
