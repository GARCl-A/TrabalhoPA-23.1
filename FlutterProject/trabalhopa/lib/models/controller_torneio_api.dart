/*
 * Interface utilizada pelo Controller e implementada por Torneio para interagir com o modelo do sistema
 * 
 * 
*/

import 'controller_torneio_api_dados.dart';
import '../constants/torneio_states.dart';
import '../constants/modos_torneio.dart';

abstract class Torneio_API
{
  // Cria torneio em preparo, retorna identificador do torneio
  Future<({bool sucesso, String ? id_torneio, String ? id_admin})>
  criar_torneio
  ();

  // Retorna um map com os dados do torneio, inclusive de etapas e partidas caso já tenham si adicionadas
  Future<({bool sucesso, Map<String,dynamic> ? torneio})>
  get_torneio_map
  (String id_torneio);

  // Retorna código de entrada do torneio
  // Não implementado
  ({bool sucesso, String ? codigo_entrada})
  get_codigo_entrada
  (String id_torneio);

  // Define configurações do torneio
  // No momento, incluem apenas configurações quanto a entrada de competidores
  // Verificar se requisitante é admin
  ({bool sucesso})
  set_torneio_config
  (String id_torneio, String id_admin, {bool permitir_pedidos, bool aceitar_pedidos});

  // Define configurações do torneio
  // No momento, incluem apenas configurações quanto a entrada de competidores
  // Verificar se requisitante é admin
  ({bool sucesso, bool ? permitir_pedidos, bool ? aceitar_pedidos})
  get_torneio_config
  (String id_torneio);
  
  // Retorna lista de competidores inclusos no torneio
  ({bool sucesso, List ? competidores})
  get_competidores
  (String id_torneio);

  // Retorna lista de competidores que requisitaram entrada no torneio
  ({bool sucesso, List ? pedidos})
  get_pedidos_entrada
  (String id_torneio);

  // Retorna estado do torneio, definido por um enum
  ({bool sucesso, enum_estado_torneio ? estado})
  get_estado_torneio
  (String id_torneio);

  // Confere se id_admin é o código de administrador do torneio inserido
  Future<({bool sucesso, bool ? is_admin})>
  check_if_admin
  (String id_torneio, String id_admin);


  // Insere competidor em lista de pedidos de entrada do torneio
  ({bool sucesso, err_pedir_entrada ? err})
  pedir_entrada
  (String id_torneio, String nome_competidor);

  // Aceita competidor da lista de pedidos
  // Verificar se requisitante é admin
  ({bool sucesso, err_pedir_entrada ? err})
  aceitar_entrada
  (String id_torneio, String id_admin, String nome_competidor);

  // Adiciona competidor diretamente ao torneio
  Future<({bool sucesso, err_geral ? err})> 
  adicionar_competidor 
  (String id_torneio, String id_admin, String nome_competidor);

  // Remove competidor do torneio
  // Só está disponivel quando torneio está em estado de preparo (salão)
  // Verificar se requisitante é admin
  Future<({bool sucesso, err_geral ? err})>
  remover_competidor   
  (String id_torneio, String id_admin, String nome_competidor);

  // Seleciona modo de torneio/regras do torneio
  // Verificar se requisitante é admin
  Future<({bool sucesso, err_geral ? err})>   
  definir_regras       
  (String id_torneio, String id_admin, enum_modos_torneio regras);

  // Cria a próxima/primeia etapa do torneio
  // Etapas anteriores devem ser concluídas e torneio deve estar em estado de interlúdio ou de preparo
  // Caso não tenha próxima etapa (Ex um jogador restante em eliminação simples), o torneio
  // é finalizado
  Future<({bool sucesso, bool torneio_fim, err_geral ? err, Map<String,dynamic> ? proxima_etapa})>  
  criar_proxima_etapa  
  (String id_torneio, String id_admin);

  // Retorna a etapa atual do torneio, contendo uma lista das partidas e seus dados
  // Formato das partidas dependem do modo de torneio selecionado
  ({bool sucesso, Etapa ? etapa_atual})
  get_etapa_atual
  (String id_torneio);

  // Retorna todas as etapa atual do torneio, contendo uma lista das partidas e seus dados
  // Formato das partidas dependem do modo de torneio selecionado
  ({bool sucesso, List <Etapa> ? Etapas})
  get_etapas_torneio
  (String id_torneio);

  // Valida e registra dados inseridos em partidas da etapa atual
  // Verificar se requisitante é admin
  Future <({bool sucesso, err_geral ? err})> 
  concluir_etapa 
  (String id_torneio, String id_admin, Map<String,dynamic> etapa_atual);


  // Retorna uma lista com os dados de performance dos competidores na partida
  ({bool sucesso, Placar ? placar}) 
  get_placar 
  (String id_torneio, String id_admin);
  
  // Verificar se requisitante é admin
  ({bool sucesso}) 
  voltar_etapa 
  (String id_torneio, String id_admin);


}