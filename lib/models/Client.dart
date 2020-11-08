

import 'package:my_clients/database/string_table.dart';

class Client{
  int id;
  String name;
  String phone;
  String cpfCnpj;
  String data;
  String sexo;
  String inscricaoEstadual;
  String profissao;

  Client();

  Client.fromMap(Map map){
      id = map[idColumn];
      name = map[nameColumn];
      phone = map[phoneColumn];
      cpfCnpj = map[cpfCnpjColumn];
      data = map[dataColumn];
      sexo = map[sexoColumn];
      inscricaoEstadual = map[inscricaoEstadualColumn];
      profissao = map[profissaoColumn];
  }

  Map toMap(){
    Map<String,dynamic> map = {
      nameColumn: name,
      phoneColumn: phone,
      cpfCnpjColumn: cpfCnpj,
      dataColumn: data,
      sexoColumn: sexo,
      inscricaoEstadualColumn: inscricaoEstadual,
      profissaoColumn: profissao
    };
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Client(id: $id, name: $name, phone: $phone, cpfCnpj: $cpfCnpj, data: $data,"
        "sexo: $sexo, inscrição Estadual: $inscricaoEstadual, profissão: $profissao)";
  }
}