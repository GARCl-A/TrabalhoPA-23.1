/*
 * Implementação da interface tournament-controlador
 * Contém lógica de alto nível do aplicativo, delegando detalhes específicos do tournament para o serviço "Regras"
*/

import 'package:trabalhopa/models/api_torneio_dados.dart';

import 'api_torneio_interface_mockup.dart' show ApiTorneioMockup;
import 'api_torneio_dados.dart'
    show Etapa, Placar, err_geral; //err_pedir_entrada;
import '../constants/torneio_states.dart';
import '../constants/modos_torneio.dart';
import '../bd/MongoImpl2.dart';

import '../util/string.dart';

import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as uhtml;

// check if a tournament entry exists with a targetKey prop containing a targetValue
Future<bool> checkTournamentWithPropValue(String targetKey, dynamic targetValue) async {
    final jsonString = uhtml.window.localStorage['mockDB'];
    final jsonData = jsonString != null ? json.decode(jsonString) : {};

    if (jsonData is Map<String, dynamic>) {
        for (final entry in jsonData.entries) {
            final value = entry.value;
            if (value is Map<String, dynamic> && value.containsKey(targetKey) && value[targetKey] == targetValue) {
                return true;
            }
        }
    }
    
    return false;
}

// get tournament data
Future<Map<String, dynamic>?> getTournamentMap(String tournamentId) async {
    final jsonString = uhtml.window.localStorage['mockDB'];
    final jsonData = jsonString != null ? json.decode(jsonString) : {};

    if (jsonData is Map<String, dynamic> && jsonData.containsKey(tournamentId)) {
        final targetValue = jsonData[tournamentId];
        if (targetValue is Map<String, dynamic>) {
            return targetValue;
        } 
    }

    return null;
}

// get a tournament entry with targetKey ID, then return the value of its propKey value
Future<dynamic> getTournamentPropValue(String tournamentId, String tournamentProp) async {
    final jsonString = uhtml.window.localStorage['mockDB'];
    final jsonData = jsonString != null ? json.decode(jsonString) : {};

    if (jsonData is Map<String, dynamic> && jsonData.containsKey(tournamentId)) {
        final targetValue = jsonData[tournamentId];
        if (targetValue is Map<String, dynamic> && targetValue.containsKey(tournamentProp)) {
            return targetValue[tournamentProp];
        }
    }

    return null;
}

// add tournament
Future<bool> addTournamentToJson(String tournamentId, dynamic tournamentData) async {
    final jsonString = uhtml.window.localStorage['mockDB'];
    final jsonData = jsonString != null ? json.decode(jsonString) : {};

    if (jsonData is Map<String, dynamic>) {
        jsonData[tournamentId] = tournamentData;
        final updatedJsonString = json.encode(jsonData);
        uhtml.window.localStorage['mockDB'] = updatedJsonString;
        return true;
    }
    
    return false;
}

Future<bool> replaceTournamentData(String tournamentId, Map<String, dynamic> newTournamentData) async {
    final jsonString = uhtml.window.localStorage['mockDB'];
    final jsonData = jsonString != null ? json.decode(jsonString) : {};

    if (jsonData is Map<String, dynamic> && jsonData.containsKey(tournamentId)) {
        jsonData[tournamentId] = newTournamentData;
        final updatedJsonString = json.encode(jsonData);
        uhtml.window.localStorage['mockDB'] = updatedJsonString;
        return true;
    }
    
    return false;
}

class TorneioMockup implements ApiTorneioMockup  {

  // Cria tournament em preparo, retorna identificador do tournament
  @override
  Future<({bool success, String ? tournamentId, String ? adminId})> createTournament() async {
    // Gera strings aleatórias para adminId e tournamentId
    // Confere se não há outro tournament com mesmo id
    // Insere tournament no banco com outros dados de valor padrão

    String tournamentCode = '';
    int length = 10;

    var resultado = false;
    for (int i = 0; i < 100; i++) {
      tournamentCode = getRandomString(length);
      resultado = await checkTournamentWithPropValue('tournamentId', tournamentCode);
      if (resultado == false) break;
    }

    if (resultado) {
      return (success:false ,adminId: null, tournamentId: null);
    }
     
    String adminCode = getRandomString(length);
    String entryCode = getRandomString(length);


    Map <String,dynamic> tournament = {
      'tournamentId'       : tournamentCode,
      'adminId'            : adminCode,
      'entryCode'          : entryCode,

      'tournamentName'     : 'Meu Torneio',

      'tournamentStatus'   : enum_estado_torneio.em_preparo.index,

      'allowRequests'      : true,
      'acceptRequests'     : false,

      'competitors'        : [],
      'competitorRequests' : [],
      
      'rules'              : enum_modos_torneio.nao_selecionado.index,

      'etapas'             : [],

      'dados_competidores' : []
    };

    var resEscrita = await addTournamentToJson(tournamentCode, tournament);

    if (resEscrita == false) {
      return (success:false, adminId: null, tournamentId: null);
    }

    return (success:true, adminId: adminCode, tournamentId: tournamentCode);
  }

