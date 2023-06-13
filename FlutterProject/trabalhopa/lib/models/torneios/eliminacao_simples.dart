import '../torneio.dart';
import '../controller_torneio_api_dados.dart';
import '../../constants/modos_torneio.dart';

import '../../bd/MongoImpl2.dart';

import 'dart:math';

class TorneioEliminacaoSimples extends Torneio
{
  /*
   * Partidas consistem de um número identificador, uma lista com 2 jogadores e uma String com o nome do vencedor
   * {
   *    int nro_partida   : 1,
   *    List<String> competidores :  ["Competidor A", "Competidor B"],
   *    String vencedor : "Competidor A"  
   * }
   * Quando sobra um competidor durante a criação de partidas, seu oponente tem nome !BYE
   * !BYE é um nome inválido para usuário pelo sinal
   * O vencedor pode ser o competidor, recebendo uma vitoria, ou !BYE, sendo eliminado
   * O vencedor é inicialmente o competidor
   * 
   * Dados do jogador consistem no nome, um número inteiro de vitórias e um número inteiro de derrotas
   * 
   * {
   *    competidor : "Competidor A",
   *    vitorias : 3,
   *    derrotas : 0
   * }
   *  
   */


  MongoConnection _conexao_banco = MongoConnection();


  @override
  Future <({bool sucesso, err_geral? err, Map<String,dynamic> ? proxima_etapa})>   
  criar_proxima_etapa  
  (String id_torneio, String id_admin) async
  {
    // Autorização
    var resposta = await check_if_admin(id_torneio, id_admin);
    if (resposta.is_admin == null) return (sucesso:false, err: err_geral.torneio_inexistente, proxima_etapa: null);
    if (resposta.is_admin == false) return (sucesso:false, err: err_geral.nao_autorizado, proxima_etapa: null);

    var res_get = await _conexao_banco.getTorneio(id_torneio); 
    if (res_get.torneio == null) return (sucesso:false, err: err_geral.erro_bd, proxima_etapa: null);

    Map<String,dynamic> nova_etapa = {};

    List etapas_existentes = res_get.torneio?['etapas']??[];

    if (etapas_existentes.isEmpty)
    {
      nova_etapa['nro_etapa'] = 1;
    }
    else
    {
      nova_etapa['nro_etapa'] = etapas_existentes.last['nro_etapa'] + 1;
    }

    nova_etapa['partidas'] = criar_partidas(res_get.torneio??{});
    
    etapas_existentes.add(nova_etapa);
    res_get.torneio!['etapas'] = etapas_existentes;

    var res_etapa = await _conexao_banco.replaceTorneio(id_torneio, res_get.torneio??{});

    if (res_etapa.sucesso == true)
    {
      return (sucesso: true, err: err_geral.none, proxima_etapa: nova_etapa);
    }

    return (sucesso: false, err: err_geral.erro_bd, proxima_etapa: null);

  }

  List criar_partidas (Map<String,dynamic> torneio)
  {
    List ? dados = torneio['dados_competidores'];

    List competidores_ativos = [];


    // Coletar competidores que ainda não foram eliminados
    if (dados == null || dados.isEmpty)
    {
      competidores_ativos = torneio['competidores'];
    }
    else
    {
      for (var i = 0; i < dados.length; i ++)
      {
        if (dados[i]['derrotas'] == 0)
        {
          competidores_ativos.add(dados[i]['competidor']);
        }
      }
    }

    List <Map<String,dynamic>> partidas = [];
    
    int nro_partida = 0;
    List <String> oponentes = [];
    String oponenteA = '';
    String oponenteB = '';


    Map<String,dynamic> partida = {};

    while (competidores_ativos.length >= 2)
    {
      nro_partida++;
      partida = {};
      oponentes = [];

      partida['nro_partida'] = nro_partida;

      oponenteA = competidores_ativos[Random().nextInt(competidores_ativos.length)];
      competidores_ativos.remove(oponenteA);
      oponenteB = competidores_ativos[Random().nextInt(competidores_ativos.length)];
      competidores_ativos.remove(oponenteB);

      oponentes.add(oponenteA); oponentes.add(oponenteB);

      partida['competidores'] = oponentes;

      partida['vencedor'] = '';

      partidas.add(partida);
    }


    if (competidores_ativos.isNotEmpty)
    {
      nro_partida++;
      partida = {};

      partida['nro_partida'] = nro_partida;
      oponentes = [competidores_ativos[0], '!BYE'];
      partida['competidores'] = oponentes;
      partida['vencedor'] = competidores_ativos[0];

      partidas.add(partida);
    }

    return partidas;
  }


}




void main() async
{
  await MongoConnection.create();
  var meu_torneio = TorneioEliminacaoSimples();

  //print( await meu_torneio.criar_torneio());
  print( await meu_torneio.check_if_admin('y4swFT49Sx', 'eCn1oVYDRr'));
  print( await meu_torneio.check_if_admin('abc', 'eCn1oVYDRr'));
  print( await meu_torneio.check_if_admin('y4swFT49Sx', 'abc'));

  print( await meu_torneio.adicionar_competidor('y4swFT49Sx', 'Rr', 'ABC'));

  print( await meu_torneio.get_torneio_map('y4swFT49Sx'));
  print( await meu_torneio.get_torneio_map('abc'));

  print( await meu_torneio.remover_competidor('y4swFT49Sx', 'eCn1oVYDRr', 'dac'));
  print( await meu_torneio.remover_competidor('y4swFT49Sx', 'eCn1oVYDRr', 'ABC'));
  print( await meu_torneio.get_torneio_map('y4swFT49Sx'));

  print( await meu_torneio.definir_regras('y4swFT49Sx', 'eCn1oVYDRr', enum_modos_torneio.eliminacao_simples));
  print( await meu_torneio.get_torneio_map('y4swFT49Sx'));
}