import 'package:flutter/material.dart';
import 'criar_torneio.dart';
import 'entrar_torneio.dart';

class TelaInicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('lib/assets/logo.png'),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CriarTorneio()),
                      );
                    },
                    child: Text('Criar torneio'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EntrarTorneio()),
                      );
                    },
                    child: Text('Entrar em um torneio'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
