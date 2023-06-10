/*
 * Implementação da interface torneio-banco de dados para fins de teste
 * 
*/

import '../constants/modos_torneio.dart';
import 'torneio_bd_api.dart';
import 'torneio_bd_api_dados.dart';
import '../constants/torneio_states.dart';

class BDTeste extends BD_API
{
  String id_torneio_teste = "ID_TORNEIO_DUMMY";
  String id_admin_teste = "ID_ADMIN_DUMMY";
  String codigo_entrada_teste = "CODIGO_ENTRADA_DUMMY";

  bool aceitar_pedidos_teste = false;
  bool permitir_pedidos_teste = false;

  List competidores_teste = ["Comp A", "Comp B", "Comp C"];
  List pedidos_comp_teste = ["Pedido D", "Pedido E"];

  enum_estado_torneio estado_torneio_teste = enum_estado_torneio.em_preparo;

  modos_torneio regras_teste = modos_torneio.eliminacao_simples;

  @override
  ({String id_admin, String id_torneio}) criar_torneio() {

    aceitar_pedidos_teste = false;
    permitir_pedidos_teste = false;

    estado_torneio_teste = enum_estado_torneio.em_preparo;

    return (id_admin: id_admin_teste, id_torneio: id_torneio_teste);
  }

  @override
  ({bool sucesso, TorneioModelo? torneio}) get_dados_torneio(String id_torneio) {
    if (id_torneio == id_torneio_teste)
    {
      TorneioModelo torneio_requisitado = TorneioModelo();

      torneio_requisitado.id_torneio = id_torneio_teste;
      torneio_requisitado.id_admin = id_admin_teste;
      torneio_requisitado.codigo_entrada = codigo_entrada_teste;

      torneio_requisitado.aceitar_pedidos = aceitar_pedidos_teste;
      torneio_requisitado.permitir_pedidos = permitir_pedidos_teste;

      torneio_requisitado.competidores = competidores_teste;
      torneio_requisitado.pedidos_comp = pedidos_comp_teste;

      torneio_requisitado.estado_torneio = estado_torneio_teste;

      torneio_requisitado.regras = regras_teste;

      return (sucesso: true, torneio: torneio_requisitado);
    }

    return (sucesso: false, torneio: null);
  }


  @override
  ({bool sucesso}) set_torneio_config(String id_torneio, {bool? permitir_pedidos, bool? aceitar_pedidos}) {
    if (id_torneio == id_torneio_teste)
    {

      if (permitir_pedidos != null) permitir_pedidos_teste = permitir_pedidos ;
      if (aceitar_pedidos != null) aceitar_pedidos_teste = aceitar_pedidos;

      return (sucesso: true);
    }

    return (sucesso: false);
  }

  @override
  ({bool sucesso}) adicionar_pedido_entrada(String id_torneio, String nome_competidor) {
    if (id_torneio_teste != id_torneio) return (sucesso: false);

    pedidos_comp_teste.add(nome_competidor);
    return (sucesso: true);

  }

  @override
  ({bool sucesso}) aceitar_pedido_entrada(String id_torneio, String nome_competidor) {
    if (id_torneio_teste != id_torneio) return (sucesso: false);

    var removido = pedidos_comp_teste.remove(nome_competidor);
    if (removido == false) return (sucesso: false);

    competidores_teste.add(nome_competidor);
    return (sucesso: true);
  }

  @override
  ({bool sucesso}) adicionar_competidor(String id_torneio, String nome_competidor) {
    if (id_torneio_teste != id_torneio) return (sucesso: false);

    competidores_teste.add(nome_competidor);
    return (sucesso: true);
  }

  @override
  ({bool sucesso}) remover_competidor(String id_torneio, String nome_competidor) {
    if (id_torneio_teste != id_torneio) return (sucesso: false);

    var removido = competidores_teste.remove(nome_competidor);
    if (removido == true) return (sucesso: true);
    else return (sucesso: false);
  }

  @override
  ({bool sucesso}) definir_regras(String id_torneio, modos_torneio regras) {
    if (id_torneio_teste != id_torneio) return (sucesso: false);

    regras_teste = regras;
    return (sucesso: true);    
  }

}