  @override
  Future<({bool success, Map<String, dynamic> ? tournament})> getTournamentData(String tournamentId) async {
    var resposta = await getTournamentMap(tournamentId);
    if (resposta == null) {
      return (success:false, tournament : null);
    }

    return (success:true, tournament: resposta);
  }

  @override
  Future<({bool? isAdmin, bool success})> checkIfAdmin(String tournamentId, String adminId) async {
    var resposta = await getTournamentMap(tournamentId);
    if (resposta == null) {
      return (success:false, isAdmin : null);
    }

    if(adminId == resposta['adminId']) {
      return (success:true, isAdmin:true);
    }

    return (success:true, isAdmin:false);
  }

  @override
  Future<({err_geral err, bool success})> addCompetitor(String tournamentId, String adminId, String competitorName) async {
    // Autorização
    var resposta = await checkIfAdmin(tournamentId, adminId);
    if (resposta.success == false) return (success:false, err: err_geral.torneio_inexistente);
    if (resposta.isAdmin == false) return (success:false, err: err_geral.nao_autorizado);

    if (checkNomeCompetidor(competitorName) == false) return (success:false, err: err_geral.nome_invalido);

    var res_get = await getTournamentData(tournamentId);
    if (res_get.success == false) return (success:false, err: err_geral.torneio_inexistente);
    if (res_get.tournament?['competitors'] == null) return (success:false, err: err_geral.erro_bd);

    List compet = res_get.tournament!['competitors'];
    if(compet.contains(competitorName) == true) return (success:false, err: err_geral.nome_duplicado);
    compet.add(competitorName);
    res_get.tournament!['competitors'] = compet;

    var res_replace = await replaceTournamentData(tournamentId, res_get.tournament??{});
    if(res_replace == false) return (success:false, err: err_geral.erro_bd);

    return (success: true, err: err_geral.none);
  }

  @override
  Future<({err_geral? err, bool success})> removeCompetitor(String tournamentId, String adminId, String competitorName) async {
    // Autorização
    var resposta = await checkIfAdmin(tournamentId, adminId);
    if (resposta.isAdmin == null) return (success:false, err: err_geral.torneio_inexistente);
    if (resposta.isAdmin == false) return (success:false, err: err_geral.nao_autorizado);

    var res_get = await getTournamentData(tournamentId);
    if (res_get.success == false) return (success:false, err: err_geral.torneio_inexistente);
    if (res_get.tournament?['competitors'] == null) return (success:false, err: err_geral.erro_bd);

    List compet = res_get.tournament!['competitors'];
    if(compet.contains(competitorName) == false) return (success:false, err: err_geral.nome_invalido);
    compet.remove(competitorName);
    res_get.tournament!['competitors'] = compet;

    var res_replace = await replaceTournamentData(tournamentId, res_get.tournament??{});
    if(res_replace == false) return (success:false, err: err_geral.erro_bd);

    return (success: true, err: err_geral.none);
  }

  @override
  Future<({err_geral? err, bool success})> setRules(String tournamentId, String adminId, enum_modos_torneio rules) async {
    // Autorização
    var resposta = await checkIfAdmin(tournamentId, adminId);
    if (resposta.success == false) {
      return (success:false, err: err_geral.torneio_inexistente);
    }
    if (resposta.isAdmin == false) {
      return (success:false, err: err_geral.nao_autorizado);
    }

    var res_get = await getTournamentData(tournamentId);
    if (res_get.success == false) {
      return (success:false, err: err_geral.torneio_inexistente);
    }
    if (res_get.tournament?['tournamentId'] == null) {
      MongoConnection.close();
      return (success:false, err: err_geral.erro_bd);
    }

    res_get.tournament!['rules'] = rules.index;

    var res_replace = await replaceTournamentData(tournamentId, res_get.tournament??{});
    if(res_replace == false) {
      return (success:false, err: err_geral.erro_bd);
    }

    return (success: true, err: err_geral.none);
  }

  @override
  Future<({bool success, err_geral err})> setTournamentName(String tournamentId, String adminId, String tournamentName) async {
    // Autorização
    var resposta = await checkIfAdmin(tournamentId, adminId);
    if (resposta.success == false) {
      return (success:false, err: err_geral.torneio_inexistente);
    }
    if (resposta.isAdmin == false) {
      return (success:false, err: err_geral.nao_autorizado);
    }

    var res_get = await getTournamentData(tournamentId);
    if (res_get.success == false) {
      return (success:false, err: err_geral.erro_bd);
    }

    if (checkNomeTorneio(tournamentName) != true) {
      return (success:false, err: err_geral.nome_invalido);
    }

    res_get.tournament?['tournamentName'] = tournamentName;

    var res_repl = await replaceTournamentData(tournamentId, res_get.tournament??{});

    if (res_repl == false ) {
      return (success:false, err: err_geral.erro_bd);
    }

    return (success:true, err: err_geral.none);  
  }

