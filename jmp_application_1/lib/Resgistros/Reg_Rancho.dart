import 'package:flutter/material.dart';
import 'package:jmp_application_1/datebase/db_helper.dart'; // Asegúrate de que este import apunte a tu archivo real

class Reg_RanchoScreen extends StatefulWidget {
  @override
  _RegistroRanchoScreenState createState() => _RegistroRanchoScreenState();
}

class _RegistroRanchoScreenState extends State<Reg_RanchoScreen> {
  final _formKey = GlobalKey<FormState>();

  // 1. CREAMOS LOS CONTROLADORES para capturar el texto
  final _nombreRanchoController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _hectareasController = TextEditingController();

  // (Controladores de relleno para los campos que aún no están en la BDD)
  final _propietarioController = TextEditingController();
  final _uppController = TextEditingController();
  final _municipioController = TextEditingController();
  final _animalesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar Rancho", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF3E2723),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Card(
                  color: Color(0xFF4E342E),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _crearCampoTexto(
                          "Nombre del Propietario",
                          TextInputType.name,
                          _propietarioController,
                        ),
                        SizedBox(height: 15),
                        // Este sí va a la BDD
                        _crearCampoTexto(
                          "Nombre del Rancho",
                          TextInputType.name,
                          _nombreRanchoController,
                        ),
                        SizedBox(height: 15),
                        _crearCampoTexto(
                          "Clave de UPP",
                          TextInputType.text,
                          _uppController,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  color: Color(0xFF4E342E),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Este sí va a la BDD
                        _crearCampoTexto(
                          "Localizacion del Rancho",
                          TextInputType.streetAddress,
                          _ubicacionController,
                        ),
                        SizedBox(height: 15),
                        _crearCampoTexto(
                          "Municipio",
                          TextInputType.text,
                          _municipioController,
                        ),
                        SizedBox(height: 15),
                        // Este sí va a la BDD
                        _crearCampoTexto(
                          "Hectareas de Terreno",
                          TextInputType.number,
                          _hectareasController,
                        ),
                        SizedBox(height: 15),
                        _crearCampoTexto(
                          "Numero de Animales",
                          TextInputType.number,
                          _animalesController,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    final nuevoRancho = {
                      'nombre': _nombreRanchoController.text.trim(),
                      'ubicacion': _ubicacionController.text.trim(),
                      'hectareas': int.tryParse(_hectareasController.text) ?? 0,
                      'propietario': _propietarioController.text.trim(),
                      'numero_animales':
                          int.tryParse(_animalesController.text) ?? 0,
                    };

                    try {
                      await DBHelper().insertRancho(nuevoRancho);

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Rancho guardado en la base de datos"),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );

                      await Future.delayed(const Duration(seconds: 2));

                      if (!mounted) return;
                      Navigator.pop(context);
                    } catch (e) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error al guardar el rancho: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 3. ACTUALIZAMOS ESTE MÉTODO para que reciba el controlador
  Widget _crearCampoTexto(
    String etiqueta,
    TextInputType tipoTeclado,
    TextEditingController controlador,
  ) {
    return TextFormField(
      controller: controlador, // Aquí asignamos el controlador
      keyboardType: tipoTeclado,
      style: TextStyle(color: Colors.black),
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

  // Es buena práctica limpiar los controladores al salir
  @override
  void dispose() {
    _nombreRanchoController.dispose();
    _ubicacionController.dispose();
    _hectareasController.dispose();
    _propietarioController.dispose();
    _uppController.dispose();
    _municipioController.dispose();
    _animalesController.dispose();
    super.dispose();
  }
}
