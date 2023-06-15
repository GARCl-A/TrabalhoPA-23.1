/*
 * Implementação da interface torneio-controlador
 * Contém lógica de alto nível do aplicativo, delegando detalhes específicos do torneio para o serviço "Regras"
*/

import 'package:trabalhopa/models/api_torneio_dados.dart';

import 'api_torneio_interface.dart' show API_TORNEIO;
import 'api_torneio_dados.dart'
    show Etapa, Placar, err_geral, err_pedir_entrada;
import '../constants/torneio_states.dart';
import '../constants/modos_torneio.dart';
import '../bd/MongoImpl2.dart';

import '../util/string.dart';

void main() async
{
  await MongoConnection.create();
  var meu_torneio = Torneio();

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

class Torneio implements API_TORNEIO  {
  //Regras? _regras;
  MongoConnection _conexao_banco = MongoConnection();

  // Cria torneio em preparo, retorna identificador do torneio
  @override
  Future<({bool sucesso, String ? id_torneio, String ? id_admin})> criar_torneio() async  {
    // Gera strings aleatórias para id_admin e id_torneio
    // Confere se não há outro torneio com mesmo id
    // Insere torneio no banco com outros dados de valor padrão

    int idLenght = 10;

    String codigoTorneio = '';
    var resultado;
    for (int i = 0; i < 100; i++)
    {
      codigoTorneio = getRandomString(idLenght);
      resultado = await _conexao_banco.getTorneio(codigoTorneio) ;
      if (resultado.sucesso == false) break;
    }

    if (resultado.sucesso != false)
    {
      return (sucesso:false ,id_admin: null, id_torneio: null);
    }
     
    String codigoAdmin = getRandomString(idLenght);
    String codigoEntrada = getRandomString(idLenght);

    Map <String,dynamic> torneio = 
    {
      'id_torneio'          :     codigoTorneio,
      'id_admin'            :     codigoAdmin,
      'codigo_entrada'      :     codigoEntrada,

      'nome_torneio'        :     'Meu Torneio',

      'estado_torneio'      :     enum_estado_torneio.em_preparo.index,

      'permitir_pedidos'    :     true,
      'aceitar_pedidos'     :     false,

      'competidores'        :     [],
      'pedidos_comp'        :     [],
      
      'regras'              :     enum_modos_torneio.nao_selecionado.index,

      'etapas'              :     [],

      'dados_competidores'  :     []
    };

    var resEscrita = await _conexao_banco.criarTorneio(torneio);

    if (resEscrita.sucesso == false)
    {
      return (sucesso:false, id_admin: null, id_torneio: null);
    }

    return (sucesso:true, id_admin: codigoAdmin, id_torneio: codigoTorneio);
  }

  @override
  Future<({bool sucesso, Map<String, dynamic> ? torneio})> get_torneio_map(String id_torneio) async 
  {
    var resposta = await _conexao_banco.getTorneio(id_torneio);
    if (resposta.sucesso == false)
    {
      return (sucesso:false, torneio : null);
    }

    return (sucesso:true, torneio: resposta.torneio);
  }

  @override
  Future<({bool? is_admin, bool sucesso})> check_if_admin(String id_torneio, String id_admin) async
  {
    var resposta = await _conexao_banco.getTorneio(id_torneio);
    if (resposta.sucesso == false)
    {
      return (sucesso:false, is_admin : null);
    }

    if(id_admin == resposta.torneio?['id_admin'])
    {
      return (sucesso:true, is_admin:true);
    }

    return (sucesso:true, is_admin:false);

  }

  @override
  Future<({err_geral err, bool sucesso})>
  adicionar_competidor
  (String id_torneio, String id_admin, String nome_competidor) async
  {
    // Autorização
    var resposta = await check_if_admin(id_torneio, id_admin);
    if (resposta.sucesso == false) return (sucesso:false, err: err_geral.torneio_inexistente);
    if (resposta.is_admin == false) return (sucesso:false, err: err_geral.nao_autorizado);

    if (checkNomeCompetidor(nome_competidor) == false) return (sucesso:false, err: err_geral.nome_invalido);

    var res_get = await _conexao_banco.getTorneio(id_torneio);
    if (res_get.sucesso == false) return (sucesso:false, err: err_geral.torneio_inexistente);
    if (res_get.torneio?['competidores'] == null) return (sucesso:false, err: err_geral.erro_bd);

    List compet = res_get.torneio!['competidores'];
    if(compet.contains(nome_competidor) == true) return (sucesso:false, err: err_geral.nome_duplicado);
    compet.add(nome_competidor);
    res_get.torneio!['competidores'] = compet;

    var res_replace = await _conexao_banco.replaceTorneio(id_torneio, res_get.torneio??{});
    if(res_replace.sucesso == false) return (sucesso:false, err: err_geral.erro_bd);

    return (sucesso: true, err: err_geral.none);

  }

  @override
  Future<({err_geral? err, bool sucesso})> 
  remover_competidor
  (String id_torneio, String id_admin, String nome_competidor) async 
  {
    // Autorização
    var resposta = await check_if_admin(id_torneio, id_admin);
    if (resposta.is_admin == null) return (sucesso:false, err: err_geral.torneio_inexistente);
    if (resposta.is_admin == false) return (sucesso:false, err: err_geral.nao_autorizado);

    var res_get = await _conexao_banco.getTorneio(id_torneio);
    if (res_get.sucesso == false) return (sucesso:false, err: err_geral.torneio_inexistente);
    if (res_get.torneio?['competidores'] == null) return (sucesso:false, err: err_geral.erro_bd);

    List compet = res_get.torneio!['competidores'];
    if(compet.contains(nome_competidor) == false) return (sucesso:false, err: err_geral.nome_invalido);
    compet.remove(nome_competidor);
    res_get.torneio!['competidores'] = compet;

    var res_replace = await _conexao_banco.replaceTorneio(id_torneio, res_get.torneio??{});
    if(res_replace.sucesso == false) return (sucesso:false, err: err_geral.erro_bd);

    return (sucesso: true, err: err_geral.none);
  }

  @override
  Future<({err_geral? err, bool sucesso})>
  definir_regras
  (String id_torneio, String id_admin, enum_modos_torneio regras) async
  {
    // Autorização
    var resposta = await check_if_admin(id_torneio, id_admin);
    if (resposta.sucesso == false) return (sucesso:false, err: err_geral.torneio_inexistente);
    if (resposta.is_admin == false) return (sucesso:false, err: err_geral.nao_autorizado);

    var res_get = await _conexao_banco.getTorneio(id_torneio);
    if (res_get.sucesso == false) return (sucesso:false, err: err_geral.torneio_inexistente);
    if (res_get.torneio?['id_torneio'] == null) return (sucesso:false, err: err_geral.erro_bd);

    res_get.torneio!['regras'] = regras.index;

    var res_replace = await _conexao_banco.replaceTorneio(id_torneio, res_get.torneio??{});
    if(res_replace.sucesso == false) return (sucesso:false, err: err_geral.erro_bd);

    return (sucesso: true, err: err_geral.none);

  }

  @override
  Future<({bool sucesso, err_geral err})> 
  set_nome_torneio 
  (String id_torneio, String id_admin, String nome_torneio) async
  {
    // Autorização
    var resposta = await check_if_admin(id_torneio, id_admin);
    if (resposta.sucesso == false) return (sucesso:false, err: err_geral.torneio_inexistente);
    if (resposta.is_admin == false) return (sucesso:false, err: err_geral.nao_autorizado);

    var res_get = await _conexao_banco.getTorneio(id_torneio);
    if (res_get.sucesso == false) return (sucesso:false, err: err_geral.erro_bd);

    if (checkNomeTorneio(nome_torneio) != true) return (sucesso:false, err: err_geral.nome_invalido);

    res_get.torneio?['nome_torneio'] = nome_torneio;
    var res_repl = await _conexao_banco.replaceTorneio(id_torneio, res_get.torneio??{});

    if (res_repl.sucesso == false ) return (sucesso:false, err: err_geral.erro_bd);

    return (sucesso:true, err: err_geral.none);
  
  }
  
  @override
  Future<({err_pedir_entrada? err, bool sucesso})> aceitar_entrada(String id_torneio, String id_admin, String nome_competidor) {
    // TODO: implement aceitar_entrada
    throw UnimplementedError();
  }
  
  @override
  Future<({err_geral? err, bool sucesso})>
  concluir_etapa
  (String id_torneio, String id_admin, Map<String,dynamic> etapa_atual) {
    // TODO: implement concluir_etapa
    throw UnimplementedError();
  }
  
  @override
  Future<({err_geral? err, Map<String,dynamic>? proxima_etapa, bool sucesso, bool torneio_fim})>
  criar_proxima_etapa
  (String id_torneio, String id_admin) {
    // TODO: implement criar_proxima_etapa
    throw UnimplementedError();
  }
  
  @override
  Future<({String? codigo_entrada, bool sucesso})> get_codigo_entrada(String id_torneio) {
    // TODO: implement get_codigo_entrada
    throw UnimplementedError();
  }
  
  @override
  Future<({List? competidores, bool sucesso})> get_competidores(String id_torneio) async
  {
    var res_get = await _conexao_banco.getTorneio(id_torneio); 
    if (res_get.sucesso == false)                 return (sucesso:false, competidores : null);
    if (res_get.torneio?['competidores'] == null) return (sucesso:false, competidores : null);

    List comp = res_get.torneio?['competidores']??[];
    
    return (sucesso:true, competidores : comp);

  }
  
  @override
  Future<({enum_estado_torneio? estado, bool sucesso})> get_estado_torneio(String id_torneio) {
    // TODO: implement get_estado_torneio
    throw UnimplementedError();
  }
  
  @override
  Future<({Etapa? etapa_atual, bool sucesso})> get_etapa_atual(String id_torneio) {
    // TODO: implement get_etapa_atual
    throw UnimplementedError();
  }
  
  @override
  Future<({List<Etapa>? Etapas, bool sucesso})> get_etapas_torneio(String id_torneio) {
    // TODO: implement get_etapas_torneio
    throw UnimplementedError();
  }
  
  @override
  Future<({List? pedidos, bool sucesso})> get_pedidos_entrada(String id_torneio) {
    // TODO: implement get_pedidos_entrada
    throw UnimplementedError();
  }
  
  @override
  Future<({Placar? placar, bool sucesso})> get_placar(String id_torneio, String id_admin) {
    // TODO: implement get_placar
    throw UnimplementedError();
  }
  
  @override
  Future<({bool? aceitar_pedidos, bool? permitir_pedidos, bool sucesso})> get_torneio_config(String id_torneio) {
    // TODO: implement get_torneio_config
    throw UnimplementedError();
  }
  
  @override
  Future<({err_pedir_entrada? err, bool sucesso})> pedir_entrada(String id_torneio, String nome_competidor) {
    // TODO: implement pedir_entrada
    throw UnimplementedError();
  }
  
  @override
  Future<({bool sucesso})> set_torneio_config(String id_torneio, String id_admin, {bool ? permitir_pedidos, bool ? aceitar_pedidos}) {
    // TODO: implement set_torneio_config
    throw UnimplementedError();
  }
  
  @override
  Future<({bool sucesso})> voltar_etapa(String id_torneio, String id_admin) {
    // TODO: implement voltar_etapa
    throw UnimplementedError();
  }
  
  




  /*
  @override
  ({bool aceitar_pedidos, bool permitir_pedidos, bool sucesso})
  get_torneio_config
  (String id_torneio) 
  {
    var resposta = _conexao_banco.get_dados_torneio(id_torneio);

    if (resposta.sucesso == false)
      return (sucesso: false, aceitar_pedidos: false, permitir_pedidos: false);

    return (
      sucesso: true,
      aceitar_pedidos: resposta.torneio?.aceitar_pedidos ?? false,
      permitir_pedidos: resposta.torneio?.permitir_pedidos ?? false
    );
  }

  @override
  ({bool sucesso}) set_torneio_config(String id_torneio,
      {bool? permitir_pedidos, bool? aceitar_pedidos}) {
    var resposta = _conexao_banco.set_torneio_config(id_torneio,
        permitir_pedidos: permitir_pedidos, aceitar_pedidos: aceitar_pedidos);

    return (sucesso: resposta.sucesso);
  }

  @override
  ({List competidores, bool sucesso}) get_competidores(String id_torneio) {
    var resposta = _conexao_banco.get_dados_torneio(id_torneio);

    return (
      sucesso: resposta.sucesso,
      competidores: resposta.torneio?.competidores ?? []
    );
  }

  @override
  ({List pedidos, bool sucesso}) get_pedidos_entrada(String id_torneio) {
    var resposta = _conexao_banco.get_dados_torneio(id_torneio);

    return (
      sucesso: resposta.sucesso,
      pedidos: resposta.torneio?.pedidos_comp ?? []
    );
  }

  @override
  ({enum_estado_torneio estado, bool sucesso}) get_estado_torneio(
      String id_torneio) {
    var resposta = _conexao_banco.get_dados_torneio(id_torneio);

    return (
      sucesso: resposta.sucesso,
      estado: resposta.torneio?.estado_torneio ?? enum_estado_torneio.finalizado
    );
  }

  @override
  ({bool is_admin, bool sucesso}) check_if_admin(
      String id_torneio, String id_admin) {
    var resposta = _conexao_banco.get_dados_torneio(id_torneio);

    if (resposta.sucesso == true) {
      if (resposta.torneio?.id_admin == id_admin)
        return (sucesso: true, is_admin: true);
      else
        return (sucesso: true, is_admin: false);
    }

    return (sucesso: false, is_admin: false);
  }

  @override
  ({err_pedir_entrada err, bool sucesso}) pedir_entrada(
      String id_torneio, String nome_competidor) {
    var resposta = _conexao_banco.get_dados_torneio(id_torneio);

    if (resposta.sucesso == false)
      return (sucesso: false, err: err_pedir_entrada.codigo_entrada_invalido);

    if (resposta.torneio!.permitir_pedidos == false)
      return (sucesso: false, err: err_pedir_entrada.acesso_negado);

    if (resposta.torneio!.competidores!.contains(nome_competidor))
      return (sucesso: false, err: err_pedir_entrada.nome_invalido);

    if (resposta.torneio!.pedidos_comp!.contains(nome_competidor))
      return (sucesso: false, err: err_pedir_entrada.nome_invalido);

    if (resposta.torneio!.aceitar_pedidos == true) {
      adicionar_competidor(id_torneio, nome_competidor);
      return (sucesso: true, err: err_pedir_entrada.none);
    } else {
      var resposta_adicionar =
          _conexao_banco.adicionar_pedido_entrada(id_torneio, nome_competidor);
      return (
        sucesso: resposta_adicionar.sucesso,
        err: err_pedir_entrada.erro_bd
      );
    }
  }

  @override
  ({err_pedir_entrada err, bool sucesso}) aceitar_entrada(
      String id_torneio, String nome_competidor) {
    var resposta = _conexao_banco.get_dados_torneio(id_torneio);

    if (resposta.sucesso == false)
      return (sucesso: false, err: err_pedir_entrada.codigo_entrada_invalido);

    if (resposta.torneio!.pedidos_comp!.contains(nome_competidor)) {
      var resposta_aceitar =
          _conexao_banco.aceitar_pedido_entrada(id_torneio, nome_competidor);
      if (resposta_aceitar.sucesso == true)
        return (sucesso: true, err: err_pedir_entrada.none);
      else
        return (sucesso: false, err: err_pedir_entrada.erro_bd);
    } else
      return (sucesso: false, err: err_pedir_entrada.nome_invalido);
  }

  @override
  ({err_comp_add err, bool sucesso}) adicionar_competidor(
      String id_torneio, String nome_competidor) {
    var resposta = _conexao_banco.get_dados_torneio(id_torneio);

    if (resposta.sucesso == false)
      return (sucesso: false, err: err_comp_add.torneio_inexistente);

    var resposta_adicionar =
        _conexao_banco.adicionar_competidor(id_torneio, nome_competidor);
    if (resposta_adicionar.sucesso == true)
      return (sucesso: true, err: err_comp_add.none);
    else
      return (sucesso: false, err: err_comp_add.erro_bd);
  }

  @override
  ({err_comp_rem err, bool sucesso}) remover_competidor(
      String id_torneio, String nome_competidor) {
    var resposta = _conexao_banco.get_dados_torneio(id_torneio);

    if (resposta.sucesso == false)
      return (sucesso: false, err: err_comp_rem.torneio_inexistente);

    if (resposta.torneio!.competidores!.contains(nome_competidor) == true) {
      var resposta_remover =
          _conexao_banco.remover_competidor(id_torneio, nome_competidor);
      if (resposta_remover.sucesso == true)
        return (sucesso: true, err: err_comp_rem.none);
      else
        return (sucesso: false, err: err_comp_rem.erro_bd);
    } else
      return (sucesso: false, err: err_comp_rem.comp_inexistente);
  }

  @override
  ({err_regras err, bool sucesso}) definir_regras(
      String id_torneio, modos_torneio regras) {
    var resposta = _conexao_banco.get_dados_torneio(id_torneio);

    if (resposta.sucesso == false)
      return (sucesso: false, err: err_regras.torneio_inexistente);
    if (resposta.torneio!.estado_torneio != enum_estado_torneio.em_preparo)
      return (sucesso: false, err: err_regras.torneio_em_progresso);

    var resposta_definir_regras =
        _conexao_banco.definir_regras(id_torneio, regras);
    if (resposta_definir_regras.sucesso == true)
      return (sucesso: true, err: err_regras.none);
    else
      return (sucesso: false, err: err_regras.erro_bd);
  }

  @override
  ({err_concluir_etapa err, String msg, bool sucesso}) concluir_etapa(
      String id_torneio, Etapa etapa_atual) {
    // TODO: implement concluir_etapa
    throw UnimplementedError();
  }

  @override
  ({err_criar_etapa err, Etapa proxima_etapa, bool sucesso})
      criar_proxima_etapa(String id_torneio) {
    // TODO: implement criar_proxima_etapa
    throw UnimplementedError();
  }

  @override
  ({Etapa etapa_atual, bool sucesso}) get_etapa_atual(String id_torneio) {
    // TODO: implement get_etapa_atual
    throw UnimplementedError();
  }

  @override
  ({List<Etapa> Etapas, bool sucesso}) get_etapas_torneio(String id_torneio) {
    // TODO: implement get_etapas_torneio
    throw UnimplementedError();
  }

  @override
  ({Placar placar, bool sucesso}) get_placar(String id_torneio) {
    // TODO: implement get_placar
    throw UnimplementedError();
  }

  @override
  ({bool sucesso}) voltar_etapa(String id_torneio) {
    // TODO: implement voltar_etapa
    throw UnimplementedError();
  }

  @override
  ({String codigo_entrada, bool sucesso}) get_codigo_entrada(
      String id_torneio) {
    // TODO: implement get_etapa_atual
    throw UnimplementedError();
  }

  */

}
