import 'package:collection/collection.dart';

class Paciente {

  Paciente(this.id, this.code, this.name, this.surname);
  final int id;
  final String code;
  final String name;
  final String surname;

  Paciente.fromJson(Map json)
      : id = json["id"],
        name = json["name"],
        surname = json["surname"],
        code = json["code"];

  @override
  String toString() {
    return "$id | $code | $name $surname";
  }
}


class Medicacion{
  Medicacion(this.id, this.name, this.dosage, this.startdate, this.duration, this.paticienteid);
  final int id;
  final String name;
  final double dosage;
  final String startdate;
  final int duration;
  final int paticienteid;

  Medicacion.fromJson (Map json)
    : id = json["id"],
      name = json["name"],
      dosage = json["dosage"],
      startdate = json["start_date"],
      duration = json["treatment_duration"],
      paticienteid = json["patient_id"];
      
}

class Posologia {
   Posologia(
    this.id,
    this.hour,
    this.min,
    this.medicationid
  );

  final int id;
  final int hour;
  final int min;
  final int medicationid;
  bool mark = false;

  Posologia.fromJson (Map json)
    : id = json["id"],
      hour = json["hour"],
      min = json["minute"],
      medicationid = json["medication_id"];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Posologia &&
        other.id == id &&
        other.hour == hour &&
        other.min == min &&
        other.medicationid == medicationid;
  }

  @override
  int get hashCode => id.hashCode ^ hour.hashCode ^ min.hashCode ^ medicationid.hashCode;

}

class Intakes{
  
  final int? id;
  final String date;
  final int medicationid;

  Intakes(
    this.id,
    this.date,
    this.medicationid,
  );

  Intakes.fromJson(Map json)
    : id = json["id"],
      date = json['date'],
      medicationid = json['medication_id'];
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Intakes &&
        other.id == id &&
        other.date == date &&
        other.medicationid == medicationid;
  }

  @override
  int get hashCode => id.hashCode ^ date.hashCode ^ medicationid.hashCode;

}

class IntakesDetailed{

    final int? id;
    final String name;
    final double dosage;
    final String startdate;
    final int duration;
    final int pacienteid;
    final List<Posologia> posologias;
    final List<Intakes> intakes;

    IntakesDetailed(
      this.id,
      this.name,
      this.dosage,
      this.startdate,
      this.duration,
      this.pacienteid,
      this.posologias,
      this.intakes,
    );

    IntakesDetailed.fromJson (Map json)
      : id = json["id"],
      name = json["name"],
      dosage = json["dosage"],
      startdate = json["start_date"],
      duration = json["treatment_duration"],
      pacienteid = json["patient_id"],
      posologias = (json['posologies_by_medication'] as List).map((item) => Posologia.fromJson(item)).toList(),
      intakes = (json['intakes_by_medication'] as List).map((item) => Intakes.fromJson(item)).toList();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IntakesDetailed &&
        other.id == id &&
        other.name == name &&
        other.dosage == dosage &&
        other.startdate == startdate &&
        other.duration == duration &&
        other.pacienteid == pacienteid &&
        const ListEquality().equals(other.posologias, posologias) &&
        const ListEquality().equals(other.intakes, intakes);
  }

  @override
  int get hashCode => id.hashCode ^
      name.hashCode ^
      dosage.hashCode ^
      startdate.hashCode ^
      duration.hashCode ^
      pacienteid.hashCode ^
      const ListEquality().hash(posologias) ^
      const ListEquality().hash(intakes);
}

class InfoMed {
  final int idmedicina;
  final Posologia posologia;
  final String name;
  bool mark = false;

  InfoMed(this.idmedicina, this.posologia, this.name);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InfoMed &&
        other.idmedicina == idmedicina &&
        other.posologia == posologia &&
        other.name == name;
  }

  @override
  int get hashCode => idmedicina.hashCode ^ posologia.hashCode ^ name.hashCode;
}
