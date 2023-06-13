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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('PA - WIZ'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Criar Torneio'),
              onTap: () {
                _changeTab(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Entrar em um Torneio'),
              onTap: () {
                _changeTab(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Visualizar Brackets'),
              onTap: () {
                _changeTab(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Visualizar Placar'),
              onTap: () {
                _changeTab(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Gerenciar Torneio'),
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

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
