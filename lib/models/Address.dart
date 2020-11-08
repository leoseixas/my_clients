

import 'package:my_clients/database/string_table.dart';

class Address{
  int id;
  String cep;
  String logradouro;
  String numero;
  String bairro;
  String cidade;
  String estado;
  String complemento;
  int clientId;

  Address();

  Address.fromMap(Map map){
    id = map[idAdressColumn];
    cep = map[cepColumn];
    logradouro = map[logradouroColumn];
    numero = map[numeroColumn];
    bairro = map[bairroColumn];
    cidade = map[cidadeColumn];
    estado = map[estadoColumn];
    complemento = map[complementoColumn];
    clientId = map[clientIdColumn];
  }

  Map toMap(){
    Map<String, dynamic> map ={
      cepColumn: cep,
      logradouroColumn: logradouro,
      numeroColumn: numero,
      bairroColumn: bairro,
      cidadeColumn: cidade,
      estadoColumn: estado,
      complementoColumn: complemento,
      clientIdColumn: clientId
    };
    if(id != null){
      map[idAdressColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Endereço (id: $id, cep: $cep, logradouro: $logradouro, numero: $numero,"
        "cidade: $cidade, estado: $estado, complemento: $complemento, idclient: $clientId)";
  }

}