  @override
  Future<({err_geral err, bool success})> requestEntry(String tournamentId, String competitorName) async {
    var res_get = await getTournamentData(tournamentId);
    if (res_get.success == false) return (success:false, err: err_geral.none);

    if (res_get.tournament?['allowRequests'] == false) return (success:false, err: err_geral.pedido_negado);

    if (checkNomeCompetidor(competitorName) == false) return (success:false, err: err_geral.nome_invalido);

    List comp = res_get.tournament?['competitors'];
    List pedidos = res_get.tournament?['competitorRequests'];
    if (comp.contains(competitorName) || pedidos.contains(competitorName))
    {
      return (success:false, err: err_geral.nome_duplicado);
    }

    if (res_get.tournament?['acceptRequests'] == true)
    {
      comp.add(competitorName);
      res_get.tournament?['competitors'] = comp;
    }
    else
    {
      pedidos.add(competitorName);
      res_get.tournament?['competitorRequests'] = pedidos;
    }
    
    var res_repl = await replaceTournamentData(tournamentId, res_get.tournament??{});
    if (res_repl == false ) return (success:false, err: err_geral.erro_bd);
    return (success:true, err: err_geral.none);
  }
  
  @override
  Future<({err_geral? err, bool success})> acceptEntry(String tournamentId, String adminId, String competitorName) async {
    // Autorização
    var resposta = await checkIfAdmin(tournamentId, adminId);
    if (resposta.success == false) return (success:false, err: err_geral.torneio_inexistente);
    if (resposta.isAdmin == false) return (success:false, err: err_geral.nao_autorizado);

    var res_get = await getTournamentData(tournamentId);
    if (res_get.success == false) return (success:false, err: err_geral.erro_bd);

    if (checkNomeCompetidor(competitorName) == false) return (success:false, err: err_geral.nome_invalido);

    List comp = res_get.tournament?['competitors'];
    List pedidos = res_get.tournament?['competitorRequests'];
    if (comp.contains(competitorName) || !pedidos.contains(competitorName))
    {
      return (success:false, err: err_geral.nome_invalido);
    }

    pedidos.remove(competitorName);
    comp.add(competitorName);
    res_get.tournament?['competitors'] = comp;
    res_get.tournament?['competitorRequests'] = pedidos;

    var res_repl = await replaceTournamentData(tournamentId, res_get.tournament??{});
    if (res_repl == false ) return (success:false, err: err_geral.erro_bd);
    return (success:true, err: err_geral.none);
  }
  
  @override
  Future<({err_geral? err, bool success})> finishRound(String tournamentId, String adminId, Map<String,dynamic> currentRound) async {
    // TODO: implement concluir_etapa
    throw UnimplementedError();
  }
  
  @override
  Future<({err_geral? err, Map<String,dynamic>? nextRound, bool success, bool tournamentOver})> createNextRound(String tournamentId, String adminId) async {
    // TODO: implement criar_proxima_etapa
    throw UnimplementedError();
  }
  
  @override
  Future<({String? entryCode, bool success})> getEntryCode(String tournamentId) async {
    // TODO: implement get_codigo_entrada
    throw UnimplementedError();
  }
  
  @override
  Future<({List? competitors, bool success})> getCompetitors(String tournamentId) async {
    var res_get = await getTournamentData(tournamentId);
    if (res_get.success == false)                 return (success:false, competitors : null);
    if (res_get.tournament?['competitors'] == null) return (success:false, competitors : null);

    List comp = res_get.tournament?['competitors']??[];
    
    return (success:true, competitors : comp);

  }
  
  @override
  Future<({enum_estado_torneio? status, bool success})> getTournamentStatus(String tournamentId) async {
    // TODO: implement get_estado_torneio
    throw UnimplementedError();
  }
  
  @override
  Future<({Etapa? currentRound, bool success})> getCurrentRound(String tournamentId) async {
    // TODO: implement get_etapa_atual
    throw UnimplementedError();
  }
  
  @override
  Future<({List<Etapa>? rounds, bool success})> getAllRounds(String tournamentId) async {
    // TODO: implement get_etapas_torneio
    throw UnimplementedError();
  }
  
  @override
  Future<({List? requests, bool success})> getEntryRequests(String tournamentId) async {
    // TODO: implement get_pedidos_entrada
    throw UnimplementedError();
  }
  
  @override
  Future<({Placar? score, bool success})> getScore(String tournamentId, String adminId) async {
    // TODO: implement get_placar
    throw UnimplementedError();
  }
  
  @override
  Future<({bool? acceptRequests, bool? allowRequests, bool success})> getTournamentConfig(String tournamentId) async {
    // TODO: implement get_torneio_config
    throw UnimplementedError();
  }
  
  @override
  Future<({bool success})> setTournamentConfig(String tournamentId, String adminId, {bool ? allowRequests, bool ? acceptRequests}) async {
    // TODO: implement set_torneio_config
    throw UnimplementedError();
  }
  
  @override
  Future<({bool success})> goBackRound(String tournamentId, String adminId) async {
    // TODO: implement voltar_etapa
    throw UnimplementedError();
  }
  
  

}
