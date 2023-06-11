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
  ({bool sucesso, String ? id_torneio, String ? id_admin})
  criar_torneio
  ();

  // Retorna código de entrada do torneio
  ({bool sucesso, String ? codigo_entrada})
  get_codigo_entrada
  (String id_torneio);

  // Define configurações do torneio
  // No momento, incluem apenas configurações quanto a entrada de competidores
  // Verificar se requisitante é admin
  ({bool sucesso})
  set_torneio_config
  (String id_torneio, {bool permitir_pedidos, bool aceitar_pedidos});

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
  ({bool sucesso, bool ? is_admin})
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
  (String id_torneio, String nome_competidor);

  // Adiciona competidor diretamente ao torneio
  ({bool sucesso, err_comp_add ? err}) 
  adicionar_competidor 
  (String id_torneio, String nome_competidor);

  // Remove competidor do torneio
  // Só está disponivel quando torneio está em estado de preparo (salão)
  // Verificar se requisitante é admin
  ({bool sucesso, err_comp_rem ? err})
  remover_competidor   
  (String id_torneio, String nome_competidor);

  // Seleciona modo de torneio/regras do torneio
  // Verificar se requisitante é admin
  ({bool sucesso, err_regras ? err})   
  definir_regras       
  (String id_torneio, enum_modos_torneio regras);

  // Cria a próxima/primeia etapa do torneio
  // Etapas anteriores devem ser concluídas e torneio deve estar em estado de interlúdio
  // Verificar se requisitante é admin
  ({bool sucesso, err_criar_etapa ? err, Etapa ? proxima_etapa})   
  criar_proxima_etapa  
  (String id_torneio);

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
  // Razão de erro pode variar entre um tipo de torneio e outro
  // Adiciona-se outro parametro (msg), com razão específica
  // Verificar se requisitante é admin
  ({bool sucesso, err_concluir_etapa ? err, String ? msg}) 
  concluir_etapa 
  (String id_torneio, Etapa etapa_atual);

  ({bool sucesso, Placar ? placar}) 
  get_placar 
  (String id_torneio);
  
  // Verificar se requisitante é admin
  ({bool sucesso}) 
  voltar_etapa 
  (String id_torneio);


}