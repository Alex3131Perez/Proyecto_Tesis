import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Resgistros/Reg_Alimento.dart';
import 'Resgistros/Reg_Rancho.dart';
import 'Resgistros/Reg_Traslados.dart';
import 'Resgistros/Reg_Venta.dart';
import 'datebase/db_helper.dart';
import 'Perfil_Rancho.dart'; // Ajusta la ruta si lo tienes en otra carpeta

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xFF6D4C41),
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFF6D4C41),
    ),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      body: Center(
        child: Text('Algo salió mal', style: TextStyle(color: Colors.red)),
      ),
    );
  };

  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stack) {});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JMP Ganadera',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Color(0xFF4E342E),
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // He reducido el tiempo a 4 segundos, 8 es demasiado largo para un usuario moderno.
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF4E342E),
        child: Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'JMP',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6D4C41),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFFE1BEE7),
                    child: Icon(
                      Icons.person_outline,
                      size: 50,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: "ejemplo@correo.com",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingresa tu email';
                            }
                            if (!value.contains('@')) {
                              return 'Email no válido';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Contraseña",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _isObscure,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: "••••••••",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingresa tu contraseña';
                            }
                            if (value.length < 6) {
                              return 'Mínimo 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2D2D2D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Sign In",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Función en desarrollo'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          },
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 24),
                      child: Column(
                        children: [
                          Text(
                            "¿No tienes una cuenta?",
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 150,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Pantalla de registro en desarrollo',
                                    ),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF2D2D2D),
                              ),
                              child: Text(
                                "Registrate",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              SizedBox(width: 15),
              Text('Verificando credenciales...'),
            ],
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green[800],
        ),
      );

      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PerfilRanchoScreen(rancho: rancho),
                  ),
                );
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
