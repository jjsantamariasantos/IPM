import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model.dart';
import 'objects.dart';

class ResponsiveLayout{
  static bool isSmallScreen(BuildContext context){
    return MediaQuery.of(context).size.width < 500;
  }
  static double getFontSize(BuildContext context, double defaultSize){
    return isSmallScreen(context) ? defaultSize  : defaultSize* 0.8;
  }
  static double getSpacing(BuildContext context, double defaultSpacing){
    return isSmallScreen(context) ? defaultSpacing  : defaultSpacing * 0.5;
  }
  static double getIconSize(BuildContext context, double defaultSize){
    return isSmallScreen(context) ? defaultSize : defaultSize* 0.8 ;
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Proveedor(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomeScreen(),
        ItemMedicamentoView.ruta: (context) => const ItemMedicamentoView(),
        RecordatorioTomasView.ruta: (context) => const RecordatorioTomasView(),
        alarmas_View.ruta: (context) => const alarmas_View(),
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 41, 182, 145),
          brightness: Brightness.light,
        ),
      ),
    );
  }
}

// LOGIN PAGE
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController numeroDePaciente = TextEditingController();
    final isSmallScreen = ResponsiveLayout.isSmallScreen(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo degradado
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 237, 241, 241), Color.fromARGB(255, 41, 182, 145)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child:SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(ResponsiveLayout.getSpacing(context, 16.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/IconoAPPMed.png',
                      height: isSmallScreen ? 100 : 50,
                      width:  isSmallScreen ? 100 : 50,
                    ),
                    SizedBox(height: ResponsiveLayout.getSpacing(context, 16)),
                    Text(
                      'Tu salud, nuestro mejor galardón.',
                      style: TextStyle(
                        fontSize: ResponsiveLayout.getFontSize(context, 20),
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 18, 122, 95),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ResponsiveLayout.getSpacing(context, 16)),
                    Text(
                      'Bienvenido.',
                      style: TextStyle(
                        fontSize: ResponsiveLayout.getFontSize(context, 24),
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 18, 122, 95),
                      ),
                    ),
                    SizedBox(height: ResponsiveLayout.getSpacing(context, 16)),
                    TextField(
                      controller: numeroDePaciente,
                      decoration: const InputDecoration(
                        labelText: 'Inserte su código de paciente.',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: ResponsiveLayout.getSpacing(context, 24)),
                    ElevatedButton(
                      onPressed: () async{
                        bool exist = await context.read<Proveedor>().buscarPaciente(numeroDePaciente.text);
                        if(exist){
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                      child: const Text('Entrar'),
                    )
                  ],
                ),
              ),
            ),
          ),

          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Pillbell v2.0',
                style: TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(255, 18, 122, 95),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// HOME SCREEN
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Proveedor>().actualMedicacionList(Proveedor().fechaAhora);
    });
    
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      context.read<Proveedor>().actualMedicacionList(Proveedor().fechaAhora); // Actualizar la lista de medicamentos al seleccionar la primera pestaña
    }
    if(index==1){
      context.read<Proveedor>().fechaActualizar(Proveedor().fechaAhora);
      context.read<Proveedor>().cargarPosologiasActuales(Proveedor().fechaAhora);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = ResponsiveLayout.isSmallScreen(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Paciente:\n${context.watch<Proveedor>().pacienteActual?.name ?? "Cargando..."} ${context.watch<Proveedor>().pacienteActual?.surname ?? "Cargando..."}',
          style: TextStyle(
            fontSize: ResponsiveLayout.getFontSize(context, 25),
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 41, 182, 145),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          MedicamentosScreen(),
          CalendarioScreen(),
          AlarmasScreen(),
        ],
      ),
      bottomNavigationBar: !isSmallScreen ? null : BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.medication, size: ResponsiveLayout.getIconSize(context, 24)),
            label: 'Medicación',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today, size: ResponsiveLayout.getIconSize(context, 24)),
            label: 'Tomas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, size: ResponsiveLayout.getIconSize(context, 24)),
            label: 'Alarmas',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      drawer: !isSmallScreen ? Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.medication, size: ResponsiveLayout.getIconSize(context, 24)),
              title: Text('Medicación',
                  style: TextStyle(fontSize: ResponsiveLayout.getFontSize(context, 14))
              ),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today, size: ResponsiveLayout.getIconSize(context, 24)),
              title: Text('Tomas',
                  style: TextStyle(fontSize: ResponsiveLayout.getFontSize(context, 14))
              ),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: Icon(Icons.notifications, size: ResponsiveLayout.getIconSize(context, 24)),
              title: Text('Alarmas',
                  style: TextStyle(fontSize: ResponsiveLayout.getFontSize(context, 14))
              ),
              onTap: () => _onItemTapped(2),
            ),
          ],
        ),
      ) : null,
    );
  }
}

