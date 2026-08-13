import 'package:flutter/material.dart';

class Reg_TrasladosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        title: Text(
          "Registro de Traslados",
          style: TextStyle(color: Colors.white), 
        ),
        backgroundColor: Color(0xFF3E2723),
        iconTheme: IconThemeData(color: Colors.white), 
      ),
    );
  }
}
