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

enum estado_torneio
{
  em_preparo,
  em_etapa,
  interludio,
  finalizado
}



/////////////////////////////////////////////////////////////////////////////////////////////
/// Mensagens de erro
////////////////////////////////////////////////////////////////////////////////////////////

enum err_comp_add
{
  nome_duplicado,
  torneio_cheio,
  torneio_inexistente
}

enum err_pedir_entrada
{
  nome_invalido,
  codigo_entrada_invalido
}

enum err_comp_rem
{
  comp_inexistente,
  torneio_em_progresso
}

enum err_regras
{
  regras_indeterminadas,    // Regras do torneio não foram escolhidas
  regras_inexistentes,      // Regras selecionadas não existem
  torneio_em_progresso
}

enum err_criar_etapa
{
  torneio_invalido,         // Criação da primeira etapa e torneio ainda não preparado
  etapa_nao_concluida
}

enum err_concluir_etapa
{
  partida_invalida
}