// Medicamentos Screen (Separado en una clase)
class MedicamentosScreen extends StatelessWidget {
  const MedicamentosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listaMedicinas = context.watch<Proveedor>().listaMedicinasActuales;
    final isSmallScreen = ResponsiveLayout.isSmallScreen(context);

    return Scaffold(
      body: listaMedicinas.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.all(ResponsiveLayout.getSpacing(context, 16.0)),
                  child: Text(
                    'Medicamentos Actuales:',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 41, 182, 145),
                      fontSize: ResponsiveLayout.getFontSize(context, 16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    restorationId: 'sampleItemListView',
                    itemCount: listaMedicinas.length,
                    itemBuilder: (context, index){
                      final medication = listaMedicinas[index];
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: ResponsiveLayout.getSpacing(context, 16.0),
                          vertical: ResponsiveLayout.getSpacing(context, 8.0),
                        ),
                        title: Text(
                          medication.name,
                          style: TextStyle(
                            fontSize: ResponsiveLayout.getFontSize(context, 16),
                          ),
                        ),
                        subtitle: Text(
                          'Dosis: ${medication.dosage}mg. - Fecha de inicio: ${medication.startdate}.',
                          style: TextStyle(
                            fontSize: ResponsiveLayout.getFontSize(context, 14),
                          ),
                        ),
                        leading: const CircleAvatar(
                          foregroundImage:
                            AssetImage('assets/images/imagen_lista_medicamentos.png'),
                        ),
                        onTap: (){
                          context.read<Proveedor>().seleccionarMedicacion(medication);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetalleTomaScreen(medicacion: medication),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            )
          : const Center(
              child: Text('No hay medicaciones actuales'),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistorialTomasScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: const Color.fromARGB(255, 41, 182, 145),
          ),
          child: const Text(
            'Historial de medicamentos',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// Calendario Screen (Separado en una clase)
class CalendarioScreen extends StatefulWidget {
  const CalendarioScreen({super.key});

  @override
  _CalendarioScreenState createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Proveedor>().updateMarkStatus(context.read<Proveedor>().fechaActual);
    });

  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = ResponsiveLayout.isSmallScreen(context);

    return Consumer<Proveedor>(
      builder: (context, controlador, child) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.all(ResponsiveLayout.getSpacing(context, 16.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recordatorios:',
                  style: TextStyle(
                    fontSize: ResponsiveLayout.getFontSize(context, 24),
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 1, 169, 157),
                    decoration: TextDecoration.underline,
                    decorationColor: const Color.fromARGB(255, 1, 169, 157),
                    decorationThickness: 2.0,
                  ),
                ),
                SizedBox(height: ResponsiveLayout.getSpacing(context, 16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                          Icons.arrow_back,
                          size: ResponsiveLayout.getIconSize(context, 24),
                      ),
                      onPressed: controlador.diaAnterior,
                    ),
                    Text(
                      controlador.obtenerFechaFormateada(),
                      style: TextStyle(
                          fontSize: ResponsiveLayout.getFontSize(context, 18),
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(
                          Icons.arrow_forward,
                          size: ResponsiveLayout.getIconSize(context, 24),
                      ),
                      onPressed: controlador.diaSiguiente,
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveLayout.getSpacing(context, 8)),
                Expanded(
                  child: ListView.builder(
                    itemCount: controlador.posologiasActuales.length,
                    itemBuilder: (BuildContext context, int index) {
                      final toma = controlador.posologiasActuales[index];
                      final bool esPasada = controlador.esTomaPasada(toma);
                      final bool esFutura = controlador.esTomaFutura(toma);
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: ResponsiveLayout.getSpacing(context, 16.0),
                          vertical: ResponsiveLayout.getSpacing(context, 8.0),
                        ),
                        title: Text(
                          '${toma.posologia.hour}:${toma.posologia.min.toString().padLeft(2, '0')} - ${toma.name}',
                          style: TextStyle(
                            fontSize: ResponsiveLayout.getFontSize(context, 16),
                            decoration: toma.mark ? TextDecoration.lineThrough : null,
                            color: toma.mark ? Colors.grey : null,
                          ),
                        ),
                        trailing: Transform.scale(
                          scale: isSmallScreen ? 1.0 : 0.8,
                          child:Checkbox(
                            value: toma.mark,
                            onChanged: (!esPasada && !esFutura && !toma.mark)
                                ? (bool? value) => _mostrarConfirmacion(context, controlador, toma)
                                : null,
                          ),
                        )
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _mostrarConfirmacion(BuildContext context, Proveedor controlador, InfoMed toma) {
    final isSmallScreen = ResponsiveLayout.isSmallScreen(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirmar toma',
            style: TextStyle(
                fontSize: ResponsiveLayout.getFontSize(context, 20)
            ),
        ),
          content: Text(
            '¿Confirmas que has tomado ${toma.name}?',
            style: TextStyle(
                fontSize: ResponsiveLayout.getFontSize(context, 16)
            ),
          ),
          contentPadding: EdgeInsets.all(ResponsiveLayout.getSpacing(context, 16.0)),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(
                    fontSize: ResponsiveLayout.getFontSize(context, 14)
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Confirmar',
                style: TextStyle(
                    fontSize: ResponsiveLayout.getFontSize(context, 14)
                ),
              ),
              onPressed: () async {
                try {
                  await controlador.confirmarToma(toma);
                  Navigator.of(context).pop();
                } catch (e) {
                  // Show error dialog if confirmation fails
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString(),
                        style: TextStyle(
                            fontSize: ResponsiveLayout.getFontSize(context, 14)
                        ),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

// Alarmas Screen (Separado en una clase)
class AlarmasScreen extends StatelessWidget {
  const AlarmasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
          'Proximamente...',
          style: TextStyle(
            fontSize: ResponsiveLayout.getFontSize(context, 16)
          ),
        )
    );
  }
}

// ROUTE SCREENS
class ItemMedicamentoView extends StatelessWidget {
  static const ruta = '/medicamentos';

  const ItemMedicamentoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              'Medicación',
            style: TextStyle(
                fontSize: ResponsiveLayout.getFontSize(context, 20)
            ),
          ),
      ),
    );
  }
}

void showError(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Confirmar toma',
          style: TextStyle(
              fontSize: ResponsiveLayout.getFontSize(context, 20)
          ),
        ),
        content: Text(
          '¿Confirmas que has tomado?',
          style: TextStyle(
              fontSize: ResponsiveLayout.getFontSize(context, 16  )
          ),
        ),
        contentPadding: EdgeInsets.all(ResponsiveLayout.getSpacing(context, 16.0)),
        actions: <Widget>[
          TextButton(
            child: Text(
                'Cerrar',
              style: TextStyle(
                  fontSize: ResponsiveLayout.getFontSize(context, 14)
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class HistorialTomasScreen extends StatefulWidget {
  const HistorialTomasScreen({super.key});
  
  @override
  _HistorialTomasState createState() => _HistorialTomasState();
}

class _HistorialTomasState extends State<HistorialTomasScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask((){
    // Cargar la lista de medicamentos al entrar
      context.read<Proveedor>().listadoMedicaciones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Historial de Tomas',
          style: TextStyle(
              fontSize: ResponsiveLayout.getFontSize(context, 20)
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 41, 182, 145),
      ),
      body: ListView.builder(
        itemCount: context.watch<Proveedor>().actuallistaDetailed.length,
        itemBuilder: (context, index) {
          final medicacion = context.watch<Proveedor>().actuallistaDetailed[index];
          return ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveLayout.getSpacing(context, 16.0),
              vertical: ResponsiveLayout.getSpacing(context, 8.0),
            ),
            title: Text(
              medicacion.name,
              style: TextStyle(
                  fontSize: ResponsiveLayout.getFontSize(context, 16)
              ),
            ),
            subtitle: Text(
              'Dosis: ${medicacion.dosage}mg - Fecha de inicio: ${medicacion.startdate}',
              style: TextStyle(
                  fontSize: ResponsiveLayout.getFontSize(context, 14)
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalleTomaScreen(medicacion: medicacion),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// DetalleTomaScreen.dart
class DetalleTomaScreen extends StatefulWidget {
  final IntakesDetailed medicacion;

  const DetalleTomaScreen({super.key, required this.medicacion});

  @override
  State<DetalleTomaScreen> createState() => _DetalleTomaScreenState();
}

class _DetalleTomaScreenState extends State<DetalleTomaScreen> {
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = ResponsiveLayout.isSmallScreen(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.medicacion.name} - Detalles',
          style: TextStyle(
              fontSize: ResponsiveLayout.getFontSize(context, 20)
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 41, 182, 145),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveLayout.getSpacing(context, 16.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '- Dosis: ${widget.medicacion.dosage}mg - Duración: ${widget.medicacion.duration} día/s',
                style: TextStyle(
                    fontSize: ResponsiveLayout.getFontSize(context, 18)
                ),
              ),
              SizedBox(height: ResponsiveLayout.getSpacing(context, 16)),
              Text(
                '- Fecha de inicio: ${widget.medicacion.startdate}',
                style: TextStyle(
                    fontSize: ResponsiveLayout.getFontSize(context, 16)
                ),
              ),
              SizedBox(height: ResponsiveLayout.getSpacing(context, 24)),
              Text(
                'Horario de las tomas:',
                style: TextStyle(
                    fontSize: ResponsiveLayout.getFontSize(context, 20),
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: ResponsiveLayout.getSpacing(context, 8)),
              SizedBox(
                height: !isSmallScreen ? 40 : 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.medicacion.posologias.length,
                  itemBuilder: (context, index) {
                    final posologia = widget.medicacion.posologias[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveLayout.getSpacing(context, 8.0)
                      ),
                      child: Chip(
                        label: Text(
                          '${posologia.hour}:${posologia.min.toString().padLeft(2, '0')}',
                          style: TextStyle(
                              fontSize: ResponsiveLayout.getFontSize(context, 14)
                          ),
                        ),
                        backgroundColor: const Color.fromARGB(255, 248, 248, 248),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: ResponsiveLayout.getSpacing(context, 24)),
              Text(
                'Historial de Tomas:',
                style: TextStyle(
                    fontSize: ResponsiveLayout.getFontSize(context, 20),
                    fontWeight: FontWeight.bold
                ),
              ),
              Consumer<Proveedor>(
                builder: (context, proveedor, child) {
                  final historial = (widget.medicacion.intakes);
                  if (historial.isEmpty) {
                    return Center(
                      child: Text(
                        'No hay historial disponible.',
                        style: TextStyle(
                            fontSize: ResponsiveLayout.getFontSize(context, 16)
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: historial.length,
                    itemBuilder: (context, index) {
                      final toma = historial[index];
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: ResponsiveLayout.getSpacing(context, 16.0),
                          vertical: ResponsiveLayout.getSpacing(context, 8.0),
                        ),
                        title: Text(
                          context.read<Proveedor>().fechaFormateadaDeToma(toma.date),
                          style: TextStyle(
                              fontSize: ResponsiveLayout.getFontSize(context, 16)
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class RecordatorioTomasView extends StatelessWidget {
  static const String ruta = '/tomas';

  const RecordatorioTomasView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Tomas',
            style: TextStyle(
                fontSize: ResponsiveLayout.getFontSize(context, 20)
            ),
          )
      ),
      body: Center(
          child: Text(
            'Vista de Tomas',
            style: TextStyle(
                fontSize: ResponsiveLayout.getFontSize(context, 16)
            ),
          )
      ),
    );
  }
}

class alarmas_View extends StatelessWidget {
  static const ruta = '/alarmas';

  const alarmas_View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Proximamente se agregara notificaciones. :)',
            style: TextStyle(
                fontSize: ResponsiveLayout.getFontSize(context, 20)
            ),
          )
      ),
      body: Center(
          child: Text(
            'Vista de Alarmas',
            style: TextStyle(
                fontSize: ResponsiveLayout.getFontSize(context, 16)
            ),
          )
      ),
    );
  }
}