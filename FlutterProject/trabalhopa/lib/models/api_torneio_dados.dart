abstract class Partida {}

class Etapa
{
  int nro_etapa;
  List <Partida> partidas;

  Etapa(this.nro_etapa, this.partidas);

}

abstract class DadosCompetidores {}

class Placar
{
  List <DadosCompetidores> dados_competidores;

  Placar(this.dados_competidores);
}

////////////////////////////////////////////////////////////////////////////////////////
/// Torneio MAP
/// /////////////////////////////////////////////////////////////////////////////////////
/*
Map <String,dynamic> torneio = 
    {
      'id_torneio'          :     codigoTorneio,
      'id_admin'            :     codigoAdmin,
      'codigo_entrada'      :     codigoEntrada,

      'nome_torneio'        :     'Meu Torneio'

      'estado_torneio'      :     enum_estado_torneio.em_preparo.index,

      'permitir_pedidos'    :     true,
      'aceitar_pedidos'     :     false,

      'competidores'        :     [],
      'pedidos_comp'        :     [],
      
      'regras'              :     enum_modos_torneio.nao_selecionado.index,

      'etapas'              :     [],

      'dados_competidores'  :     []
    };

*/

/////////////////////////////////////////////////////////////////////////////////////////////
/// Mensagens de erro
////////////////////////////////////////////////////////////////////////////////////////////

enum err_comp_add
{
  none,
  nao_autorizado,
  nome_duplicado,
  torneio_cheio,
  torneio_inexistente,
  erro_bd
}

enum err_pedir_entrada
{
  none,
  nome_invalido,
  codigo_entrada_invalido,
  acesso_negado,
  erro_bd
}

enum err_comp_rem
{
  none,
  torneio_inexistente,
  comp_inexistente,
  torneio_em_progresso,
  erro_bd
}

enum err_regras
{
  none,
  regras_indeterminadas,    // Regras do torneio não foram escolhidas
  regras_inexistentes,      // Regras selecionadas não existem
  torneio_em_progresso,
  torneio_inexistente,
  erro_bd
}

enum err_criar_etapa
{
  none,
  torneio_invalido,         // Criação da primeira etapa e torneio ainda não preparado
  etapa_nao_concluida
}

enum err_concluir_etapa
{
  none,
  partida_invalida
}


enum err_geral
{
  none,
  nao_autorizado,
  torneio_inexistente,
  torneio_cheio,
  erro_bd,
  nome_invalido,
  nome_duplicado,
  pedido_negado,
  regras_indeterminadas,
  torneio_em_progresso,
  etapa_nao_concluida,
  etapa_invalida,
  estado_invalido,
  partida_invalida
}