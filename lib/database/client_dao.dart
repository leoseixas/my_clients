
import 'package:my_clients/models/Client.dart';
import 'package:sqflite/sqflite.dart';

import 'app_database.dart';
import 'string_table.dart';

class ClientDao{
  Future<Database> get _db async => await AppDataBase.instance.db;

  Future<Client> saveClient(Client client)async{
    Database dbClient = await _db;
    client.id = await dbClient.insert(clientTable, client.toMap());
    return client;
  }

  Future<Client> getClient(int id) async{
    Database dbClient = await _db;
    List<Map> maps =await dbClient.query(clientTable,
        columns: [idColumn, nameColumn, phoneColumn, cpfCnpjColumn, dataColumn,
          sexoColumn, inscricaoEstadualColumn, profissaoColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if(maps.length > 0){
      return Client.fromMap(maps.first);
    }else{
      return null;
    }
  }

  Future<int> deleteClient (int id)async{
    Database dbClient = await _db;
    return await dbClient.delete(clientTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateClient(Client client) async{
    Database dbClient = await _db;
    return await dbClient.update(clientTable,
        client.toMap(), where: "$idColumn = ?", whereArgs: [client.id]);
  }

  Future<List> getAllClients() async{
    Database dbClient = await _db;
    List listMap = await dbClient.rawQuery("SELECT * FROM $clientTable");
    List<Client> listClient = List();
    for(Map m in listMap){
      listClient.add(Client.fromMap(m));
    }
    return listClient;
  }

  Future<int> getNumber()async{
    Database dbClient = await _db;
    return Sqflite.firstIntValue(await dbClient.rawQuery("SELECT COUNT(*) FROM $clientTable"));
  }

  Future close() async{
    Database dbClient = await _db;
    dbClient.close();
  }
}