import '/constants/modos_torneio.dart';
import '/models/torneio_mockup.dart';

Future<String?> createTournament(String tournamentName, String tournamentType) async {

    enum_modos_torneio ruleset;

    if (tournamentType == 'Duplas') {
        ruleset = enum_modos_torneio.eliminacao_simples;
    } else if (tournamentType == 'Eliminação Simples') {
        ruleset = enum_modos_torneio.eliminacao_simples;
    } else {
        ruleset = enum_modos_torneio.nao_selecionado;
    }

    var t = TorneioMockup();
    var res = await t.createTournament();

    if (!res.success) return 'n/a';
    if (res.tournamentId == null || res.adminId == null) return 'n/a';

    String tournamentId, adminId;
    tournamentId = res.tournamentId ?? '';
    adminId = res.adminId ?? '';
    await t.setTournamentName(tournamentId, adminId, tournamentName);
    await t.setRules(tournamentId, adminId, ruleset);
    // var tournamentMap = await t.getTournamentData(tournamentId);
    // print("t's map: ${tournamentMap}");
    print("res.tournamentId: ${res.tournamentId}");
    return res.tournamentId;
}