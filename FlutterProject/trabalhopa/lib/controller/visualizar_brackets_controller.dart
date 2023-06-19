//getTournamentData
import '/models/torneio.dart';

Future<({bool sucesso, Map<String,dynamic>? tournamentData})> getTorneioInfo(String id_torneio) async {
    var t = Torneio();
    var res = await t.get_torneio_map(id_torneio);

    if (res.sucesso == false) return (sucesso: false, tournamentData: null);

    return (sucesso: true, tournamentData: res.torneio);
}