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
              _crearCampoTexto("Nombre del Propietario", TextInputType.name),
              SizedBox(height: 15),
              _crearCampoTexto("Nombre del Rancho", TextInputType.name),
              SizedBox(height: 15),
              _crearCampoTexto("Clave de UPP", TextInputType.text),
              SizedBox(height: 15),
              _crearCampoTexto("Localizacion del Rancho", TextInputType.streetAddress),
              SizedBox(height: 15),
              _crearCampoTexto("Municipio", TextInputType.text),
              SizedBox(height: 15),
              _crearCampoTexto("Hectareas de Terreno", TextInputType.number),
              SizedBox(height: 15),
              _crearCampoTexto("Numero de Animales", TextInputType.number),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: (){
                //Aqui se conecta la BDD no lo olvides Alex
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

  Widget _crearCampoTexto(String etiqueta, TextInputType tipoTeclado){
    return TextFormField(
      keyboardType: tipoTeclado,
      decoration: InputDecoration(
        labelText: etiqueta,
        border: OutlineInputBorder(),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF3E2723), width: 2.0),
        
          ),
      ),
    );
  }
}

