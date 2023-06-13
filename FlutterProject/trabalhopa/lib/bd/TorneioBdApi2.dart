/*
 * Interface utilizada por torneio para buscar e armazernar dados
 * 
*/

import '../constants/modos_torneio.dart';

abstract class TorneioBdApi
{
  // Cria um torneio, registrando seu id e id_admin, 
  Future<({bool sucesso})>
  criarTorneio
  (Map<String,dynamic> torneioInicial);

  // Retorna objeto com informações do torneio
  Future<({bool sucesso, Map<String,dynamic> ? torneio})>
  getTorneio
  (String idTorneio);

  Future<({bool sucesso})>
  replaceTorneio
  (String idTorneio, Map<String,dynamic> torneioAlterado);

  Future<({bool sucesso})>
  deleteTorneio
  (String idTorneio);
  
}