import '../torneio.dart';
import '../controller_torneio_api_dados.dart';
import '../../constants/torneio_states.dart';

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
  Future <({bool sucesso, bool torneio_fim, err_geral? err, Map<String,dynamic> ? proxima_etapa})>   
  criar_proxima_etapa  
  (String id_torneio, String id_admin) async
  {
    // Autorização
    var resposta = await check_if_admin(id_torneio, id_admin);
    if (resposta.is_admin == null) 
    {
      return (sucesso:false, err: err_geral.torneio_inexistente, proxima_etapa: null, torneio_fim : false);
    }
    if (resposta.is_admin == false)
    {
      return (sucesso:false, err: err_geral.nao_autorizado, proxima_etapa: null, torneio_fim : false);
    } 
    

    var res_get = await _conexao_banco.getTorneio(id_torneio); 
    if (res_get.torneio == null)
    {
      return (sucesso:false, err: err_geral.erro_bd, proxima_etapa: null, torneio_fim : false);

    } 
    
    // Conferir se torneio está em um estado válido para criar etapa
    if (res_get.torneio?['estado_torneio'] != enum_estado_torneio.em_preparo.index
    && res_get.torneio?['estado_torneio'] != enum_estado_torneio.interludio.index)
    {
      return (sucesso:false, err: err_geral.estado_invalido, proxima_etapa: null, torneio_fim : false);
    }

    // Verificar fim do torneio
    if (torneio_finalizado(res_get.torneio?['dados_competidores']) == true)
    {
      res_get.torneio?['estado_torneio'] = enum_estado_torneio.finalizado.index;
      print(res_get.torneio?['estado_torneio']);
      await _conexao_banco.replaceTorneio(id_torneio, res_get.torneio??{});
      return (sucesso:true, err: err_geral.none, proxima_etapa: null, torneio_fim : true);
    }

    // Determinar número da nova etapa
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

    // Criar partidas com base no modo de torneio
    nova_etapa['partidas'] = criar_partidas(res_get.torneio??{});
    etapas_existentes.add(nova_etapa);
    res_get.torneio!['etapas'] = etapas_existentes;

    // Trocar estado de torneio para 'em etapa'
    res_get.torneio!['estado_torneio'] = enum_estado_torneio.em_etapa.index;

    // Salvar dados do torneio
    var res_etapa = await _conexao_banco.replaceTorneio(id_torneio, res_get.torneio??{});

    if (res_etapa.sucesso == true)
    {
      return (sucesso: true, err: err_geral.none, proxima_etapa: nova_etapa, torneio_fim : false);
    }

    return (sucesso: false, err: err_geral.erro_bd, proxima_etapa: null, torneio_fim : false);

  }

