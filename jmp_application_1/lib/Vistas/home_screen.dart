import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jmp_application_1/Perfil_Rancho.dart';
import 'package:jmp_application_1/Resgistros/Reg_Alimento.dart';
import 'package:jmp_application_1/Resgistros/Reg_Rancho.dart';
import 'package:jmp_application_1/Resgistros/Reg_Traslados.dart';
import 'package:jmp_application_1/Resgistros/Reg_Venta.dart';
import 'package:jmp_application_1/Vistas/login_screen.dart';
import 'package:jmp_application_1/datebase/db_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color darkCoffee = Color(0xFF3E2723);
  final Color mediumCoffee = Color(0xFF5D4037);

  List<Map<String, dynamic>> misRanchos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarRanchos();
  }

  Future<void> _cargarRanchos() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await DBHelper().getAllRanchos();
      setState(() {
        misRanchos = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error BD: $e");
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
          ? _construirVistaVacia()
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

  Widget _construirCuadricula() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PerfilRanchoScreen(rancho: rancho),
                  ),
                ).then((actualizado) {
                  if (actualizado == true) {
                    _cargarRanchos();
                  }
                });
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.landscape, size: 40, color: Colors.brown),
                    SizedBox(height: 10),
                    Text(
                      rancho['nombre'] ?? 'Sin nombre',
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
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
        Navigator.pop(context);
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => pantalla),
        );
        _cargarRanchos();
      },
    );
  }

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
              Reg_AlimentoScreen(),
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
            Divider(thickness: 1),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.redAccent),
              title: Text(
                'Cerrar Sesión',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
