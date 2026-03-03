import 'package:flutter/material.dart';

class RegistroRanchoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        title: Text(
          "Registrar Rancho",
          // AQUÍ CAMBIAMOS EL COLOR A BLANCO
          style: TextStyle(color: Colors.white), 
        ),
        backgroundColor: Color(0xFF3E2723),
        // Esto hace que la flecha de regreso también sea blanca
        iconTheme: IconThemeData(color: Colors.white), 
      ),
    );
  }
}

