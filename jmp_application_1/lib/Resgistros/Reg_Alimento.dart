import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jmp_application_1/datebase/db_helper.dart'; // Asegúrate de que este import apunte a tu archivo real

class Reg_AlimentoScreen extends StatefulWidget {
  final int
  ranchoId; // Variable para saber a qué rancho pertenece este alimento

  const Reg_AlimentoScreen({Key? key, required this.ranchoId})
    : super(key: key);

  @override
  State<Reg_AlimentoScreen> createState() => _RegAlimentoScreenState();
}

class _RegAlimentoScreenState extends State<Reg_AlimentoScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para leer el texto
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _cantidadCtrl = TextEditingController();
  final TextEditingController _costoCtrl = TextEditingController();

  Future<void> _guardarAlimento() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> nuevoAlimento = {
        'nombre': _nombreCtrl.text,
        'cantidad': double.tryParse(_cantidadCtrl.text) ?? 0.0,
        'costo_kilo': double.tryParse(_costoCtrl.text) ?? 0.0,
        'rancho_id': widget.ranchoId,
      };

      await DBHelper().insertAlimento(nuevoAlimento);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alimento registrado correctamente')),
        );
        Navigator.pop(context); // Regresa a la pantalla anterior
      }
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _cantidadCtrl.dispose();
    _costoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Registro de Alimento",
          style: TextStyle(color: Colors.white), // Color blanco que tenías
        ),
        backgroundColor: const Color(0xFF3E2723), // Tu color café oscuro
        iconTheme: const IconThemeData(color: Colors.white), // Flecha blanca
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              //Metodos de registros (Alimentos)
              TextFormField(
                controller: _nombreCtrl,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Alimento Disponible',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.grass, color: Colors.black),

                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Por favor ingrese un nombre' : null,
              ),
              const SizedBox(height: 16),
              //Cantidades de alimentos por Kilos Aqui tiene que ser o floats o int
              TextFormField(
                controller: _cantidadCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter
                      .digitsOnly, // Solo permite números enteros
                ],
                decoration: const InputDecoration(
                  labelText: 'Cantidad (Unidades/Kg)',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.scale, color: Colors.black),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Por favor ingrese la cantidad' : null,
              ),
              const SizedBox(height: 16),

              //COSTO DE ALIMENTO SOLO NUMEROS ENTEROS
              TextFormField(
                controller: _costoCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                ),
                decoration: const InputDecoration(
                  labelText: 'Costo (\$)',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(
                    Icons.attach_money,
                    color: Colors.black,
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Por favor ingrese el costo' : null,
              ),
              const SizedBox(height: 32),
              //AQUI TERMINA
              ElevatedButton(
                onPressed: _guardarAlimento,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(
                    0xFF3E2723,
                  ), // Combina con tu AppBar
                ),
                child: const Text(
                  'Guardar Registro',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
