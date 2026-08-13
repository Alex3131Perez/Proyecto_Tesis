import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PerfilRanchoScreen extends StatelessWidget {
  // Recibimos los datos del rancho desde la pantalla anterior
  final Map<String, dynamic> rancho;

  const PerfilRanchoScreen({Key? key, required this.rancho}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extraemos los datos para usarlos fácil
    final nombre = rancho['nombre'] ?? 'Sin nombre';
    final ubicacion = rancho['ubicacion'] ?? 'Ubicación desconocida';
    final hectareas = rancho['hectareas']?.toString() ?? '0';

    return Scaffold(
      backgroundColor: const Color(0xFF4E342E), // Fondo café oscuro
      appBar: AppBar(
        title: Text(nombre, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3E2723),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
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

            // SECCIÓN DE DATOS: Tarjeta con la información
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _crearFilaDato(
                        Icons.person,
                        "Dueño del Terreno",
                        "Propietario Pendiente (Falta en BDD)",
                      ),
                      const Divider(),
                      _crearFilaDato(Icons.location_on, "Ubicación", ubicacion),
                      const Divider(),
                      _crearFilaDato(Icons.map, "Hectáreas", "$hectareas "),
                      const Divider(),
                      _crearFilaDato(
                        Icons.pets,
                        "Número de Animales",
                        "0 (Falta en BDD)",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
}
