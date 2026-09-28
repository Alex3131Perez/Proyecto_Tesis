import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jmp_application_1/datebase/db_helper.dart';
import 'Resgistros/Reg_Rancho.dart';
import 'Resgistros/Reg_Alimento.dart';
import 'Resgistros/Reg_Traslados.dart';
import 'Resgistros/Reg_Venta.dart';
import 'datebase/db_helper.dart'; // Ajusta la ruta si lo tienes en otra carpeta

class MenuPrincipalScreen extends StatefulWidget {
  @override
  _MenuPrincipalScreenState createState() => _MenuPrincipalScreenState();
}

class _MenuPrincipalScreenState extends State<MenuPrincipalScreen> {
  final Color darkCoffee = Color(0xFF3E2723);
  final Color mediumCoffee = Color(0xFF5D4037);

  // Lista dinámica que almacenará los ranchos obtenidos de SQLite
  List<Map<String, dynamic>> misRanchos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarRanchos(); // Carga los datos al iniciar la pantalla
  }

  // Función para conectarse a SQLite y actualizar la pantalla
  Future<void> _cargarRanchos() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Llamada real a tu base de datos
      final data = await DBHelper().getAllRanchos();

      setState(() {
        misRanchos = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error al cargar la base de datos: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mediumCoffee,
      appBar: AppBar(
        title: Text('JMP Ganadera', style: TextStyle(color: Colors.white)),
        backgroundColor: darkCoffee,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : misRanchos.isEmpty
          // Si no hay nada guardado, mostramos la vaca
          ? _construirVistaVacia()
          // Si hay datos, mostramos la cuadrícula interactiva
          : _construirCuadricula(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarMenuOpciones(context);
        },
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  // Vista 1: Cuando la base de datos está vacía
  Widget _construirVistaVacia() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.cow, size: 130, color: Colors.white24),
          SizedBox(height: 30),
          Text(
            '¡Bienvenido!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Sistema de Gestión Ganadera',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // Vista 2: La cuadrícula dinámica cuando ya hay registros
  Widget _construirCuadricula() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: misRanchos.length,
        itemBuilder: (context, index) {
          final rancho = misRanchos[index];
          return Card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                _mostrarDatosDelPotrero(context, rancho);
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.landscape, size: 40, color: Colors.brown),
                    SizedBox(height: 10),
                    Text(
                      rancho['nombre'] ?? 'Sin nombre',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Ventana emergente con los datos del rancho
  void _mostrarDatosDelPotrero(
    BuildContext context,
    Map<String, dynamic> rancho,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(rancho['nombre'] ?? 'Detalles'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ubicación: ${rancho['ubicacion'] ?? 'N/A'}'),
              Text('Hectáreas: ${rancho['hectareas'] ?? 'N/A'}'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Diseño del menú inferior
  Widget _opcionMenu(
    BuildContext context,
    IconData icon,
    String texto,
    Widget pantalla,
  ) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.brown[50],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Color.fromARGB(255, 0, 0, 0)),
      ),
      title: Text(texto, style: TextStyle(fontWeight: FontWeight.w600)),
      onTap: () async {
        Navigator.pop(context); // Cierra el menú inferior

        // Navega a la pantalla y espera a que el usuario regrese
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => pantalla),
        );

        // Al regresar, vuelve a consultar la BDD para refrescar la pantalla
        _cargarRanchos();
      },
    );
  }

  // Menú desplegable inferior
  void _mostrarMenuOpciones(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, color: Colors.grey[300]),
            SizedBox(height: 20),
            _opcionMenu(
              context,
              Icons.home_work,
              'Registrar Rancho',
              Reg_RanchoScreen(),
            ),
            _opcionMenu(
              context,
              Icons.grass,
              'Registrar Alimento',
              Reg_AlimentoScreen(ranchoId: 1),
            ),
            _opcionMenu(
              context,
              Icons.local_shipping,
              'Registro de Traslados',
              Reg_TrasladosScreen(),
            ),
            _opcionMenu(
              context,
              Icons.monetization_on,
              'Registro de Venta',
              Reg_VentaScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
