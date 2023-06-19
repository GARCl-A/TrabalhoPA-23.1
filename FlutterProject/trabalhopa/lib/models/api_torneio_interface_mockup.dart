/*
 * Interface utilizada pelo Controller e implementada por Torneio para interagir com o modelo do sistema
 * 
 * 
*/

import 'api_torneio_dados.dart';
import '../constants/torneio_states.dart';
import '../constants/modos_torneio.dart';

abstract class ApiTorneioMockup {
  // Cria torneio em preparo, retorna identificador do torneio
  Future<({bool success, String? tournamentId, String? adminId})> createTournament();

  // Retorna um map com os dados do torneio, inclusive de etapas e partidas caso já tenham si adicionadas
  Future<({bool success, Map<String, dynamic>? tournament})> getTournamentData(String tournamentId);

  // Retorna código de entrada do torneio
  // Não implementado
  Future<({bool success, String? entryCode})> getEntryCode(String tournamentId);

  Future<({bool success, err_geral err})> setTournamentName(String tournamentId, String adminId, String tournamentName);

  // Define configurações do torneio
  // No momento, incluem apenas configurações quanto a entrada de competitors
  // Verificar se requisitante é admin
  Future<({bool success})> setTournamentConfig(String tournamentId, String adminId, {bool allowRequests, bool acceptRequests});

  // Define configurações do torneio
  // No momento, incluem apenas configurações quanto a entrada de competitors
  // Verificar se requisitante é admin
  Future<({bool success, bool? allowRequests, bool? acceptRequests})> getTournamentConfig(String tournamentId);

  // Retorna lista de competitors inclusos no torneio
  Future<({bool success, List? competitors})> getCompetitors(String tournamentId);

  // Retorna lista de competitors que requisitaram entrada no torneio
  Future<({bool success, List? requests})> getEntryRequests(String tournamentId);

  // Retorna estado do torneio, definido por um enum
  Future<({bool success, enum_estado_torneio? status})> getTournamentStatus(String tournamentId);

  // Confere se adminId é o código de administrador do torneio inserido
  Future<({bool success, bool? isAdmin})> checkIfAdmin(String tournamentId, String adminId);

  // Insere competidor em lista de requests de entrada do torneio por código
  Future<({bool success, err_geral err})> requestEntry(String tournamentId, String competitorName);

  // Aceita competidor da lista de requests
  // Verificar se requisitante é admin
  Future<({bool success, err_geral? err})> acceptEntry(String tournamentId, String adminId, String competitorName);

  // Adiciona competidor diretamente ao torneio manualmente
  Future<({bool success, err_geral? err})> addCompetitor(String tournamentId, String adminId, String competitorName);

  // Remove competidor do torneio
  // Só está disponivel quando torneio está em estado de preparo (salão)
  // Verificar se requisitante é admin
  Future<({bool success, err_geral? err})> removeCompetitor(String tournamentId, String adminId, String competitorName);

  // Seleciona modo de torneio/regras do torneio
  // Verificar se requisitante é admin
  Future<({bool success, err_geral? err})> setRules(String tournamentId, String adminId, enum_modos_torneio regras);

  // Cria a próxima/primeia etapa do torneio
  // Etapas anteriores devem ser concluídas e torneio deve estar em estado de interlúdio ou de preparo
  // Caso não tenha próxima etapa (Ex um jogador restante em eliminação simples), o torneio
  // é finalizado
  Future<
      ({
        bool success,
        bool tournamentOver,
        err_geral? err,
        Map<String, dynamic>? nextRound
      })> createNextRound(String tournamentId, String adminId);

  // Retorna a etapa atual do torneio, contendo uma lista das partidas e seus dados
  // Formato das partidas dependem do modo de torneio selecionado
  Future<({bool success, Etapa? currentRound})> getCurrentRound(String tournamentId);

  // Retorna todas as etapa atual do torneio, contendo uma lista das partidas e seus dados
  // Formato das partidas dependem do modo de torneio selecionado
  Future<({bool success, List<Etapa>? rounds})> getAllRounds(String tournamentId);

  // Valida e registra dados inseridos em partidas da etapa atual
  // Verificar se requisitante é admin
  Future<({bool success, err_geral? err})> finishRound(String tournamentId, String adminId, Map<String, dynamic> currentRound);

  // Retorna uma lista com os dados de performance dos competitors na partida
  Future<({bool success, Placar? score})> getScore(String tournamentId, String adminId);

  // Verificar se requisitante é admin
  Future<({bool success})> goBackRound(String tournamentId, String adminId);
}
