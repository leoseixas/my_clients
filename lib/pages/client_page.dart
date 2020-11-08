import 'package:flutter/material.dart';
import 'package:my_clients/database/address_dao.dart';
import 'package:my_clients/database/client_dao.dart';
import 'package:my_clients/models/Address.dart';
import 'package:my_clients/models/Client.dart';
import 'package:my_clients/widgets/account_info.dart';
import 'package:my_clients/widgets/custom_bottom_client.dart';
import 'create_address_page.dart';
import 'create_client_page.dart';


class ClientPage extends StatefulWidget {
  final Client client;

  ClientPage({this.client});

  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  ClientDao dbClient = ClientDao();
  AddressDao dbAddress = AddressDao();

  List<Address> adresses = List();

  Client _editClient;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cpfCnpjController = TextEditingController();
  final _dataController = TextEditingController();
  final _sexoController = TextEditingController();
  final _profissaoController = TextEditingController();

  int idClient = 0;

  bool _isExpanded = false;

  List<String> itensMenu = ["Editar", "Excluir"];

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "Editar":
        _showCreateClientPage(client: _editClient);
        break;
      case "Excluir":
        setState(() {
          dbClient.deleteClient(_editClient.id);
          Navigator.pop(context);
        });
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.client == null) {
      _editClient = Client();
    } else {
      _editClient = Client.fromMap(widget.client.toMap());

      _nameController.text = _editClient.name;
      _phoneController.text = _editClient.phone;
      _cpfCnpjController.text = _editClient.cpfCnpj;
      _dataController.text = _editClient.data;
      _sexoController.text = _editClient.sexo;
      _profissaoController.text = _editClient.profissao;
      idClient = _editClient.id;
      _getAllAddressFromClient(idClient);
    }

    print(_editClient);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      floatingActionButton: _floatingActionButton(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _clientInfo(),
              AccountInfo(
                isExpanded: _isExpanded,
                editClient: _editClient,
              ),
              _buildListAddress(),
            ],
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: _escolhaMenuItem,
          itemBuilder: (context) {
            return itensMenu.map((String item) {
              return PopupMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  _floatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        _showCreateAddressPage(client: _editClient);
      },
      label: Text('Novo endereço'),
      icon: Icon(Icons.add),
    );
  }

  _clientInfo() {
    return Container(
      height: 150,
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              child: Text('${_editClient.name.toUpperCase()[0]}'),
              maxRadius: 35,
            ),
            Text(
              '${_editClient.name}',
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            CustomBottomClient(
                isExpanded: _isExpanded,
              onTap: (){
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
              }
            ),

          ],
        ),
      ),
    );
  }

  _buildListAddress() {
    return ListView.builder(
      padding: EdgeInsets.all(8),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: adresses.length,
      itemBuilder: (context, index) {
        return _adressesCard(context, index);
      },
    );
  }

  _adressesCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Text(
                    ("Cep: " + adresses[index].cep) ?? "",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ("Rua: " + adresses[index].logradouro) ?? "",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    ("Numero: " + adresses[index].numero) ?? "",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    ("Bairro: " + adresses[index].bairro) ?? "",
                    style: TextStyle(fontSize: 18),
                  ),

                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ("Cidade: " + adresses[index].cidade) ?? "",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    ("Estado: " + adresses[index].estado) ?? "",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    ("Complemento: " + adresses[index].complemento) ?? "",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              )
            ],
          )
        ),
      ),
      onTap: () {
        _showAdress(context, index);
      },
    );
  }

  void _showAdress(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Deseja Excluir este endereço?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Sim"),
                onPressed: () {
                  dbAddress.deleteAddress(adresses[index].id);
                  setState(() {
                    adresses.removeAt(index);
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  void _showCreateClientPage({Client client}) async {
    final recClient = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateClientPage(
                  client: client,
                )));
    if (recClient != null) {
      if (client != null) {
        await dbClient.updateClient(recClient);
      } else {
        await dbClient.saveClient(recClient);
      }
      _getClient(client.id);
    }
  }

  void _getClient(int id) {
    dbClient.getClient(id).then((list) {
      setState(() {
        _editClient = list;
      });
    });
  }

  void _showCreateAddressPage({Client client}) async {
    final recAddress = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateAddress(
                  client: client,
                )));
    if (recAddress != null) {
      await dbAddress.saveAddress(recAddress);
      _getAllAddressFromClient(_editClient.id);
    }
  }

  void _getAllAddressFromClient(int id) {
    dbAddress.getAdressesFromClient(id).then((list) {
      setState(() {
        adresses = list;
      });
    });
  }
}
