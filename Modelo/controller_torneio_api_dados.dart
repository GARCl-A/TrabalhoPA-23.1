abstract class Partida {}

class Etapa
{
  int inteiro;
  List <Partida> partidas;

  Etapa(this.inteiro, this.partidas);

}

abstract class DadosCompetidores {}

class Placar
{
  List <DadosCompetidores> dados_competidores;

  Placar(this.dados_competidores);
}



/////////////////////////////////////////////////////////////////////////////////////////////
/// Mensagens de erro
////////////////////////////////////////////////////////////////////////////////////////////

enum err_comp_add
{
  none,
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
