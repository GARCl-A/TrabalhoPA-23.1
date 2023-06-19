//getTournamentData
import '/models/torneio_mockup.dart';

Future<({bool success, Map<String,dynamic>? tournamentData})> getTournamentData(String tournamentId) async {
    var t = TorneioMockup();
    var res = await t.getTournamentData(tournamentId);

    if (res.success == false) return (success: false, tournamentData: null);

    return (success: true, tournamentData: res.tournament);
}