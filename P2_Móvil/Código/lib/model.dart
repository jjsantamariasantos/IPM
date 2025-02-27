import 'package:flutter/material.dart';
import 'exceptions.dart';
  
import 'external_sevice.dart';
import 'objects.dart';


class AjustesControlador extends ChangeNotifier {
  ThemeMode _temaActual = ThemeMode.system;

  ThemeMode get temaActual => _temaActual;

  void actualizaTema(ThemeMode? nuevoTema) {
    if (nuevoTema != null) {
      _temaActual = nuevoTema;
      notifyListeners();
    }
  }
}


class Proveedor extends ChangeNotifier{
  
  Proveedor({MedicationApi? externalService}) {
    service = externalService ?? MedicationApiServer();
    fechaActual = service.initialDate;
    fechaAhora = service.initialDate2;
    notifyListeners();
  }

  //Datos globales
  late MedicationApi service;
  int? _pacienteIdGlobal;
  late DateTime fechaActual;
  late DateTime fechaAhora;
  bool loading = false;
  IntakesDetailed? actualDetailed;
  List<IntakesDetailed> actuallistaDetailed = [];
  List<IntakesDetailed> listaMedicinasActuales = [];
  List<InfoMed> posologiasActuales = [];
  int? get pacienteIdGlobal => _pacienteIdGlobal;
  Paciente? _pacienteActual;
  Paciente? get pacienteActual => _pacienteActual;
  IntakesDetailed? _medicacionSeleccionada;
  IntakesDetailed? get medicacionSeleccionada => _medicacionSeleccionada;

  
  //Sets
  void seleccionarMedicacion(IntakesDetailed medicacion) {
    _medicacionSeleccionada = medicacion;
    notifyListeners();
  }

  void markMed (InfoMed medicacion) {
    medicacion.mark = !medicacion.mark;
    notifyListeners();
  }

  void setPaciente(Paciente paciente) {
     _pacienteActual = paciente;
    notifyListeners();  // Notifica a los listeners que el paciente ha cambiado
  }
  void fechaActualizar (DateTime date) {
     fechaActual = date;
    notifyListeners();
  }
  setPacienteid(int id) {
    _pacienteIdGlobal = id;
    notifyListeners();
  }

//Funciones
  verificarCode (String code){

    final RegExp regex = RegExp(r'^\d{3}-\d{2}-\d{4}$');
    if (!regex.hasMatch(code)){ 
      InvalidInputException("El codigo que se ha insertado no cumple con el formato pedido");
    }

  }

  
 Future<bool> buscarPaciente(String code) async {
    if (code.isEmpty) return false;

    try {
      verificarCode(code);
      Paciente? paciente = await service.getPaciente(code);

      setPaciente(paciente);
      setPacienteid(paciente.id);
      return true;
        } catch (e) {
      print("Error al buscar paciente: $e");
    }

    return false;
  }

  bool isLessThanOneHour(TimeOfDay posoligia, TimeOfDay actual) {

    Duration start = Duration(hours: posoligia.hour, minutes: posoligia.minute);
    Duration end = Duration(hours: actual.hour, minutes: actual.minute);
    Duration diff = end - start;
    return diff.inMinutes.abs() < 60;

  }

  void updateMarkStatus(DateTime date) {
    if (loading) return;
    try{
      loading=true;
      notifyListeners();
      for (InfoMed med in posologiasActuales) {
        for(Intakes intakes in actualDetailed?.intakes ?? []){
          final intakeTime = DateTime.parse(intakes.date);
          if(date.year == intakeTime.year && date.month == intakeTime.month && date.day == intakeTime.day){
            med.mark = isLessThanOneHour(TimeOfDay(hour: med.posologia.hour, minute: med.posologia.min), TimeOfDay(hour: intakeTime.hour, minute: intakeTime.minute));
          }
        }
      }
    }finally{
      loading = false;
      notifyListeners();
    }
  }
    

   Future<void> confirmarToma(InfoMed toma) async {
    TimeOfDay timeposologia = TimeOfDay(hour: toma.posologia.hour, minute: toma.posologia.min);
    DateTime datenow = service.initialDate;
    TimeOfDay hournow = TimeOfDay(hour: datenow.hour, minute: datenow.minute);
    if(isLessThanOneHour(timeposologia, hournow)) {
      await service.postIntakes(datenow, pacienteIdGlobal, toma.idmedicina);
    
      toma.mark = true;
      notifyListeners();

      await cargarPosologiasActuales(fechaActual);
    } else {
      throw OutOfTimeException("Se ha pasado una hora para realizar la toma del medicamento");
    }
  }

