Diseño software estático
```mermaid

classDiagram
    class MenuVentana {
        +MenuVentana(*args, **kwargs)
        +on_theme_button_clicked(button)
        +on_about_button_clicked(button)
        +change_view_theme(action, param)
    }

    class VentanaPrincipal {
        +VentanaPrincipal(*args, **kwargs)
        +set_controller(controller)
        +switch_to_pantalla_paciente(patient_code)
        +switch_to_pantalla_inicio()
        +display_medications(medications)
        +display_posology(posology_data)
        +show_error(title, message)
    }

    class BasePantalla {
        +BasePantalla(switch_callback, *args, **kwargs)
    }

    class PantallaInicio {
        +PantallaInicio(switch_callback, parent_window, *args, **kwargs)
        +set_controller(controller)
        +on_search_button_clicked(button)
        +show_error(title, message)
    }

    class PantallaPaciente {
        +PantallaPaciente(switch_callback, custom_field_names, *args, **kwargs)
        +set_controller(controller)
        +display_patient_data(patient_data)
        +display_medications(medications)
        +on_posology_clicked(button, medication_id)
        +display_posology(posology_data)
        +create_posology_dialog(posology_data)
        +update_posology_content(self, posology_data)
        +on_modify_posology_clicked(self, button, posology)
        +on_add_posology_clicked(button)
        +on_add_posology_response(dialog, response, hour_entry, minute_entry)
        +on_delete_posology_clicked(button, posology_id)
        +on_add_clicked(button)
        +on_add_dialog_response(dialog, response, entries)
        +on_modify_clicked(button, medication)
        +on_modify_dialog_response(dialog, response, medication_id, entries)
        +on_delete_clicked(button, medication_id)
        +on_delete_dialog_response(dialog, response, medication_id)
        +on_back_clicked(button)
    }
    class Controller {
        +Controller(model, vista)
        +search_patient(patient_code)
        +get_medication()
        +add_medication(medication_data)
        +modify_medication(medication_id, medication_data)
        +delete_medication(medication_id)
        +get_posology(medication_id)
        +add_posology(posology_data)
        +delete_posology(id_posologies)
    }

    class Model {
        +getPatient(code_Patient)
        +getMedicationAll(id_Patient)
        +getMedication(id_patient, id_Medication)
        +getPosologia(id_patient, id_Medication)
        +postMedication(id_patient, nameMed, dosage, start_date, duration)
        +postPosologia(id_patient, id_Medication, hour, min)
        +pacthMedication(id_patient, id_Medication, nameMed, dosage, start_date, duration)
        +deleteMedication(id_Medication, id_patient)
        +deletePosologia(id_medication, id_patient, id_posologies)
    }

    Controller --> Model
    Controller --> VentanaPrincipal
    Controller --> BasePantalla
    VentanaPrincipal --> Controller
    BasePantalla --> Controller 


    MenuVentana <|-- VentanaPrincipal
    BasePantalla <|-- PantallaInicio
    BasePantalla <|-- PantallaPaciente
