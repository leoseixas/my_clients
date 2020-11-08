import 'package:flutter/material.dart';
import 'package:my_clients/pages/home_page.dart';

void main() {
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Lista de clientes',
            theme: ThemeData(
                primaryColor: Color(0xFF86B9FC),
                accentColor: Color(0xFF648ABD),
                primarySwatch: Colors.blueGrey,
            ),
            home: HomePage(),
        );
    }
}


