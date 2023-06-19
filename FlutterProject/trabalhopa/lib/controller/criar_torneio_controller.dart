import '/constants/modos_torneio.dart';
import '/models/torneio.dart';

Future<String?> criarTorneio(String nomeTorneio, String tipoTorneio) async {

    enum_modos_torneio ruleset;

    if (tipoTorneio == 'Duplas') {
        ruleset = enum_modos_torneio.eliminacao_simples;
    } else if (tipoTorneio == 'Eliminação Simples') {
        ruleset = enum_modos_torneio.eliminacao_simples;
    } else {
        ruleset = enum_modos_torneio.nao_selecionado;
    }

    var t = Torneio();
    var res = await t.criar_torneio();

    if (!res.sucesso) return 'n/a';
    if (res.id_torneio == null || res.id_admin == null) return 'n/a';

    String id_torneio, id_admin;
    id_torneio = res.id_torneio ?? '';
    id_admin = res.id_admin ?? '';
    await t.set_nome_torneio(id_torneio, id_admin, nomeTorneio);
    await t.definir_regras(id_torneio, id_admin, ruleset);
    // var tournamentMap = await t.getTournamentData(id_torneio);
    // print("t's map: ${tournamentMap}");
    print("res.id_torneio: ${res.id_torneio}");
    return res.id_torneio;
}