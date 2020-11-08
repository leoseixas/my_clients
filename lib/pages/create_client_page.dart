import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:my_clients/models/Client.dart';

class CreateClientPage extends StatefulWidget {
  final Client client;

  CreateClientPage({Key key, this.client}) : super(key: key);

  @override
  _CreateClientPageState createState() => _CreateClientPageState();
}

class _CreateClientPageState extends State<CreateClientPage> {
  bool _userEdited = false;

  Client _editClient;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cpfCnpjController = TextEditingController();
  final _dataController = TextEditingController();

  final _nameFocus = FocusNode();

  String _profissaoSelecionado;
  String _sexoSelecionado;

  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});
  var maskTextInputFormatterDate = MaskTextInputFormatter(
      mask: "##/##/####", filter: {"#": RegExp(r'[0-9]')});

  var _profissoes = ['Desenvolvedor', 'Tester', 'Gerente de Projetos'];

  var _sexo = ['Masculino', 'Feminino'];

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editClient.name ?? "Novo Cliente", style: TextStyle(color: Colors.white),),
          centerTitle: true,
        ),
        floatingActionButton: _floatingActionButton(),
        body: _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _builderNameInputField(),
          SizedBox(
            height: 10,
          ),
          _builderPhoneInputField(),
          SizedBox(
            height: 10,
          ),
          _builderCpfInputField(),
          SizedBox(
            height: 10,
          ),
          _builderDataInputField(),
          SizedBox(
            height: 10,
          ),
          _builderSexoInputField(),
          SizedBox(
            height: 10,
          ),
          _builderProfessionInputField(),
          SizedBox(
            height: 10,
          ),
          // _buildConfirmButton()
        ],
      ),
    );
  }

  _builderNameInputField() {
    return TextFormField(
      controller: _nameController,
      focusNode: _nameFocus,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      onChanged: (text) {
        _userEdited = true;
        setState(() {
          _editClient.name = text;
        });
      },
      decoration: InputDecoration(
          icon: Icon(Icons.person),
          labelText: "Nome",
          // contentPadding: EdgeInsets.fromLTRB(32,16,32,16),
          filled: true,
          fillColor: Colors.transparent
          // border: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(32)
          // )
          ),
    );
  }

  _builderPhoneInputField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      style: TextStyle(fontSize: 20),
      onChanged: (text) {
        _editClient.phone = text;
      },
      decoration: InputDecoration(
          icon: Icon(Icons.phone),
          labelText: "Telefone",
          filled: true,
          fillColor: Colors.transparent),
    );
  }

  _builderCpfInputField() {
    return TextFormField(
      controller: _cpfCnpjController,
      keyboardType: TextInputType.number,
      inputFormatters: [maskTextInputFormatter],
      style: TextStyle(fontSize: 20),
      onChanged: (text) {
        _editClient.cpfCnpj = text;
      },
      decoration: InputDecoration(
        icon: Icon(Icons.calendar_view_day),
        labelText: "CPF",
        filled: true,
        fillColor: Colors.transparent,
      ),
    );
  }

  _builderDataInputField() {
    return TextField(
      controller: _dataController,
      keyboardType: TextInputType.datetime,
      inputFormatters: [maskTextInputFormatterDate],
      style: TextStyle(fontSize: 20),
      onChanged: (text) {
        _editClient.data = text;
      },
      decoration: InputDecoration(
        icon: Icon(Icons.calendar_today_outlined),
        labelText: "Data de Nascimento",
        filled: true,
        fillColor: Colors.transparent,
      ),
    );
  }

  _builderSexoInputField() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.people),
        labelText: "Sexo",
        filled: true,
        fillColor: Colors.transparent,
      ),
      value: _sexoSelecionado,
      items: _sexo.map((String dropDownStringItem) {
        return DropdownMenuItem<String>(
          value: dropDownStringItem,
          child: Text(dropDownStringItem),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _sexoSelecionado = value;
          _editClient.sexo = value;
        });
      },
    );
  }

  _builderProfessionInputField() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.work),
        labelText: "Profissão",
        filled: true,
        fillColor: Colors.transparent,
      ),
      value: _profissaoSelecionado,
      items: _profissoes.map((String dropDownStringItem) {
        return DropdownMenuItem<String>(
          value: dropDownStringItem,
          child: Text(dropDownStringItem),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _profissaoSelecionado = value;
          _editClient.profissao = value;
        });
      },
    );
  }

  _floatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        if (_editClient.name != null && _editClient.name.isNotEmpty) {
          Navigator.pop(context, _editClient);
        } else {
          FocusScope.of(context).requestFocus(_nameFocus);
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
