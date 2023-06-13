// Geração de strings aleatórias para servir como código de torneio
// Deve ser passado posteriormente para torneio.dart
import 'dart:math';
Random _rnd = Random();
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));


bool checkNomeCompetidor (String nome_competidor)
{
  return RegExp(r'^[A-Za-z0-9]+$').hasMatch(nome_competidor);

}