///////////////////////////////////////////////////////////////////////////////////////////////

  List criar_partidas (Map<String,dynamic> torneio)
  {
    List ? dados = torneio['dados_competidores'];

    List competidores_ativos = [];


    // Coletar competidores que ainda não foram eliminados
    if (dados == null || dados.isEmpty)
    {
      competidores_ativos = List.of(torneio['competidores']);
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
///////////////////////////////////////////////////////////////////////////////////////////////

  bool torneio_finalizado (List dados_competidores)
  {
    // Confere através dos dados dos competidores se o torneio acabou
    // Verifica se há mais de 1 jogado sem derrotas
    int comp_ativos = 0;
    for (var i = 0; i < dados_competidores.length; i++)
    {
      if (dados_competidores[i]['derrotas'] == 0)
      {
        comp_ativos++;
      }
    }

    if (comp_ativos <= 1) return true;

    return false;
  }

///////////////////////////////////////////////////////////////////////////////////////////////

  @override
  Future<({err_geral? err, bool sucesso})>
  concluir_etapa
  (String id_torneio, String id_admin, Map<String,dynamic> etapa_atual) async
  {
    // Autorização
    var resposta = await check_if_admin(id_torneio, id_admin);
    if (resposta.is_admin == null) return (sucesso:false, err: err_geral.torneio_inexistente);
    if (resposta.is_admin == false) return (sucesso:false, err: err_geral.nao_autorizado);

    var res_get = await _conexao_banco.getTorneio(id_torneio); 
    if (res_get.torneio == null) return (sucesso:false, err: err_geral.erro_bd);

    // Conferir se torneio está no meio de uma etapa
    if (res_get.torneio?['estado_torneio'] != enum_estado_torneio.em_etapa.index)
    {
      return (sucesso:false, err: err_geral.estado_invalido);
    }

    // Conferir número de etapa
    List etapas_existentes = List.of(res_get.torneio?['etapas']);
    Map<String,dynamic> etapa_preparada = etapas_existentes.last;

    if (etapa_preparada['nro_etapa'] != etapa_atual['nro_etapa'])
    {
      return (sucesso:false, err: err_geral.etapa_invalida);
    }

    // Validar partidas
    if (validar_partidas(etapa_atual['partidas'], etapa_preparada['partidas']) == false)
    {
      return (sucesso:false, err: err_geral.partida_invalida);
    }

    // Etapa Validada!
    print("Etapa validada");
    // Registrar etapa no banco
    etapas_existentes.last = etapa_atual;
    res_get.torneio?['etapas'] = etapas_existentes;
    res_get.torneio?['estado_torneio'] = enum_estado_torneio.interludio.index;
    
    var dados_comp_atualizados = 
    registrar_resultados(List.of(res_get.torneio?['dados_competidores']),List.of(etapa_atual['partidas']));
    
    if (dados_comp_atualizados.sucesso == false)
    {
      return(sucesso: false, err: err_geral.erro_bd);
    }

    res_get.torneio?['dados_competidores'] = dados_comp_atualizados.dados_atualizados;

    var res_replace = await _conexao_banco.replaceTorneio(id_torneio, res_get.torneio??{});

    if (res_replace.sucesso == true)
    {
      return (sucesso: true, err: err_geral.none);
    }

    return (sucesso: false, err: err_geral.erro_bd);
  }


///////////////////////////////////////////////////////////////////////////////////////////////

  bool validar_partidas 
  (List partidas_recebidas,
   List partidas_preparadas)
  {
    // Verificar se numero de partidas é o mesmo
    if (partidas_recebidas.length != partidas_preparadas.length)
    {
      print("Nro de partidas diferente");
      return false;
    }


    // Verificar se competidores participantes são os mesmos
    List comp_prep = [];
    List comp_rec = [];

    for (var i = 0; i < partidas_preparadas.length; i++)
    {
      comp_prep.addAll(partidas_preparadas[i]['competidores']);
      comp_rec.addAll(partidas_recebidas[i]['competidores']);
    }

    for (var i = 0; i < partidas_preparadas.length; i++)
    {
      if (comp_prep.contains(comp_rec[i]) == false)
      {
        print("Competidor novo detectado");
        return false;
      }
    }

    for (var i = 0; i < partidas_preparadas.length; i++)
    {
      if (comp_rec.contains(comp_prep[i]) == false)
      {
        print("Competidor faltante detectado");
        return false;
      }
    }

    // Verificar se há mais participações que o permitido (Ex: 3 participantes por partida)

    if (comp_prep.length != comp_rec.length)
    {
      print("Mais competidores que o permitido em uma partida");
      return false;
    }
    
    // Verificar se há participações duplicadas
    for (var i = 0; i < comp_prep.length; i++)
    {
      comp_rec.remove(comp_prep[i]);  // Remove somente uma instância
    }
    if (comp_rec.isNotEmpty)
    {
      print("Participações duplicadas");
      return false;
    }

    // Verificar se partidas têm um vencedor válido (um dos competidores da mesma)

    List competidores_partida = [];
    for (var i = 0; i < partidas_recebidas.length; i++)
    {
      competidores_partida = partidas_recebidas[i]['competidores'];
      if (competidores_partida.contains(partidas_recebidas[i]['vencedor']) == false)
      {
        print("Alguma partida não tem um vencedor válido");
        return false;
      }
    }

    return true;
  }
///////////////////////////////////////////////////////////////////////////////////////////////

({bool sucesso, List dados_atualizados}) registrar_resultados (List dados_competidores,List partidas_recebidas)
{
  // Atualizar os dados dos competidores com base nas partidas da etapa concluida
  if (dados_competidores.isEmpty) // Primeira entrada de dados
  {
    Map<String, dynamic> dado_comp1 = {};
    Map<String, dynamic> dado_comp2 = {};

    for (var i = 0; i < partidas_recebidas.length; i++)
    {
      dado_comp1 = {};
      dado_comp2 = {};

      dado_comp1['competidor'] = partidas_recebidas[i]['competidores'][0];
      dado_comp2['competidor'] = partidas_recebidas[i]['competidores'][1];

      int vitoria_do_1 = 0;
      if (partidas_recebidas[i]['vencedor'] == dado_comp1['competidor'])
      {
        vitoria_do_1 = 1;
      }

      dado_comp1['vitorias'] = vitoria_do_1;
      dado_comp2['vitorias'] = 1 - vitoria_do_1;

      dado_comp1['derrotas'] = 1 - vitoria_do_1;
      dado_comp2['derrotas'] = vitoria_do_1;

      if(dado_comp1['competidor'] != '!BYE')  dados_competidores.add(dado_comp1);
      if(dado_comp2['competidor'] != '!BYE')  dados_competidores.add(dado_comp2);
    }

    return (sucesso: true, dados_atualizados: dados_competidores);
  }

  for (var i = 0; i < dados_competidores.length; i++)
  {
    String comp_atual = dados_competidores[i]['competidor'];

    List comp_in_partida = [];
    int partida_index = -1;
    for (var j = 0; j < partidas_recebidas.length; j++)
    {
      comp_in_partida = partidas_recebidas[j]['competidores'];
      if (comp_in_partida.contains(comp_atual))
      {
        partida_index = j;
        break;
      } 
    }

    if (partida_index == -1) continue;  // Competidor não está em nenhuma partida, foi eliminado anteriormente

    if (partidas_recebidas[partida_index]['vencedor'] == comp_atual)
    {
      dados_competidores[i]['vitorias'] += 1;
    }
    else
    {
      dados_competidores[i]['derrotas'] += 1;
    }
  }

  return (sucesso: true, dados_atualizados: dados_competidores);

}


}




void main() async
{
  await MongoConnection.create();
  var meu_torneio = TorneioEliminacaoSimples();

  
  // print( await meu_torneio.criar_torneio());
  //print( await meu_torneio.check_if_admin('YgxWsCUYUZ', 'LWmcBI9jgT'));
  
  
  /*
  print( await meu_torneio.adicionar_competidor('YgxWsCUYUZ', 'LWmcBI9jgT', 'Comp A'));
  print( await meu_torneio.adicionar_competidor('YgxWsCUYUZ', 'LWmcBI9jgT', 'Comp B'));
  print( await meu_torneio.adicionar_competidor('YgxWsCUYUZ', 'LWmcBI9jgT', 'Comp C'));
  print( await meu_torneio.adicionar_competidor('YgxWsCUYUZ', 'LWmcBI9jgT', 'Comp D'));
  print( await meu_torneio.adicionar_competidor('YgxWsCUYUZ', 'LWmcBI9jgT', 'Comp E'));
  print( await meu_torneio.adicionar_competidor('YgxWsCUYUZ', 'LWmcBI9jgT', 'Comp F'));
  print( await meu_torneio.adicionar_competidor('YgxWsCUYUZ', 'LWmcBI9jgT', 'Comp G'));
  print( await meu_torneio.adicionar_competidor('YgxWsCUYUZ', 'LWmcBI9jgT', 'Comp H'));
  print( await meu_torneio.adicionar_competidor('YgxWsCUYUZ', 'LWmcBI9jgT', 'Comp I'));
  */

  //print( await meu_torneio.get_torneio_map('y4swFT49Sx'));
  //print ( await meu_torneio.criar_proxima_etapa('YgxWsCUYUZ', 'LWmcBI9jgT'));
  
  //var resposta = await meu_torneio.get_torneio_map('y4swFT49Sx');
  //print(resposta.torneio?['etapas'][0]);

  /*
  Map<String,dynamic> minha_etapa = 
  {'nro_etapa': 1, 'partidas': 
  [
    {'nro_partida': 1, 'competidores': ['Comp A', 'Comp D'], 'vencedor': 'Comp D'}, 
    {'nro_partida': 2, 'competidores': ['Comp H', 'Comp B'], 'vencedor': 'Comp H'},
    {'nro_partida': 3, 'competidores': ['Comp E', 'Comp G'], 'vencedor': 'Comp G'}, 
    {'nro_partida': 4, 'competidores': ['Comp C', 'Comp I'], 'vencedor': 'Comp C'}, 
    {'nro_partida': 5, 'competidores': ['Comp F', '!BYE'], 'vencedor': '!BYE'}
  ]
  };
  */

  //print(await meu_torneio.concluir_etapa('YgxWsCUYUZ', 'LWmcBI9jgT', minha_etapa));

  //print ( await meu_torneio.criar_proxima_etapa('YgxWsCUYUZ', 'LWmcBI9jgT'));
  //var resposta = await meu_torneio.get_torneio_map('YgxWsCUYUZ');
  //print(resposta.torneio?['etapas']);

  /*
  var minha_etapa2 = {
      "nro_etapa": 2,
      "partidas": [
        {
          "nro_partida": 1,
          "competidores": [
            "Comp H",
            "Comp G"
          ],
          "vencedor": "Comp G"
        },
        {
          "nro_partida": 2,
          "competidores": [
            "Comp C",
            "Comp D"
          ],
          "vencedor": "Comp C"
        }
      ]
    };

  print(await meu_torneio.concluir_etapa('YgxWsCUYUZ', 'LWmcBI9jgT', minha_etapa2));
  */

  //print ( await meu_torneio.criar_proxima_etapa('YgxWsCUYUZ', 'LWmcBI9jgT'));
  //var resposta = await meu_torneio.get_torneio_map('YgxWsCUYUZ');
  //print(resposta.torneio?['etapas']);

  /*
  var minha_etapa3 = {
      "nro_etapa": 3,
      "partidas": [
        {
          "nro_partida": 1,
          "competidores": [
            "Comp G",
            "Comp C"
          ],
          "vencedor": "Comp C"
        }
      ]
    };

  print(await meu_torneio.concluir_etapa('YgxWsCUYUZ', 'LWmcBI9jgT', minha_etapa3));
  */

  print ( await meu_torneio.criar_proxima_etapa('YgxWsCUYUZ', 'LWmcBI9jgT'));
  //var resposta = await meu_torneio.get_torneio_map('YgxWsCUYUZ');
  //print(resposta.torneio?['etapas']);


  await MongoConnection.close();
  
}