import gettext
import locale
from pathlib import Path

def setup_translations():
    local_language = locale.getdefaultlocale()[0]
    localedir = Path(__file__).parent / "locale"
    try:
        translations = gettext.translation('messages', localedir=localedir, languages=[local_language])
        translations.install()
        return translations.gettext
    except FileNotFoundError:
        return gettext.gettext

_ = setup_translations()

general_error_text = {
    1: _("Error:"),
    2: _("Error de conexión:"),
    3: _("No se pudo conectar con el servidor. Verifique su conexión.")
}

controlador_text = {
    1: _("Su codigo no se encuentra en la base de datos."),
    2: _("No se puede añadir una medicación. Datos invalidos"),
    3: _("No se pudo modificar una medicación. Datos invalidos"),
    4: _("No se puede añadir una nueva Posología. Datos invalidos"),
    5: _("No se pudo modificar una Posología. Datos invalidos"),
    6: _("No se pudo eliminar una Posología."),
    7: _("Paciente no Encontrado"),
    8: _("No se pudo eliminar una medicación.")
}

vista_text = {
    1: _("Cargando..."),
    2: _("Cargando, por favor espere..."),
    3: _("Cambiar tema"),
    4: _("Información"),
    5: _("Ingrese el codigo del paciente"),
    6: _("Buscar Paciente"),
    7: _("Lista de Pacientes Registrados:"),
    8: _("Atras"),
    9: _("Codigo:"),
    10: _("Nombre:"),
    11: _("Agregar"),
    12: _("Añadir"),
    13: _("Dosis: %(dosage)s mg, Duración: %(treat_duration)s dias"),
    14: _("Fecha de inicio del tratamiento: %(Start_date)s"),
    15: _("Posología %(index)d: %(hour)02d:%(minute)02d"),
    16: _("No hay información disponible"),
    17: _("Cancelar"),
    18: _("Guardar"),
    19: _("Hora (00-23):"),
    20: _("Min (00-59):"),
    21: _("Nombre del medicamento"),
    22: _("Dosis mg"),
    23: _("Fecha de inicio"),
    24: _("Duracion del tratamiento"),
    25: _("Duracion del tratamiento (días)"),
    26: _("Modificar la Posología"),
    27: _("No hay información de posología disponible"),
    28: _("Datos del Paciente"),
    29: _("Apellido"),
    30: _("Posología"),
    31: _("Modificar la medicación"),
    32: _("Medicación")
}