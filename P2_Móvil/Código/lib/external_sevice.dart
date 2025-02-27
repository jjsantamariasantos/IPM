import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:pillbellv2/fake_data.dart';
import 'exceptions.dart';
import 'objects.dart';

abstract class MedicationApi {
  final DateTime initialDate = DateTime.now();
  final DateTime initialDate2 = DateTime.now();
  Future<Paciente> getPaciente(String code);
  Future<Paciente> getPacienteid(int id);
  Future<List<Medicacion>> getMedicacionList(int pacienteid);
  Future<Medicacion> getMedicacion(int pacienteid, int medicationid);
  Future<List<Posologia>> getPosologia(int pacienteid, int medicationid);
  Future<List<Intakes>> getIntakes(int pacienteid, int medicationid);
  Future<List<IntakesDetailed>> getIntakesDetailed(int pacienteid);
  Future<void> postIntakes(DateTime date, int? pacienteid, int medicationid);
}


class MedicationApiServer implements MedicationApi{
  
  final String urlcont = "192.168.1.136:8000";
  //final String urlcont = "127.0.0.1:8000";
  @override
  final DateTime initialDate = DateTime.now();
  @override
  final DateTime initialDate2 = DateTime.now();


  @override
  getPaciente (String code) async {

    final url = Uri.parse('http://$urlcont/patients?code=$code');

      try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return Paciente.fromJson(data);
      } else {
        throw Exception(response.body);
      }
    } on http.ClientException {
      throw http.ClientException("Service is not available. Try again later.");
    }


  }

  @override
  getPacienteid (int id) async {

    final url = Uri.parse('http://$urlcont/patients/$id');

      try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return Paciente.fromJson(data);
      } else {
        throw Exception(response.body);
      }
    } on http.ClientException {
      throw http.ClientException("Service is not available. Try again later.");
    }


  }

  @override
  getMedicacionList (int pacienteid) async {


    final url = Uri.parse('http://$urlcont/patients/$pacienteid/medications');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Medicacion.fromJson(item)).toList();
      } else {
        throw Exception(response.body);
      }
    } on http.ClientException {
      throw http.ClientException("Service is not available. Try again later.");
    }

  }

  @override
  getMedicacion (int pacienteid, int medicationid) async {

    final url = Uri.parse('http://$urlcont/patients/$pacienteid/medications/$medicationid');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return Medicacion.fromJson(data);
      } else {
        throw Exception(response.body);
      }
    } on http.ClientException {
      throw http.ClientException("Service is not available. Try again later.");
    }

  }
  
  @override
  getPosologia (int pacienteid, int medicationid) async {

    final url = Uri.parse('http://$urlcont/patients/$pacienteid/medications/$medicationid/posologies');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Posologia.fromJson(item)).toList();
      } else {
        throw Exception(response.body);
      }
    } on http.ClientException {
      throw http.ClientException("Service is not available. Try again later.");
    }

  }

  @override
  getIntakes (int pacienteid, int medicationid) async {

    final url = Uri.parse('http://$urlcont/patients/$pacienteid/medications/$medicationid/intakes');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Intakes.fromJson(item)).toList();
      } else {
        throw Exception(response.body);
      }
    } on http.ClientException {
      throw http.ClientException("Service is not available. Try again later.");
    }

  }

  @override
  getIntakesDetailed (int pacienteid) async {

    final url = Uri.parse('http://$urlcont/patients/$pacienteid/intakes');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => IntakesDetailed.fromJson(item)).toList();
      } else {
        throw Exception(response.body);
      }
    } on http.ClientException {
      throw http.ClientException("Service is not available. Try again later.");
    }

  }

  @override
  postIntakes (DateTime date, int? pacienteid, int medicationid) async{

    final url = Uri.parse('http://$urlcont/patients/$pacienteid/medications/$medicationid/intakes');
    String stringdate = DateFormat("yyyy-MM-dd'T'HH:mm").format(date);

    final intakejson = {
      "id": null,
      "date": stringdate,
      "medication_id": medicationid,
    };

    try{    
      var response = await http.post(url, headers: {"Content-Type": "application/json"},body: json.encode(intakejson));
      if (!(response.statusCode == 201)){
        throw ModelException("No se pudo agregar la nueva ingestacion");
      }
    } on http.ClientException {
      throw http.ClientException("Service is not available. Try again later.");
    }


  }

}


