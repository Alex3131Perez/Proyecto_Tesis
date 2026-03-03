import 'package:flutter/material.dart';

class RegistroAlimentoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Registro de Alimento",
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