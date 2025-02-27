Diseño software dinámico
```mermaid

sequenceDiagram

    participant View as Vista (GUI)
    participant Controller as Controller
    participant Model as Model (API)
    
    User->>View: Ingresa el codigo del paciente
    View->>Controller: search_patient(patient_code)
    Controller->>Model: getPatient(patient_code)
    Model-->>Controller: patient_data
    alt patient found
        Controller->>View: switch_to_pantalla_paciente(patient_data)
        View->>Controller: get_medication()
        Controller->>Model: getMedicationAll(patient_id)
        Model-->>Controller: medication_data
        Controller->>View: display_medications(medication_data)
        View-->>User: Muestra información de paciente y sus medicaciones
    else patient not found
        Controller->>View: show_error("Paciente no encontrado")
        View-->>User: Muestra mensaje de error
    end
    
    User->>View: Pulsa el botón de modificar medicación
    View->>Controller: add_medication(medication_data)
    Controller->>Model: postMedication(id_patient, nameMed, dosage, start_date, duration)
    alt success
        Model-->>Controller: success
        Controller->>Controller: get_medication()
        Controller->>View: display_medications(updated_data)
        View-->>User: Muestra la nueva lista de medicamentos
    else failure
        Model-->>Controller: failure
        Controller->>View: show_error("No se pudo añadir la medicación")
        View-->>User: Muestra mensaje de error
    end

    User->>View: Pulsa el botón de modificar medicación
    View->>Controller: modify_medication(medication_id, medication_data)
    Controller->>Model: patchMedication(id_patient, id_Medication, nameMed, dosage, start_date, duration)
    alt success
        Model-->>Controller: success
        Controller->>Controller: get_medication()
        Controller->>View: display_medications(updated_data)
        View-->>User: Muestra la lista de medicaciones modificada
    else failure
        Model-->>Controller: failure
        Controller->>View: show_error("No se pudo modificar la medicación")
        View-->>User: Muestra mensaje de error
    end

    User->>View: Pulsa borrar medicación
    View->>Controller: delete_medication(medication_id)
    Controller->>Model: deleteMedication(id_Medication, id_patient)
    alt success
        Model-->>Controller: success
        Controller->>Controller: get_medication()
        Controller->>View: display_medications(updated_data)
        View-->>User: Muestra la lista de medicaciones modificada
    else failure
        Model-->>Controller: failure
        Controller->>View: show_error("no se pudo borrar la medicación")
        View-->>User: Muestra mensaje de error
    end

    User->>View: Pulsa ver Posologias
    View->>Controller: get_posology(medication_id)
    Controller->>Model: getPosologia(id_patient, id_Medication)
    Model-->>Controller: posology_data
    Controller->>View: display_posology(posology_data)
    View-->>User: Muestra la lista de posologias actual

    User->>View: Pulsa Agregar Posologia
    View->>Controller: add_posology(posology_data)
    Controller->>Model: postPosologia(id_patient, id_Medication, hour, min)
    alt success
        Model-->>Controller: success
        Controller->>Controller: get_posology(medication_id)
        Controller->>View: display_posology(updated_data)
        View-->>User: Muestra lista de posologias actualizada
    else failure
        Model-->>Controller: failure
        Controller->>View: show_error("No se pudo añadir la posologia")
        View-->>User: Muestra mensaje de error
    end

    User->>View: Pulsa modificar posologias
    View->>Controller: modify_posology(posology_id, posology_data)
    Controller->>Model: patchPosologia(patient_id, med_id, posology_id, new_data)
    alt success
        Model-->>Controller: success
        Controller->>Controller: get_posology(medication_id)
        Controller->>View: display_posology(updated_data)
        View-->>User: Muestra lista de posologias actualizada
    else failure
        Model-->>Controller: failure
        Controller->>View: show_error("No se pudo modificar la posologia")
        View-->>User: Muestra mensaje de error
    end

    User->>View: Pulsa borrar posologia
    View->>Controller: delete_posology(id_posologies)
    Controller->>Model: deletePosologia(id_medication, id_patient, id_posologies)
    alt success
        Model-->>Controller: success
        Controller->>Controller: get_posology(medication_id)
        Controller->>View: display_posology(updated_data)
        View-->>User: Muestra lista de posologias actualizada
    else failure
        Model-->>Controller: failure
        Controller->>View: show_error("No se pudo borrar la posologia")
        View-->>User: Muestra mensaje de error
    end
