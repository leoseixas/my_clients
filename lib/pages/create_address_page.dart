import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:my_clients/models/Address.dart';
import 'package:my_clients/models/Client.dart';

class CreateAddress extends StatefulWidget {
  final Client client;

  CreateAddress({this.client});

  @override
  _CreateAddressState createState() => _CreateAddressState();
}

class _CreateAddressState extends State<CreateAddress> {
  final _formKey = GlobalKey<FormState>();

  bool _userEdited = false;

  Address _editAddress = Address();

  Client _client;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cpfCnpjController = TextEditingController();
  final _dataController = TextEditingController();
  final _sexoController = TextEditingController();
  final _profissaoController = TextEditingController();
  int idClient = 0;

  var maskTextInputFormatterCep = MaskTextInputFormatter(
      mask: "#####-###", filter: {"#": RegExp(r'[0-9]')});

  final _cepController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _complementoController = TextEditingController();

  final _cepFocus = FocusNode();

  String _valorEscolhido;

  var _estadoUF = [
    'AC','AL','AP','AM','BA','CE','DF','ES','GO','MA',
    'MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN',
    'RS','RO','RR','SC','SP','SE','TO'];

  @override
  void initState() {
    super.initState();
    if (widget.client == null) {
      _client = Client();
    } else {
      _client = Client.fromMap(widget.client.toMap());
      _nameController.text = _client.name;
      _phoneController.text = _client.phone;
      _cpfCnpjController.text = _client.cpfCnpj;
      _dataController.text = _client.data;
      _sexoController.text = _client.sexo;
      _profissaoController.text = _client.profissao;
      idClient = _client.id;
      _editAddress.clientId = _client.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Novo Endereço", style: TextStyle(color:Colors.white),),
            centerTitle: true,
          ),
          floatingActionButton: _floatingActionButton(),
          body: _buildForm(),
      ),
    );
  }

  _buildForm(){
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _builderCepInputField(),
          SizedBox(
            height: 10,
          ),
          _builderLogradouroInputField(),
          SizedBox(
            height: 10,
          ),
          _builderNumInputField(),
          SizedBox(
            height: 10,
          ),
          _builderBairroInputField(),
          SizedBox(
            height: 10,
          ),
          _builderCidadeInputField(),
          SizedBox(
            height: 10,
          ),
          _builderEstadoInputField(),
          SizedBox(
            height: 10,
          ),
          _builderComplementoInputField()
        ],
      ),
    );
  }

  _builderCepInputField(){
    return TextFormField(
      controller: _cepController,
      focusNode: _cepFocus,
      keyboardType: TextInputType.text,
      inputFormatters: [maskTextInputFormatterCep],
      style: TextStyle(fontSize: 20),
      onChanged: (text) {
        _userEdited = true;
        setState(() {
          _editAddress.cep = text;
        });
      },
      decoration: InputDecoration(
          labelText: "CEP",
          filled: true,
          fillColor: Colors.transparent
      ),
    );
  }

  _builderLogradouroInputField(){
    return TextFormField(
      controller: _logradouroController,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      onChanged: (text) {
        _editAddress.logradouro = text;
      },
      decoration: InputDecoration(
          labelText: "Logradouro",
          filled: true,
          fillColor: Colors.transparent
      ),
    );
  }

  _builderNumInputField(){
    return TextFormField(
      controller: _numeroController,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      onChanged: (text) {
        _editAddress.numero = text;
      },
      decoration: InputDecoration(
          labelText: "Número",
          filled: true,
          fillColor: Colors.transparent
       ),
    );
  }

  _builderBairroInputField(){
    return TextFormField(
      controller: _bairroController,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      onChanged: (text) {
        _editAddress.bairro = text;
      },
      decoration: InputDecoration(
          labelText: "Bairro",
          filled: true,
          fillColor: Colors.transparent,
      ),
    );
  }

  _builderCidadeInputField(){
    return TextFormField(
      controller: _cidadeController,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      onChanged: (text) {
        _editAddress.cidade = text;
      },
      decoration: InputDecoration(
          labelText: "Cidade",
          filled: true,
          fillColor: Colors.transparent
      ),
    );
  }

  _builderEstadoInputField(){
    return DropdownButtonFormField(
      decoration: InputDecoration(
          labelText: "Estado",
          fillColor: Colors.transparent,
          filled: true,
      ),
      value: _valorEscolhido,
      items: _estadoUF.map((String dropDownStringItem) {
        return DropdownMenuItem<String>(
          value: dropDownStringItem,
          child: Text(dropDownStringItem),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _valorEscolhido = value;
          _editAddress.estado = value;
        });
      },
    );
  }

  _builderComplementoInputField(){
    return TextFormField(
      controller: _complementoController,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      onChanged: (text) {
        _editAddress.complemento = text;
      },
      decoration: InputDecoration(
          labelText: "Complemento",
          filled: true,
          fillColor: Colors.transparent
      ),
    );
  }

  _floatingActionButton(){
    return FloatingActionButton.extended(
      onPressed: () {
        print(_editAddress);
        if (_editAddress.cep != null && _editAddress.cep.isNotEmpty) {
          Navigator.pop(context, _editAddress);
        } else {
          FocusScope.of(context).requestFocus(_cepFocus);
        }
      },
      label: Text('Salvar'),
      icon: Icon(Icons.save),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
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
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}