import 'package:flutter/material.dart';
import 'criar_torneio.dart';
import 'entrar_torneio.dart';
import 'visualizar_brackets.dart';
import 'visualizar_placar.dart';
import 'gerenciar_torneio.dart';

class TelaInicial extends StatefulWidget {
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    CriarTorneio(),
    EntrarTorneio(),
    HorizontalTablePage(),
    VisualizarPlacar(),
    GerenciarTorneio(),
  ];

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('PA - WIZ'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Container(
                alignment: Alignment.center,
                child: const CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('lib/assets/logo.png'),
                ),
              ),
            ),
            ListTile(
              title: const Text('Criar Torneio'),
              onTap: () {
                _changeTab(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Entrar em um Torneio'),
              onTap: () {
                _changeTab(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Visualizar Brackets'),
              onTap: () {
                _changeTab(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Visualizar Placar'),
              onTap: () {
                _changeTab(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Gerenciar Torneio'),
              onTap: () {
                _changeTab(4);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _tabs[_currentIndex],
    );
  }
}
