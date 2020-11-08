
import 'package:my_clients/database/string_table.dart';
import 'package:my_clients/models/Address.dart';
import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

class AddressDao{
  Future<Database> get _db async => await AppDataBase.instance.db;

  Future<Address> saveAddress(Address address)async{
    Database dbAddress = await _db;
    address.id = await dbAddress.insert(addresTable, address.toMap());
    return address;
  }

  Future<Address> getAddress(int id)async{
    Database dbAddress = await _db;
    List<Map> maps = await dbAddress.query(addresTable,
        columns: [idAdressColumn, cepColumn, logradouroColumn, bairroColumn, cidadeColumn,
          estadoColumn, complementoColumn, clientTable],
        where: "$idAdressColumn = ?",
        whereArgs: [id]);
    if(maps.length > 0){
      return Address.fromMap(maps.first);
    }else{
      return null;
    }
  }

  Future<List<Address>> getAdressesFromClient(int id ) async{
    Database dbAddres = await _db;
//    List listMapAddress = await dbAddres.rawQuery("SELECT * FROM $addresTable FROM $addresTable INNER JOIN $clientTable on $idAdressColumn = $idColumn");
    List listMapAddress = await dbAddres.query(addresTable,
        columns: [idAdressColumn, cepColumn, logradouroColumn, numeroColumn,bairroColumn,
          cidadeColumn, estadoColumn, complementoColumn, clientIdColumn],
        where: "$clientIdColumn = ?",
        whereArgs: [id]);
    List<Address> listAddress = List();
    for(Map map in listMapAddress){
      listAddress.add(Address.fromMap(map));
    }
    return listAddress;
  }

  Future<int> deleteAddress (int id)async{
    Database dbAddres = await _db;
    return await dbAddres.delete(addresTable, where: "$idAdressColumn = ?", whereArgs: [id]);
  }
}