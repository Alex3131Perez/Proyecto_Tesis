import 'package:flutter/material.dart';

class RegistroRanchoScreen extends StatefulWidget {
  @override
  _RegistroRanchoScreenState createState() => _RegistroRanchoScreenState();
}

class _RegistroRanchoScreenState extends State<RegistroRanchoScreen> {
  // Llave maestra para controlar el formulario
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Registrar Rancho",
          style: TextStyle(color: Colors.white), 
        ),
        backgroundColor: Color(0xFF3E2723),
        iconTheme: IconThemeData(color: Colors.white), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), 
        child: SingleChildScrollView(
          // Envolvemos todo en un Form y le asignamos la llave
          child: Form(
            key: _formKey,
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
                    // Si todos los campos están llenos, se ejecuta esto:
                    if (_formKey.currentState!.validate()) {

                     ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Todos los datos estan guardados correctamente"),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                     );

                     Future.delayed(Duration(seconds: 2), (){
                        Navigator.pop(context);
                     });

                    }
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
      )
    );
  }

  Widget _crearCampoTexto(String etiqueta, TextInputType tipoTeclado) {
    return TextFormField(
      keyboardType: tipoTeclado,
      style: TextStyle(color: Colors.black), 
      // Esta es la validación que marca el error en rojo si está vacío
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este dato es obligatorio';
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true, 
        fillColor: Colors.white, 
        hintText: etiqueta,
        labelStyle: TextStyle(color: Colors.grey[800]), 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none, 
        ),
      ),
    );
  }
}
