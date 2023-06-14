// Geração de strings aleatórias para servir como código de torneio
// Deve ser passado posteriormente para torneio.dart
import 'dart:math';
Random _rnd = Random();
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));



// Verificar nome de competidor
bool checkNomeCompetidor (String nome_competidor)
{

  // Nome maior que 3 caracteres e menor que 15 caracteres (sem contar espaço)
  String nome_s_esp = nome_competidor.replaceAll(' ', '');
  if (nome_s_esp.length < 3 
  || nome_s_esp.length > 15)   return false;

  // Somente letras, números e espaços
  if (RegExp(r'^[A-Za-z0-9 ]+$').hasMatch(nome_competidor) == false) return false;

  return true;

}