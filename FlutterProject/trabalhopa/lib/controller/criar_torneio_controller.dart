/**
get name
get type

criar_torneio()
set_nome_torneio()
definir_regras() */

import '/constants/modos_torneio.dart';
import '/models/torneio.dart';

void createTournament(String tournamentName, String tournamentType) async {

    enum_modos_torneio ruleset;

    if (tournamentType == 'Duplas') {
        ruleset = enum_modos_torneio.eliminacao_simples;
    } else if (tournamentType == 'Eliminação Simples') {
        ruleset = enum_modos_torneio.eliminacao_simples;
    } else {
        ruleset = enum_modos_torneio.nao_selecionado;
    }

    var t = Torneio();
    print('create tourney');
    var res = await t.criar_torneio();

    if (!res.sucesso) {
        print('oh nyo');
    } else {
        String tournamentId, adminId;

        if (res.id_torneio != null && res.id_admin != null) {
            tournamentId = res.id_torneio ?? '';
            adminId = res.id_admin ?? '';

            await t.set_nome_torneio(tournamentId, adminId, tournamentName);
            await t.definir_regras(tournamentId, adminId, ruleset);
            var tournamentMap = await t.get_torneio_map(tournamentId);

            print("t's map: ${tournamentMap}");
        }

        
    }

    
    
}