   Future<void> actualMedicacionList(DateTime date) async {
    if (loading) return;

    try {
      loading = true;
      notifyListeners();

      listaMedicinasActuales.clear();
      List<IntakesDetailed> listamedicinas = await service.getIntakesDetailed(pacienteActual!.id);

      for (IntakesDetailed item in listamedicinas) {
        DateTime startdate = DateTime.parse(item.startdate);
        DateTime enddate = startdate.add(Duration(days: item.duration));
        if (!(date.isBefore(startdate)) && !(date.isAfter(enddate))) {
          if (!listaMedicinasActuales.any((med) => med.id == item.id)) {
            listaMedicinasActuales.add(item);
          }
        }
      }
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  bool checkIfTaken (InfoMed info, List<Intakes> intakes, DateTime date, Posologia posologia){
    return intakes.any((intake) {
      DateTime intakeDate = DateTime.parse(intake.date);
      return intakeDate.year == date.year &&
             intakeDate.month == date.month &&
             intakeDate.day == date.day &&
             isLessThanOneHour(TimeOfDay(hour: intakeDate.hour, minute: intakeDate.minute), TimeOfDay(hour: posologia.hour, minute: posologia.min));
    });
  }

  cargarPosologiasActuales(DateTime date) async {

    if (loading){return;}

    try{
      loading = true;
      notifyListeners();
      posologiasActuales.clear();
      listaMedicinasActuales.clear();
      List<Medicacion> listamedicinas = await service.getMedicacionList(pacienteActual!.id);
      for (Medicacion item in listamedicinas){
        DateTime startdate = DateTime.parse(item.startdate);
        DateTime enddate = startdate.add(Duration(days: item.duration));
        if (!(date.isBefore(startdate)) && !(date.isAfter(enddate))){
          List<Posologia> pos = await service.getPosologia(pacienteIdGlobal!, item.id);
          List<Intakes> intakes = await service.getIntakes(pacienteIdGlobal!, item.id);
          for (Posologia posologia in pos){
            InfoMed info = InfoMed(item.id, posologia, item.name);
            info.mark = checkIfTaken(info, intakes, date, posologia);
            posologiasActuales.add(info);
          }
        }
      }
    }finally{
      loading = false;
      notifyListeners();
    }

  }

  listadoMedicaciones() async {

    actuallistaDetailed.clear();    
    actuallistaDetailed = await service.getIntakesDetailed(pacienteActual!.id);
  
    notifyListeners();
  }

  void diaAnterior() {
    fechaActual = fechaActual.subtract(const Duration(days: 1));
    cargarPosologiasActuales(fechaActual);
    actualMedicacionList(fechaActual);
    updateMarkStatus(fechaActual);
    notifyListeners();
  }

  void diaSiguiente() {
    fechaActual = fechaActual.add(const Duration(days: 1));
    cargarPosologiasActuales(fechaActual);
    notifyListeners();
  }

  Future<void> _actualizarToma(int index, bool tomada) async {
    await cargarPosologiasActuales(fechaActual);
  }

  String obtenerFechaFormateada() {
    return "${fechaActual.year}-${fechaActual.month.toString().padLeft(2, '0')}-${fechaActual.day.toString().padLeft(2, '0')}";
  }

  String fechaFormateadaDeToma(String date) {
    DateTime dateTime = DateTime.parse(date);
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} - ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  DateTime _normalizarFecha(DateTime fecha) {
    return DateTime(fecha.year, fecha.month, fecha.day);
  }

  bool esTomaPasada(InfoMed toma) {
    final ahora = service.initialDate;
    final fechaToma = DateTime(fechaActual.year, fechaActual.month, fechaActual.day, toma.posologia.hour, toma.posologia.min).add(const Duration(hours: 1));
    return fechaToma.isBefore(ahora);
  }

  bool esTomaFutura (InfoMed toma){
    final ahora = service.initialDate;
    final fechaToma = DateTime(fechaActual.year, fechaActual.month, fechaActual.day, toma.posologia.hour, toma.posologia.min).subtract(const Duration(hours: 1));
    return fechaToma.isAfter(ahora);
  }


}