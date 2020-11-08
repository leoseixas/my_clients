import 'package:flutter/material.dart';
import 'package:my_clients/models/Client.dart';

class AccountInfo extends StatelessWidget {
  final bool isExpanded;
  final Client editClient;
  AccountInfo({this.isExpanded, this.editClient});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: isExpanded ? MediaQuery.of(context).size.height*.2 : 0,
      duration: Duration(milliseconds: 400),
      width: double.maxFinite,
      padding: EdgeInsets.only(top: 15),
      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Telefone: ${editClient.phone}',
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'CPF: ${editClient.cpfCnpj}',
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Data Nascimento: ${editClient.data}',
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Sexo: ${editClient.sexo}',
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Profissão: ${editClient.profissao}',
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
