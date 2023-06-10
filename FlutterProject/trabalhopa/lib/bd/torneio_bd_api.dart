/*
 * Interface utilizada por torneio para buscar e armazernar dados
 * 
*/

import '../constants/modos_torneio.dart';
import 'torneio_bd_api_dados.dart';

abstract class BD_API
{
  // Cria um torneio, registrando seu id, id_admin e configuração padrão inicial
  ({String id_torneio, String id_admin})
  criar_torneio
  ();

  // Retorna objeto com informações do torneio
  // Verificar classe de objeto para identificar quais dados são retornados
  ({bool sucesso, TorneioModelo ? torneio})
  get_dados_torneio
  (String id_torneio);

  ({bool sucesso})
  set_torneio_config
  (String id_torneio, {bool? permitir_pedidos, bool? aceitar_pedidos});

  // Adiciona um competidor à lista de pedidos de entrada do torneio.
  ({bool sucesso})
  adicionar_pedido_entrada
  (String id_torneio, String nome_competidor);

  // Adiciona um competidor à lista de pedidos de entrada do torneio.
  ({bool sucesso})
  aceitar_pedido_entrada
  (String id_torneio, String nome_competidor);

  ({bool sucesso})
  adicionar_competidor
  (String id_torneio, String nome_competidor);

  ({bool sucesso})
  remover_competidor
  (String id_torneio, String nome_competidor);

  ({bool sucesso})
  definir_regras
  (String id_torneio, modos_torneio regras);

  
}