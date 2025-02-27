import requests
import exceptions

class Model:
    def getPatient (self, code_Patient):
        url = f"http://127.0.0.1:8000/patients?code={code_Patient}"
        try:
            server_response = requests.get(url)
            if server_response.status_code == 200:
                patient_data = server_response.json()
                return patient_data
            else:
                return None
        except requests.exceptions.RequestException as e:
            print(f"Error de red: {str(e)}")
            raise exceptions.NotInternetException

    def getPatientAll(self):
        url = f"http://127.0.0.1:8000/patients"
        try:
            server_response = requests.get(url)
            if server_response.status_code == 200:
                patient_data = server_response.json()
                return patient_data
            else:
                return None
        except requests.exceptions.RequestException as e:
            print(f"Error de red: {str(e)}")
            raise exceptions.NotInternetException
                
    def getMedicationAll (self,id_Patient):
        
        url = f"http://127.0.0.1:8000/patients/{id_Patient}/medications"
        try:
            server_response = requests.get(url)
            if server_response.status_code == 200:
                allMedication_data = server_response.json()
                return allMedication_data
            else:
                return None
        except requests.exceptions.RequestException as e:
            print(f"Error de red: {str(e)}")
            raise exceptions.NotInternetException
    
    def getMedication (self,id_patient, id_Medication):
        url = f"http://127.0.0.1:8000/patients/{id_patient}/medications/{id_Medication}"
        try:
            server_response = requests.get(url)
            if server_response.status_code == 200:
                medication_data = server_response.json()
                return medication_data
            else:
                return None
        except requests.exceptions.RequestException as e:
            print(f"Error de red: {str(e)}")
            raise exceptions.NotInternetException
        
    def getPosologia (self,id_patient, id_Medication):
        url = f"http://127.0.0.1:8000/patients/{id_patient}/medications/{id_Medication}/posologies"
        
        server_response = requests.get(url)
        try:
            if server_response.status_code == 200:
                posologia_data = server_response.json()
                return posologia_data
            else:
                return None
        except requests.exceptions.RequestException as e:
            print(f"Error de red: {str(e)}")
            raise exceptions.NotInternetException
        
    def postMedication(self, id_patient, nameMed, dosage, start_date, duration):
        url = f"http://127.0.0.1:8000/patients/{id_patient}/medications"
        data= {
            "id": None,
            "name": nameMed,
            "dosage": dosage,
            "start_date": start_date,
            "treatment_duration": duration,
            "patient_id": id_patient,
        }
        post_reponse = requests.post(url, json=data)
        try:
            if  post_reponse.status_code == 201:
                return 1
            else:
                return 0    
        except requests.exceptions.RequestException as e:
            print(f"Error de red: {str(e)}")
            raise exceptions.NotInternetException
    
    def postPosologia(self,id_patient, id_Medication, hour, min):
        url = f"http://127.0.0.1:8000/patients/{id_patient}/medications/{id_Medication}/posologies"
        data = {
            "id": None,
            "hour": hour,
            "minute": min,
            "medication_id": id_Medication,
        }
        post_reponse = requests.post(url, json=data)
        try:
            if  post_reponse.status_code == 201:
                return 1
            else:
                return 0    
        except requests.exceptions.RequestException as e:
            print(f"Error de red: {str(e)}")
            raise exceptions.NotInternetException
    
    def pacthMedication(self, id_patient, id_Medication, nameMed, dosage, start_date, duration):
        url=f"http://127.0.0.1:8000/patients/{id_patient}/medications/{id_Medication}"
        medication= {
            "id": None,
            "name": nameMed,
            "dosage": dosage,
            "start_date": start_date,
            "treatment_duration": duration,
            "patient_id": id_patient,
        }
        patch_reponse = requests.patch(url, json=medication)
        try:
            if  patch_reponse.status_code == 204:
                return 1
            else:
                return 0   
        except requests.exceptions.RequestException as e:
            print(f"Error de red: {str(e)}")
            raise exceptions.NotInternetException

    def pacthPosologia(self, id_patient, id_Medication, id_posologia,  hour, min):
        url=f"http://127.0.0.1:8000/patients/{id_patient}/medications/{id_Medication}/posologies/{id_posologia}"
        pososlogy= {
            "id": None,
            "hour": hour,
            "minute": min,
            "medication_id": id_Medication,
        }
        patch_reponse = requests.patch(url, json=pososlogy)
        try:
            if  patch_reponse.status_code == 204:
                return 1
            else:
                return 0
        except requests.exceptions.RequestException as e:
            print(f"Error de red: {str(e)}")
            raise exceptions.NotInternetException

    def deleteMedication(self, id_Medication, id_patient):
        url=f"http://127.0.0.1:8000/patients/{id_patient}/medications/{id_Medication}"
        r=requests.delete(url)
        try:
            if r.status_code==204:
                return 1
            else:
                return 0
        except requests.exceptions.RequestException as e:
            print(f"Error de red: {str(e)}")
            raise exceptions.NotInternetException

    def deletePosologia(self, id_medication, id_patient, id_posologies):
        url = f"http://127.0.0.1:8000/patients/{id_patient}/medications/{id_medication}/posologies/{id_posologies}"
        try:
            r = requests.delete(url)
            if r.status_code == 204:
                return True
            else:
                print(f"Error al eliminar posología: {r.status_code} - {r.text}")
                return False
        except requests.exceptions.RequestException as e:
            print(f"Error de red: {str(e)}")
            raise exceptions.NotInternetException