class MedicationApiMock implements MedicationApi{

  @override
  final DateTime initialDate = DateTime(2024, 12, 1, 6, 00);
  @override
  final DateTime initialDate2 = DateTime(2024, 12, 1, 6, 00);

  @override
  getPaciente (String code) async {

    var pacienteData = listpaciente.firstWhereOrNull((item) => item["code"] == code);
    if (pacienteData != null){
      var paciente = Paciente.fromJson(pacienteData);
      return paciente;
    }else{
      throw Exception("No hay paciente.");
    }

  }

  @override
  getPacienteid (int id) async {

    var pacienteData = listpaciente.firstWhereOrNull((item) => item["id"] == id);
    if (pacienteData != null){
      return Paciente.fromJson(pacienteData);
    }else{
      throw Exception("No hay paciente.");
    }

  }

  @override
  getMedicacionList (int pacienteid) async {


    var listademedicamentosdelpaciente = listMedcinas.where((med) => med["patient_id"] == pacienteid).toList();

    if (listademedicamentosdelpaciente.isNotEmpty){

      return listademedicamentosdelpaciente.map((item) => Medicacion.fromJson(item)).toList();

    }else{
      throw Exception("No hay medicamentos.");
    }

  }

  @override
  getMedicacion (int pacienteid, int medicationid) async {

    var medicamento = listMedcinas.firstWhereOrNull((med) => med["patient_id"] == pacienteid && med["id"] == medicationid);
    if(medicamento != null){
      return Medicacion.fromJson(medicamento);
    }else{
      throw Exception("No hay medicamento.");
    }
  }
  
  @override
  getPosologia (int pacienteid, int medicationid) async {

    var listademedicamentosposologias = listPosologias.where((pos) => pos["medication_id"] == medicationid).toList();

    if (listademedicamentosposologias.isNotEmpty){

      return listademedicamentosposologias.map((item) => Posologia.fromJson(item)).toList();

    }else{
      throw Exception("No hay horarios para hacer tomas.");
    }

  }

  @override
  getIntakes (int pacienteid, int medicationid) async {

    var listademedicamentosintakes = listintakes.where((intake) => intake["medication_id"] == medicationid).toList();

    if (listademedicamentosintakes.isNotEmpty){

      return listademedicamentosintakes.map((item) => Intakes.fromJson(item)).toList();

    }else{
      throw Exception("No hay horarios para hacer tomas hechas.");
    }

  }

  @override
  getIntakesDetailed (int pacienteid) async {

    var listademedicamentosDetailed = listintakesDetail.where((intakes) => intakes["patient_id"] == pacienteid).toList();

    if (listademedicamentosDetailed.isNotEmpty){

      return listademedicamentosDetailed.map((item) => IntakesDetailed.fromJson(item)).toList();

    }else{
      throw Exception("No hay horarios para hacer tomas.");
    }

  }

  @override
  postIntakes(DateTime date, int? pacienteid, int medicationid) async {
    String stringdate = DateFormat("yyyy-MM-dd'T'HH:mm").format(date);

    var medication = listMedcinas.firstWhereOrNull((med) => med["id"] == medicationid);
    if (medication == null) {
      throw Exception('Medicamento no encontrado para el ID $medicationid');
    }

    var detailedEntry = listintakesDetail.firstWhereOrNull(
      (detail) => detail["patient_id"] == pacienteid && detail["name"] == medication["name"],
    );

    var newId = listintakes.isNotEmpty ? (listintakes.last["id"] as int) + 1 : 1;

    Map<String, Object> newIntake = {
      "id": newId,
      "date": stringdate,
      "medication_id": medicationid,
    };

    listintakes.add(newIntake);

    if (detailedEntry != null) {
      (detailedEntry["intakes_by_medication"] as List).add(newIntake);
    }

  }

}