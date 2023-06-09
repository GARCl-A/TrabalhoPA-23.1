import '../constants/torneio_states.dart';
import '../constants/modos_torneio.dart';

class TorneioModelo
{
  String ? id_torneio;
  String ? id_admin;
  String ? codigo_entrada;

  bool? aceitar_pedidos;
  bool? permitir_pedidos;

  List ? competidores;
  List ? pedidos_comp;

  modos_torneio ? regras;

  enum_estado_torneio ? estado_torneio;
}

