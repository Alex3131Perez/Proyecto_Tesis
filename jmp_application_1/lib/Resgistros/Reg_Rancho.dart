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
      body: Padding(
        padding: const EdgeInsetsGeometry.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                color: Color(0xFF4E342E),
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _crearCampoTexto("Nombre del Propietario", TextInputType.name),
                      SizedBox(height: 15),
                      _crearCampoTexto("Nombre del Rancho", TextInputType.name),
                      SizedBox(height: 15),
                      _crearCampoTexto("Clave de UPP", TextInputType.text),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                color: Color(0xFF4E342E),
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _crearCampoTexto("Localizacion del Rancho", TextInputType.streetAddress),
                      SizedBox(height: 15),
                      _crearCampoTexto("Municipio", TextInputType.text),
                      SizedBox(height: 15),
                      _crearCampoTexto("Hectareas de Terreno", TextInputType.number),
                      SizedBox(height: 15),
                      _crearCampoTexto("Numero de Animales", TextInputType.number),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: (){
                //Aqui se conecta la BDD no lo olvides
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3E2723),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
               ),
               child: Text(
                "Guardar",
                style: TextStyle(color: Colors.white, fontSize: 16),
               ),
              )
            ],
          )
        )
      )
    );
  }

  Widget _crearCampoTexto(String etiqueta, TextInputType tipoTeclado) {
    return TextFormField(
      keyboardType: tipoTeclado,
      style: TextStyle(color: Colors.black), // Letras oscuras para leer en el fondo blanco
      decoration: InputDecoration(
        filled: true, // 1. ESTO ACTIVA EL COLOR DE FONDO
        fillColor: Colors.white, // 2. ESTO PINTA EL FONDO TOTALMENTE BLANCO
        hintText: etiqueta,
        labelStyle: TextStyle(color: Colors.grey[800]), // La etiqueta en gris oscuro
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none, // Quitamos la línea de contorno para un diseño más limpio
        ),
      ),
    );
  }
}
