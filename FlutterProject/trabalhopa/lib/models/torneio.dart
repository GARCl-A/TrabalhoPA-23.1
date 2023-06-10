/*
 * Implementação da interface torneio-controlador
 * Contém lógica de alto nível do aplicativo, delegando detalhes específicos do torneio para o serviço "Regras"
*/

import '../bd/bd_teste.dart' show BDTeste;
import '../bd/torneio_bd_api.dart' show BD_API;
import '../bd/torneio_bd_api_dados.dart'; //Unused?
import 'controller_torneio_api.dart' show Torneio_API;
import 'controller_torneio_api_dados.dart'
    show
        Etapa,
        Placar,
        err_comp_add,
        err_comp_rem,
        err_concluir_etapa,
        err_criar_etapa,
        err_pedir_entrada,
        err_regras;
import '../constants/torneio_states.dart';
import '../constants/modos_torneio.dart';

//import 'torneio_regras_api.dart';

class Torneio implements Torneio_API {
  //Regras? _regras;
  BD_API _conexao_banco = BDTeste();

  // Cria torneio em preparo, retorna identificador do torneio
  @override
  ({bool sucesso, String id_torneio, String id_admin}) criar_torneio() {
    var resposta = _conexao_banco.criar_torneio();
    if (resposta.id_torneio == '')
      return (sucesso: false, id_torneio: '', id_admin: '');

    return (
      sucesso: true,
      id_torneio: resposta.id_torneio,
      id_admin: resposta.id_admin
    );
  }

  @override
  ({String codigo_entrada, bool sucesso}) get_codigo_entrada(
      String id_torneio) {
    var resposta = _conexao_banco.get_dados_torneio(id_torneio);

    if (resposta.sucesso == false) return (sucesso: false, codigo_entrada: '');

    return (
      sucesso: true,
      codigo_entrada: resposta.torneio?.codigo_entrada ?? ''
    );
  }

  @override
  ({bool aceitar_pedidos, bool permitir_pedidos, bool sucesso})
      get_torneio_config(String id_torneio) {
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
}
