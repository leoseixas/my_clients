import 'package:flutter/material.dart';
import 'package:my_clients/database/address_dao.dart';
import 'package:my_clients/database/client_dao.dart';
import 'package:my_clients/models/Client.dart';
import 'package:my_clients/pages/client_page.dart';
import 'create_client_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ClientDao dbClient = ClientDao();
  AddressDao dbAddress = AddressDao();

  List<Client> clients = List();

  @override
  void initState() {
    super.initState();
    _getAllClients();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Clientes", style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      floatingActionButton: _floatingActionButton(),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: clients.length,
        itemBuilder: (context, index){
          return _clientCard(context, index);
        },
      ),
    );
  }

  Widget _floatingActionButton(){
    return FloatingActionButton.extended(
      onPressed: () {
        _showCreateClientPage();
      },
      label: Text('Novo Client'),
      icon: Icon(Icons.add),
    );
  }

  Widget _clientCard(BuildContext context, int index){
    return GestureDetector(
      child: Card(
        child: ListTile(
          title: Text(clients[index].name ?? "",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          subtitle: Text(("Telefone: " + clients[index].phone) ?? "",
              style: TextStyle(fontSize: 14),
            ),
          leading: CircleAvatar(
            child: Text('${clients[index].name.toUpperCase()[0]}'),
          ),
        ),
      ),
      onTap: (){
        _showClientPage(client: clients[index]);
      },
    );
  }

  void _showClientPage({Client client})async{
    final recClient = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => ClientPage(client: client,))
    );
    if(recClient != null){
      if(client != null){
        await dbClient.updateClient(recClient);
      }else{
        await dbClient.saveClient(recClient);
      }
    }
      _getAllClients();
  }

  void _showCreateClientPage({Client client})async{
    final recClient = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => CreateClientPage(client: client,))
    );
    if(recClient != null){
      if(client != null){
        await dbClient.updateClient(recClient);
      }else{
        await dbClient.saveClient(recClient);
      }
      _getAllClients();
    }
  }

  void _getAllClients(){
    dbClient.getAllClients().then((list){
      setState(() {
        clients = list;
      });
    });
  }
}
