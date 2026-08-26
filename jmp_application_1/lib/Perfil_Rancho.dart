import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jmp_application_1/datebase/db_helper.dart';

class PerfilRanchoScreen extends StatelessWidget {
  // Recibimos los datos del rancho desde la pantalla anterior
  final Map<String, dynamic> rancho;

  const PerfilRanchoScreen({Key? key, required this.rancho}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extraemos los datos para usarlos fácil
    final nombre = rancho['nombre'] ?? 'Sin nombre';
    final nombre_prop = rancho['propietario'] ?? 'Sin nombre';
    final ubicacion = rancho['ubicacion'] ?? 'Ubicación desconocida';
    final localidad = rancho['localidad'] ?? 'localidad desconocida';
    final hectareas = rancho['hectareas']?.toString() ?? '0';
    final clave_upp = rancho['clave_upp']?.toString() ?? '0';

    return Scaffold(
      backgroundColor: const Color(0xFF4E342E), // Fondo café oscuro
      appBar: AppBar(
        title: Text(nombre, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3E2723),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      //Metod de Scroll para deslizar de una forma mas fluida
      body: Scrollbar(
        thumbVisibility: true,
        thickness: 8.0,
        radius: const Radius.circular(10),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              // SECCIÓN SUPERIOR: Estilo Perfil de Facebook (Portada y Foto)
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  // "Foto de Portada" (Un banner de color o imagen)
                  Container(
                    height: 150,
                    width: double.infinity,
                    color: const Color(0xFF6D4C41),
                    child: const Opacity(
                      opacity: 0.2,
                      child: Icon(
                        Icons.landscape,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // "Foto de Perfil" circular
                  Positioned(
                    bottom: -50,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 46,
                        backgroundColor: const Color(0xFF3E2723),
                        child: const FaIcon(
                          FontAwesomeIcons.cow,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 60,
              ), // Espacio para la foto de perfil que sobresale
              // Nombre principal
              Text(
                nombre,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Ficha Operativa',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 30),

              // SECCIÓN DE DATOS: Tarjeta acordeon de datos
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5,
                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      iconColor: Colors.brown,
                      collapsedBackgroundColor: Colors.brown[300],
                      leading: const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Icon(Icons.home_work, color: Colors.brown),
                      ),
                      title: const Text(
                        "Datos de Rancho",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      children: [
                        //Nombre del Rancho
                        const Divider(),
                        _crearFilaDato(Icons.man, "Nombre", nombre),
                        //Ubicacion del Rancho
                        const Divider(),
                        _crearFilaDato(
                          Icons.location_on,
                          "Ubicación",
                          ubicacion,
                        ),
                        //Localidad
                        const Divider(),
                        _crearFilaDato(Icons.location_on, "Estado", localidad),
                        //Numero de Hectareas
                        const Divider(),
                        _crearFilaDato(Icons.grass, "Hectáreas", "$hectareas "),
                        //Numero de Animales
                        const Divider(),
                        _crearFilaDato(
                          Icons.pets,
                          "Numero de Animales",
                          rancho['numero_animales']?.toString() ?? '0',
                        ),
                        //Nombre del propietario
                        const Divider(),
                        _crearFilaDato(
                          Icons.man,
                          "Nombre de Propetario",
                          nombre_prop,
                        ),
                        //Clave de UPP
                        const Divider(),
                        _crearFilaDato(
                          Icons.numbers,
                          "Clave de UPP",
                          "$clave_upp ",
                        ),

                        const Divider(),
                        TextButton.icon(
                          onPressed: () {
                            _mostrarDialogoEdicion(context, rancho);
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                          ),
                          label: const Text(
                            "Modificar los datos",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        //Municipío del rancho
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para crear cada renglón de información rápido y limpio
  Widget _crearFilaDato(IconData icono, String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.brown[50],
              shape: BoxShape.circle,
            ),
            child: Icon(icono, color: Colors.brown, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  valor,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Nueva funcion para poder modificar los datos de la tablas
  void _mostrarDialogoEdicion(
    BuildContext context,
    Map<String, dynamic> ranchoActual,
  ) {
    // 1. Controladores que ya inician con el texto actual de la base de datos
    final nombreCtrl = TextEditingController(text: ranchoActual['nombre']);
    final ubicacionCtrl = TextEditingController(
      text: ranchoActual['ubicacion'],
    );
    final localidadCtrl = TextEditingController(
      text: ranchoActual['localidad']?.toString() ?? '',
    );
    final hectareasCtrl = TextEditingController(
      text: ranchoActual['hectareas']?.toString(),
    );
    final animalesCtrl = TextEditingController(
      text: ranchoActual['numero_animales']?.toString(),
    );
    final propCtrl = TextEditingController(text: ranchoActual['propietario']);
    final uppCtrl = TextEditingController(text: ranchoActual['clave_upp']);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Modificar Datos"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(
                    labelText: "Nombre del Rancho",
                  ),
                ),
                TextField(
                  controller: ubicacionCtrl,
                  decoration: const InputDecoration(labelText: "Ubicación"),
                ),
                TextField(
                  controller: localidadCtrl,
                  decoration: const InputDecoration(labelText: "Estado"),
                ),
                TextField(
                  controller: hectareasCtrl,
                  decoration: const InputDecoration(labelText: "Hectáreas"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: animalesCtrl,
                  decoration: const InputDecoration(
                    labelText: "Número de Animales",
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: propCtrl,
                  decoration: const InputDecoration(labelText: "Propietario"),
                ),
                TextField(
                  controller: uppCtrl,
                  decoration: const InputDecoration(labelText: "Clave UPP"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
              onPressed: () async {
                Map<String, dynamic> ranchoCorregido = {
                  'id': ranchoActual['id'],
                  'nombre': nombreCtrl.text,
                  'ubicacion': ubicacionCtrl.text,
                  'localidad': localidadCtrl.text,
                  'hectareas': int.tryParse(hectareasCtrl.text) ?? 0,
                  'numero_animales': int.tryParse(animalesCtrl.text) ?? 0,
                  'propietario': propCtrl.text.trim(),
                  'clave_upp': uppCtrl.text.trim(),
                };

                try {
                  final idRancho = ranchoActual['id'];
                  if (idRancho is! int) {
                    throw StateError('El rancho no tiene un id válido');
                  }

                  final filasActualizadas = await DBHelper().updateRancho(
                    idRancho,
                    ranchoCorregido,
                  );

                  if (filasActualizadas != 1) {
                    throw StateError(
                      'No se encontró el rancho para actualizar',
                    );
                  }

                  await RanchosRepository.instance.refresh();
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al guardar: $e')),
                  );
                }
              },
              child: const Text(
                "Guardar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
