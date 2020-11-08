
import 'package:my_clients/database/string_table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDataBase{

  static final AppDataBase _singleton = AppDataBase._();

  static AppDataBase get instance => _singleton;

  AppDataBase._();

  Database _db;

  Future<Database> get db async{
    if(_db != null){
      return _db;
    }else{
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb()async{
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "clients.db");
    
    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion)async{
      await db.execute(
        "CREATE TABLE $clientTable("
            "$idColumn INTEGER PRIMARY KEY AUTOINCREMENT, "
            "$nameColumn TEXT, "
            "$phoneColumn TEXT,"
            "$cpfCnpjColumn TEXT, "
            "$dataColumn TEXT, "
            "$sexoColumn TEXT, "
            "$inscricaoEstadualColumn TEXT, "
            "$profissaoColumn TEXT)",
      );
      await db.execute(
        "CREATE TABLE $addresTable("
            "$idAdressColumn INTEGER PRIMARY KEY AUTOINCREMENT,"
            "$cepColumn TEXT,"
            "$logradouroColumn TEXT,"
            "$numeroColumn TEXT,"
            "$bairroColumn TEXT,"
            "$cidadeColumn TEXT,"
            "$estadoColumn TEXT,"
            "$complementoColumn TEXT,"
            "$clientIdColumn INTEGER NOT NULL,"
            "FOREIGN KEY($clientIdColumn) REFERENCES $clientTable ($idColumn) ON DELETE NO ACTION ON UPDATE NO ACTION)"
      );
    });
  }
}

