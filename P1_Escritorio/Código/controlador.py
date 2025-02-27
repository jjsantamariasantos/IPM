from types import NoneType

import vista
import model
import exceptions
import tkinter as tk
from tkinter import messagebox
import time
import threading
from gi.repository import GLib
from text import general_error_text, controlador_text

class Controller:
    def __init__(self, modelo, view):
        self.model_ = modelo #recibido como parametro
        self.vista_ = view #recibido como parametro

        self.pacienteActual = None
        self.medicacionActual = None
        self.medicationidActual = None
        self.posologiaActual = None

    def get_all_patients(self):
        self.vista_.mostrar_ventana_cargando()
        thread = threading.Thread(target=self.get_all_patientsBlocking)
        thread.start()

    def get_all_patientsBlocking(self):
        start_time = time.time()
        patients1 = None
        try:
            patients = self.model_.getPatientAll()
            patients1 = patients
        except exceptions.NotInternetException:
            elapsed_time = time.time() - start_time
            if elapsed_time < 1:
                time.sleep(1 - elapsed_time)
            GLib.idle_add(self.vista_.cerrar_ventana_cargando)
            GLib.idle_add(self.show_connection_error)
        finally:
            elapsed_time = time.time() - start_time
            if elapsed_time < 1:
                time.sleep(1 - elapsed_time)
            GLib.idle_add(self.vista_.cerrar_ventana_cargando)
            if patients1 is not NoneType:
                GLib.idle_add(self.update_patients_ui, patients1)

    def update_patients_ui(self, patients):
        self.vista_.pantalla_inicio.all_patients = patients
        self.vista_.pantalla_inicio.update_patient_list()

    def search_patient(self, code_Patient):
        self.vista_.mostrar_ventana_cargando()
        thread = threading.Thread(target=self.search_patientBlocking, args=(code_Patient,))
        thread.start()

    def search_patientBlocking(self, patient_code):
        start_time = time.time()
        patient_data1 = None
        try:
            if patient_code != "":
                patient_data = self.model_.getPatient(patient_code)
                patient_data1 = patient_data
        except exceptions.NotInternetException:
            elapsed_time = time.time() - start_time
            if elapsed_time < 1:
                time.sleep(1 - elapsed_time)
            GLib.idle_add(self.vista_.cerrar_ventana_cargando)
            GLib.idle_add(self.show_connection_error)
        finally:
            elapsed_time = time.time() - start_time
            if elapsed_time < 1:
                time.sleep(1 - elapsed_time)
            GLib.idle_add(self.clear_medication_list)
            GLib.idle_add(self.vista_.cerrar_ventana_cargando)
            if patient_data1:
                self.pacienteActual = patient_data1
                GLib.idle_add(self.vista_.switch_to_pantalla_paciente, self.pacienteActual)
            else:
                if not exceptions.NotInternetException:
                    GLib.idle_add(self.show_patient_not_found_error)


    def get_medication(self):
        self.vista_.mostrar_ventana_cargando()
        thread = threading.Thread(target=self.get_medicationBlocking)
        thread.start()

    def get_medicationBlocking(self):
        start_time = time.time()
        if self.pacienteActual:
            try:
                self.medicacionActual = self.model_.getMedicationAll(self.pacienteActual['id'])
            except exceptions.NotInternetException:
                elapsed_time = time.time() - start_time
                if elapsed_time < 1:
                    time.sleep(1 - elapsed_time)
                GLib.idle_add(self.vista_.cerrar_ventana_cargando)
                GLib.idle_add(self.show_connection_error)
            finally:
                elapsed_time = time.time() - start_time
                if elapsed_time < 1:
                    time.sleep(1 - elapsed_time)
                GLib.idle_add(self.vista_.cerrar_ventana_cargando)
                GLib.idle_add(self.update_medication_ui)

    def add_medication(self, medication_data):
        thread = threading.Thread(target=self.add_medicationBlocking, args=(medication_data,))
        thread.start()

    def add_medicationBlocking(self, medication_data):
        try:
            success = self.model_.postMedication(
            # el resultado de la operacion (exito o fracaso) se guarda en success
            self.pacienteActual['id'],
            medication_data['name'],
            medication_data['dosage'],
            medication_data['start_date'],
            medication_data['duration']
            )
            if success:  # si se añadio con éxito
                GLib.idle_add(self.get_medication)  # actualizamos la lista
            else:
                GLib.idle_add(self.show_add_medication_error)
        except exceptions.NotInternetException:
            GLib.idle_add(self.show_connection_error)

    def modify_medication(self, medication_id, medication_data):
            thread = threading.Thread(target=self.modify_medicationBlocking, args=(medication_id, medication_data))
            thread.start()

    def modify_medicationBlocking(self, medication_id, medication_data):
        try:
            success = self.model_.pacthMedication(
            self.pacienteActual['id'],
            medication_id,
            medication_data['name'],
            medication_data['dosage'],
            medication_data['start_date'],
            medication_data['treatment_duration'],
            )
            if success:
                GLib.idle_add(self.get_medication)
            else:
                GLib.idle_add(self.show_modify_medication_error)
        except exceptions.NotInternetException:
            GLib.idle_add(self.show_connection_error)

    def delete_medication(self, medication_id):
        thread = threading.Thread(target=self.delete_medicationBlocking, args=(medication_id,))
        thread.start()

    def delete_medicationBlocking(self, medication_id):
        try:
            success = self.model_.deleteMedication(medication_id, self.pacienteActual['id'])
            if success:
                GLib.idle_add(self.get_medication)
            else:
                GLib.idle_add(self.show_delete_medication_error)
        except exceptions.NotInternetException:
            self.show_connection_error()
    #POSOLOGÍA

    def get_posology(self, medication_id):
        thread = threading.Thread(target=self.get_posologyBlocking, args=(medication_id,))
        thread.start()

    def get_posologyBlocking(self, medication_id):
        try:
           self.posologiaActual = self.model_.getPosologia(self.pacienteActual['id'], medication_id)
        except exceptions.NotInternetException:
            GLib.idle_add(self.show_connection_error)
        finally:
            GLib.idle_add(self.update_posology_ui)

    def add_posology(self, posology_data):
        thread = threading.Thread(target=self.add_posologyBlocking, args=(posology_data,))
        thread.start()

    def add_posologyBlocking(self, posology_data):
        try:
            success = self.model_.postPosologia(
                self.pacienteActual['id'],
                self.medicationidActual,
                int(posology_data['hour']),
                int(posology_data['minute'])
            )
            if success:
                GLib.idle_add(self.get_posology, self.medicationidActual)
            else:
                GLib.idle_add(self.show_add_posology_error)
        except exceptions.NotInternetException:
            GLib.idle_add(self.show_connection_error)

    def modify_posology(self, posology_id, posology_data):
        thread = threading.Thread(target=self.modify_posologyBlocking, args=(posology_id, posology_data,))
        thread.start()

    def modify_posologyBlocking(self, posology_id, posology_data):
        try:
            success = self.model_.pacthPosologia(
                self.pacienteActual['id'],
                self.medicationidActual,
                posology_id,
                int(posology_data['hour']),
                int(posology_data['minute'])
            )
            if success:

                GLib.idle_add(self.get_posologyBlocking, self.medicationidActual)
            else:
                GLib.idle_add(self.show_modify_posology_error)
        except exceptions.NotInternetException:
            GLib.idle_add(self.show_connection_error)

    def delete_posology(self, id_posologies):
        thread = threading.Thread(target=self.delete_posologyBlocking, args=(id_posologies,))
        thread.start()

    def delete_posologyBlocking(self, id_posologies):
        try:
            if self.medicationidActual is None:
                GLib.idle_add(self.vista_.show_error, "Error", "No se ha seleccionado un medicamento")
                return
            success = self.model_.deletePosologia(self.medicationidActual, self.pacienteActual['id'], id_posologies)
            if success:
                GLib.idle_add(self.get_posologyBlocking, self.medicationidActual)
            else:
                GLib.idle_add(self.show_delete_posology_error)
        except exceptions.NotInternetException:
            GLib.idle_add(self.show_connection_error)

    def clear_medication_list(self):
        self.vista_.pantalla_paciente.display_medications([])

    def update_medication_ui(self):
        self.vista_.display_medications(self.medicacionActual)

    def show_add_medication_error(self):
        self.vista_.show_error(general_error_text[1], controlador_text[2])

    def show_modify_medication_error(self):
        self.vista_.show_error(general_error_text[1], controlador_text[3])

    def show_delete_medication_error(self):
        self.vista_.show_error(general_error_text[1], controlador_text[8])

    def show_connection_error(self):
        self.vista_.show_error(general_error_text[2], general_error_text[3])

    def show_patient_not_found_error(self):
        self.vista_.show_error(controlador_text[7], controlador_text[1])

    def update_posology_ui(self):
        self.vista_.display_posology(self.posologiaActual)

    def show_add_posology_error(self):
        self.vista_.show_error(general_error_text[1], controlador_text[4])

    def show_modify_posology_error(self):
        self.vista_.show_error(general_error_text[1], controlador_text[5])

    def show_delete_posology_error(self):
        self.vista_.show_error(general_error_text[1], controlador_text[6])