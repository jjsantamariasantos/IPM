import gi

gi.require_version('Gtk',  '4.0')
gi.require_version('Adw', '1')
from gi.repository import Gtk, Adw, Gio
from text import vista_text

Adw.init()

class MenuVentana(Gtk.ApplicationWindow):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.set_default_size(900, 600)
        self.set_resizable(True)
        style_manager = Adw.StyleManager.get_default()
        style_manager.set_color_scheme(Adw.ColorScheme.FORCE_LIGHT)
        action = Gio.SimpleAction.new(vista_text[3], None)
        action.connect("activate", self.change_view_theme)
        self.add_action(action)
        menu = Gio.Menu.new()
        menu.append(vista_text[3], "win.something")
        self.pop_over = Gtk.Popover()
        self.menu_button = Gtk.MenuButton()
        self.menu_button.set_popover(self.pop_over)
        self.menu_button.set_icon_name("open-menu-symbolic")
        self.header = Gtk.HeaderBar()
        self.set_titlebar(self.header)
        self.header.pack_start(self.menu_button)
        self.menu_box = Gtk.Box(
            orientation = Gtk.Orientation.VERTICAL,
            spacing = 6
            )
        self.menu_box.set_margin_top(5)
        self.menu_box.set_margin_bottom(5)
        self.menu_box.set_margin_start(5)
        self.menu_box.set_margin_end(5)
        self.icon1 = Gtk.Image(icon_name = "preferences-system-symbolic")
        self.icon2 = Gtk.Image(icon_name = "help-about-symbolic")
        self.label1 = Gtk.Label(label = vista_text[3])
        self.label2 = Gtk.Label(label = vista_text[4])
        self.theme_box = Gtk.Box(spacing = 6)
        self.about_box = Gtk.Box(spacing = 6)
        self.theme_box.append(self.icon1)
        self.about_box.append(self.icon2)
        self.theme_box.append(self.label1)
        self.about_box.append(self.label2)
        self.theme_button = Gtk.Button(child = self.theme_box)
        self.theme_button.connect('clicked', self.on_theme_button_clicked)
        self.about_button = Gtk.Button(child = self.about_box)
        self.about_button.connect('clicked', self.on_about_button_clicked)
        self.menu_box.append(self.theme_button)
        self.menu_box.append(self.about_button)
        self.pop_over.set_child(self.menu_box)

    def on_theme_button_clicked(self, button):
        action = self.lookup_action(vista_text[3])
        if action:
            action.activate(None)

    def on_about_button_clicked(self, button):
        self.pop_over.hide()
        about_dialog = Gtk.AboutDialog()
        about_dialog.set_transient_for(self)
        about_dialog.set_modal(True)
        about_dialog.set_program_name("Práctica 1 IPM")
        about_dialog.set_version("v 1.3")
        about_dialog.set_comments("Esta aplicación ha sido hecha con python y GTK4")
        about_dialog.set_authors(["Luis Enrique Rojas Olivero - luis.rojas", "Lara Boedo Calvete - lara.boedo",
                                  "Jesús José Santamaría Santos - j.j.ssantos"])
        about_dialog.set_logo_icon_name("hospital")
        about_dialog.set_visible(True)

    @staticmethod
    def change_view_theme(action, param):
        style_manager = Adw.StyleManager.get_default()
        current_scheme = style_manager.get_color_scheme()
        if current_scheme == Adw.ColorScheme.FORCE_DARK:
            style_manager.set_color_scheme(Adw.ColorScheme.FORCE_LIGHT)
        else:
            style_manager.set_color_scheme(Adw.ColorScheme.FORCE_DARK)

class BasePantalla(Gtk.Box):
    def __init__(self, switch_callback, *args, **kwargs):
        super().__init__(
            orientation = Gtk.Orientation.VERTICAL,
            spacing = 6,
            *args,
            **kwargs
        )
        self.switch_callback = switch_callback
        self.set_margin_top(20)
        self.set_margin_bottom(20)
        self.set_margin_start(20)
        self.set_margin_end(20)


class VentanaPrincipal(MenuVentana):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.controller = None
        self.loading_window = None
        self.set_title("MedApp")
        self.overlay = Gtk.Overlay()
        self.set_child(self.overlay)

        self.stack = Gtk.Stack()
        self.stack.set_transition_type(Gtk.StackTransitionType.NONE)
        self.overlay.set_child(self.stack)

        self.pantalla_inicio = PantallaInicio(self.switch_to_pantalla_paciente, self)
        custom_field_names = {
            "code": vista_text[9],
            "name": vista_text[10],
            "id": "Id",
            "surname": vista_text[29],
        }
        self.pantalla_paciente = PantallaPaciente(self.switch_to_pantalla_inicio, custom_field_names)
        self.stack.add_titled(self.pantalla_inicio, "screen1", vista_text[6])
        self.stack.add_titled(self.pantalla_paciente, "screen2", vista_text[28])
        self.stack.set_visible_child_name("screen1")

    def set_controller(self, controller):
        self.controller = controller
        self.pantalla_inicio.set_controller(controller)
        self.pantalla_paciente.set_controller(controller)

    def switch_to_pantalla_paciente(self, patient_data):
        self.pantalla_paciente.display_patient_data(patient_data)
        self.stack.set_visible_child_name("screen2")

    def switch_to_pantalla_inicio(self):
        self.stack.set_visible_child_name("screen1")

    def display_medications(self, medications):
        self.pantalla_paciente.display_medications(medications)

    def display_posology(self, posology_data):
        self.pantalla_paciente.display_posology(posology_data)

    def show_error(self, title, message):
        dialog = Gtk.MessageDialog(
            transient_for=self,
            modal=True,
            buttons=Gtk.ButtonsType.OK,
            text=message,
            message_type=Gtk.MessageType.ERROR,
        )
        dialog.set_title(title)
        dialog.set_decorated(False)
        dialog.connect("response", lambda dlg, response: dlg.destroy())
        dialog.present()

    def mostrar_ventana_cargando(self):
        if self.loading_window is None:
            self.loading_window = Gtk.Window()
            self.loading_window.set_modal(True)
            self.loading_window.set_transient_for(self)
            self.loading_window.set_decorated(False)
            self.loading_window.set_size_request(200, 100)

            overlay = Gtk.Overlay()
            self.loading_window.set_child(overlay)

            content_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
            content_box.set_halign(Gtk.Align.CENTER)
            content_box.set_valign(Gtk.Align.CENTER)

            spinner = Gtk.Spinner()
            spinner.set_size_request(32, 32)
            spinner.start()
            content_box.append(spinner)

            label = Gtk.Label(label=vista_text[2])
            label.add_css_class("loading-label")
            content_box.append(label)

            overlay.add_overlay(content_box)
            self.loading_window.present()

    def cerrar_ventana_cargando(self):
        if self.loading_window:
            self.loading_window.destroy()
            self.loading_window = None

    def show_confirmation_dialog(self, message, callback):
        dialog = Gtk.MessageDialog(
            transient_for=self,
            modal=True,
            message_type=Gtk.MessageType.QUESTION,
            buttons=Gtk.ButtonsType.YES_NO,
            text=message
        )
        dialog.connect("response", self.on_confirmation_dialog_response, callback)
        dialog.present()

    def on_confirmation_dialog_response(self, dialog, response, callback):
        dialog.destroy()
        if response == Gtk.ResponseType.YES:
            callback()

class PantallaInicio(BasePantalla):
    def __init__(self, switch_callback, parent_window, *args, **kwargs):
        super().__init__(switch_callback, *args, **kwargs)
        self.set_halign(Gtk.Align.CENTER)
        self.set_valign(Gtk.Align.CENTER)
        self.parent_window = parent_window
        self.switch_callback = switch_callback
        self.controller = None
        self.code_label = Gtk.Label(label = vista_text[5])
        self.code_label.set_halign(Gtk.Align.CENTER)
        self.code_label.set_valign(Gtk.Align.CENTER)
        self.append(self.code_label)
        self.entry = Gtk.Entry()
        self.append(self.entry)
        self.search_icon = Gtk.Image(icon_name = "system-search-symbolic")
        self.search_label = Gtk.Label(label = vista_text[6])
        self.search_box = Gtk.Box(spacing = 6)
        self.search_box.set_halign(Gtk.Align.CENTER)
        self.search_box.set_valign(Gtk.Align.START)
        self.search_box.append(self.search_icon)
        self.search_box.append(self.search_label)
        self.search_button = Gtk.Button(child = self.search_box)
        self.search_button.connect("clicked", self.on_search_button_clicked)
        self.append(self.search_button)

        refresh_button = Gtk.Button(icon_name="view-refresh-symbolic")
        refresh_button.connect("clicked",self.on_refresh_button_clicked)
        refresh_button.set_size_request(200,20)
        self.append(refresh_button)
        self.patients_label = Gtk.Label(label=vista_text[7])
        self.patients_label.set_halign(Gtk.Align.START)
        self.patients_label.set_margin_top(20)
        self.append(self.patients_label)
        self.scrolled_window = Gtk.ScrolledWindow()
        self.scrolled_window.set_min_content_width(600)
        self.scrolled_window.set_min_content_height(400)
        self.append(self.scrolled_window)
        self.patient_list = Gtk.ListBox()
        self.patient_list.set_selection_mode(Gtk.SelectionMode.NONE)
        self.scrolled_window.set_child(self.patient_list)

        # Store all patients
        self.all_patients = []

    def set_controller(self, controller):
        self.controller = controller
        self.load_patients()

    def load_patients(self):
        if self.controller:
            self.controller.get_all_patients()
    def on_refresh_button_clicked(self, button) :
        self.load_patients()

    def update_patient_list(self):
        while row := self.patient_list.get_first_child():
            self.patient_list.remove(row)
        if self.all_patients:
            for patient in self.all_patients[1:]:  # Excluye el primer elemento
                row = Adw.ActionRow()
                row.set_title(f"{patient['name']} {patient['surname']}")
                row.set_subtitle(vista_text[9]+f" {patient['code']}")

                view_button = Gtk.Button(icon_name = "view-reveal-symbolic")
                view_button.connect("clicked", self.on_view_patient_clicked, patient['code'])
                row.add_suffix(view_button)

                self.patient_list.append(row)
        self.patient_list.show()

    def on_search_button_clicked(self, button):
        patient_code = self.entry.get_text()
        if self.controller:
            self.controller.search_patient(patient_code)
        else:
            print("Controller not set")

    def on_view_patient_clicked(self, button, patient_code):
        self.controller.search_patient(patient_code)

class PantallaPaciente(BasePantalla):
    def __init__(self, switch_callback, custom_field_names = None, *args, **kwargs):
        super().__init__(switch_callback, *args, **kwargs)
        self.controller = None
        self.custom_field_names = custom_field_names or {}
        self.switch_callback = switch_callback
        self.posology_dialog = None
        self.posology_box = None
        self.main_box = Gtk.Box(
            orientation = Gtk.Orientation.VERTICAL,
            spacing = 6
        )
        self.main_box.set_vexpand(True)
        self.append(self.main_box)
        self.patient_box = Gtk.Box(
            orientation = Gtk.Orientation.VERTICAL,
            spacing = 6
        )
        self.main_box.append(self.patient_box)
        refresh_button = Gtk.Button(icon_name="view-refresh-symbolic")
        refresh_button.connect("clicked", self.on_refresh_button_clicked)
        refresh_button.set_size_request(200, 20)
        self.main_box.append(refresh_button)
        self.medication_box = Gtk.Box(
            orientation = Gtk.Orientation.VERTICAL,
            spacing = 6
        )
        self.main_box.append(self.medication_box)

        scrolled_window = Gtk.ScrolledWindow()
        scrolled_window.set_vexpand(True)
        self.medication_box.append(scrolled_window)
        self.list_box = Gtk.ListBox()
        self.list_box.set_selection_mode(Gtk.SelectionMode.NONE)
        scrolled_window.set_child(self.list_box)
        scrolled_window.set_size_request(600, 200)
        self.button_box = Gtk.Box(
            orientation = Gtk.Orientation.HORIZONTAL,
            spacing = 6
        )
        self.medication_box.append(self.button_box)
        self.add_button = Gtk.Button(icon_name = "list-add-symbolic")
        self.add_button.connect("clicked", self.on_add_clicked)
        self.medication_box.append(self.add_button)
        self.back_icon = Gtk.Image(icon_name = "go-previous-symbolic")
        self.back_label = Gtk.Label(label = vista_text[8])
        self.back_box_aux = Gtk.Box(spacing = 6)
        self.back_box_aux.set_margin_bottom(10)
        self.back_box_aux.set_margin_top(10)
        self.back_box_aux.set_margin_start(10)
        self.back_box_aux.set_margin_end(10)
        self.back_box_aux.append(self.back_icon)
        self.back_box_aux.append(self.back_label)
        self.back_button = Gtk.Button(child = self.back_box_aux)
        self.back_button.set_halign(Gtk.Align.END)
        self.back_button.set_valign(Gtk.Align.END)
        self.back_button.set_size_request(20, 10)
        self.back_button.connect("clicked", self.on_back_clicked)
        self.back_box = Gtk.Box()
        self.back_box.set_hexpand(True)
        self.back_box.set_vexpand(True)
        self.back_box.append(self.back_button)
        self.main_box.append(self.back_box)

    def set_controller(self, controller):
        self.controller = controller
    def load_medication(self):
        if self.controller:
            self.controller.get_medication()
    def on_refresh_button_clicked(self,button):
        self.load_medication()
    def display_patient_data(self, patient_data):
        while self.patient_box.get_first_child():
            self.patient_box.remove(self.patient_box.get_last_child())
        label1 = Gtk.Label(label = vista_text[10]+f" {patient_data['name']} {patient_data['surname']}")
        label1.set_halign(Gtk.Align.CENTER)
        label1.set_valign(Gtk.Align.CENTER)
        label1.set_margin_bottom(5)
        self.patient_box.append(label1)
        label2 = Gtk.Label(label = vista_text[9]+f"{patient_data['code']}")
        label2.set_halign(Gtk.Align.CENTER)
        label2.set_valign(Gtk.Align.CENTER)
        label2.set_margin_bottom(5)
        self.patient_box.append(label2)
        self.load_medication()

    def display_medications(self, medications):
        while self.list_box.get_first_child():
            self.list_box.remove(self.list_box.get_last_child())
        if medications:
            for medication in medications:
                row = Adw.ActionRow()
                row.set_title(medication['name'])
                row.set_subtitle(vista_text[13] % {'dosage': medication['dosage'], 'treat_duration': medication['treatment_duration']})
                row.add_suffix(Gtk.Label(label = vista_text[14] % {'Start_date': medication['start_date']}))
                posology_button = Gtk.Button(icon_name = "emoji-recent-symbolic")
                posology_button.connect("clicked", self.on_posology_clicked, medication['id'])
                row.add_suffix(posology_button)
                modify_button = Gtk.Button(icon_name = "document-edit-symbolic")
                modify_button.connect("clicked", self.on_modify_clicked, medication)
                row.add_suffix(modify_button)
                delete_button = Gtk.Button(icon_name = "user-trash-symbolic")
                delete_button.connect("clicked", self.on_delete_clicked, medication['id'])
                row.add_suffix(delete_button)
                self.list_box.append(row)

    def on_posology_clicked(self, button, medication_id):
        if self.controller:
            self.controller.medicationidActual = medication_id
            self.controller.get_posology(medication_id)
        else:
            print("Controller not set")

    def display_posology(self, posology_data):
        if self.posology_dialog is None:
            self.posology_dialog = self.create_posology_dialog()

        self.update_posology_content(posology_data)
        self.posology_dialog.present()

    def create_posology_dialog(self):
        dialog = Gtk.Dialog(
            title = vista_text[30],
            transient_for = self.get_root(),
            modal = True
        )
        dialog.set_default_size(400, 400)
        dialog.set_decorated(False)

        content_area = dialog.get_content_area()
        content_area.set_spacing(12)
        content_area.set_margin_top(20)
        content_area.set_margin_bottom(20)
        content_area.set_margin_start(20)
        content_area.set_margin_end(20)

        scrolled_window = Gtk.ScrolledWindow()
        scrolled_window.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        scrolled_window.set_vexpand(True)
        content_area.append(scrolled_window)

        self.posology_box = Gtk.Box(
            orientation = Gtk.Orientation.VERTICAL,
            spacing = 12
        )
        scrolled_window.set_child(self.posology_box)

        button_box = Gtk.Box(
            orientation = Gtk.Orientation.HORIZONTAL,
            spacing = 12
        )
        button_box.set_halign(Gtk.Align.CENTER)
        button_box.set_margin_top(20)
        content_area.append(button_box)

        add_button = Gtk.Button(label = vista_text[11])
        add_button.connect("clicked", self.on_add_posology_clicked)
        button_box.append(add_button)

        back_button = Gtk.Button(label = vista_text[8])
        back_button.connect("clicked", lambda x: dialog.hide())
        button_box.append(back_button)

        return dialog

    def update_posology_content(self, posology_data):
        while self.posology_box.get_first_child():
            self.posology_box.remove(self.posology_box.get_last_child())

        if posology_data:
            for index, posology in enumerate(posology_data, start = 1):
                row = Gtk.Box(
                    orientation = Gtk.Orientation.HORIZONTAL,
                    spacing = 10
                )

                label = Gtk.Label (label= vista_text[15] % {'index': index, 'hour': posology['hour'], 'minute':posology['minute']})
                label.set_halign(Gtk.Align.START)
                label.set_hexpand(True)
                row.append(label)

                modify_button = Gtk.Button(icon_name = "document-edit-symbolic")
                modify_button.connect("clicked", self.on_modify_posology_clicked, posology)
                row.append(modify_button)

                delete_button = Gtk.Button(icon_name = "user-trash-symbolic")
                delete_button.connect("clicked", self.on_delete_posology_clicked, posology['id'])
                row.append(delete_button)

                self.posology_box.append(row)
        else:
            label = Gtk.Label(label = vista_text[27])
            label.set_halign(Gtk.Align.CENTER)
            label.set_valign(Gtk.Align.CENTER)
            self.posology_box.append(label)

    def on_modify_posology_clicked(self, button, posology):
        dialog = Gtk.Dialog(
            title = vista_text[26],
            transient_for = self.posology_dialog,
            modal = True
        )
        dialog.add_buttons(vista_text[17], Gtk.ResponseType.CANCEL, vista_text[18], Gtk.ResponseType.OK)

        content_area = dialog.get_content_area()
        content_area.set_spacing(12)
        content_area.set_margin_top(20)
        content_area.set_margin_bottom(20)
        content_area.set_margin_start(20)
        content_area.set_margin_end(20)

        time_box = Gtk.Box(
            orientation = Gtk.Orientation.HORIZONTAL,
            spacing = 12
        )
        time_box.set_halign(Gtk.Align.CENTER)

        hour_entry = Gtk.Entry()
        hour_entry.set_input_purpose(Gtk.InputPurpose.DIGITS)
        hour_entry.set_max_length(2)
        hour_entry.set_text(str(posology['hour']))
        hour_label = Gtk.Label(label = vista_text[19]+': ')
        time_box.append(hour_label)
        time_box.append(hour_entry)

        minute_entry = Gtk.Entry()
        minute_entry.set_input_purpose(Gtk.InputPurpose.DIGITS)
        minute_entry.set_max_length(2)
        minute_entry.set_text(str(posology['minute']))
        minute_label = Gtk.Label(label = vista_text[20]+': ')
        time_box.append(minute_label)
        time_box.append(minute_entry)

        content_area.append(time_box)

        dialog.connect("response", self.on_modify_posology_response, posology['id'], hour_entry, minute_entry)
        dialog.present()

    def on_modify_posology_response(self, dialog, response, posology_id, hour_entry, minute_entry):
        if response == Gtk.ResponseType.OK:
            hour = hour_entry.get_text()
            minute = minute_entry.get_text()
            self.controller.modify_posology(posology_id, {'hour': hour, 'minute': minute})
        dialog.destroy()

    def on_add_posology_clicked(self, button):
        dialog = Gtk.Dialog(
            title = vista_text[11]+" "+vista_text[30],
            transient_for = self.posology_dialog,
            modal = True
        )
        dialog.add_buttons(vista_text[17], Gtk.ResponseType.CANCEL, vista_text[11], Gtk.ResponseType.OK)

        content_area = dialog.get_content_area()
        content_area.set_spacing(12)
        content_area.set_margin_top(20)
        content_area.set_margin_bottom(20)
        content_area.set_margin_start(20)
        content_area.set_margin_end(20)

        time_box = Gtk.Box(
            orientation = Gtk.Orientation.HORIZONTAL,
            spacing = 12
        )
        time_box.set_halign(Gtk.Align.CENTER)

        hour_entry = Gtk.Entry()
        hour_entry.set_input_purpose(Gtk.InputPurpose.DIGITS)
        hour_entry.set_max_length(2)
        hour_label = Gtk.Label(label = vista_text[19])
        time_box.append(hour_label)
        time_box.append(hour_entry)

        minute_entry = Gtk.Entry()
        minute_entry.set_input_purpose(Gtk.InputPurpose.DIGITS)
        minute_entry.set_max_length(2)
        minute_label = Gtk.Label(label = vista_text[20])
        time_box.append(minute_label)
        time_box.append(minute_entry)

        content_area.append(time_box)

        dialog.connect("response", self.on_add_posology_response, hour_entry, minute_entry)
        dialog.present()

    def on_add_posology_response(self, dialog, response, hour_entry, minute_entry):
        if response == Gtk.ResponseType.OK:
            hour = hour_entry.get_text()
            minute = minute_entry.get_text()

            self.controller.add_posology({'hour': hour, 'minute': minute})

        dialog.destroy()

    def on_delete_posology_clicked(self, button, posology_id):
        if self.controller:
            self.get_root().show_confirmation_dialog(
                "¿Está seguro de que desea eliminar esta posología?",
                lambda: self.controller.delete_posology(posology_id)
            )

    def on_add_clicked(self, button):
        dialog = Gtk.Dialog(
            title = vista_text[12]+' '+vista_text[32],
            transient_for = self.get_root(),
            modal = True
        )
        dialog.add_buttons(vista_text[17], Gtk.ResponseType.CANCEL, vista_text[12], Gtk.ResponseType.OK)
        content_area = dialog.get_content_area()
        content_area.set_spacing(6)
        fields = [
            ('name', vista_text[21]+' '),
            ('dosage', vista_text[22]+' '),
            ('start_date', vista_text[23] +' (YYYY-MM-DD) '),
            ('duration', vista_text[25]+' ')
        ]
        entries = {}
        for field, label in fields:
            box = Gtk.Box(
                orientation = Gtk.Orientation.HORIZONTAL,
                spacing = 6
            )
            label_widget = Gtk.Label(label=label)
            entry = Gtk.Entry()
            box.append(label_widget)
            box.append(entry)
            content_area.append(box)
            entries[field] = entry
        dialog.connect("response", self.on_add_dialog_response, entries)
        dialog.present()

    def on_add_dialog_response(self, dialog, response, entries):
        if response == Gtk.ResponseType.OK:
            medication_data = {field: entry.get_text() for field, entry in entries.items()}
            self.controller.add_medication(medication_data)
        dialog.destroy()

    def on_modify_clicked(self, button, medication):
        dialog = Gtk.Dialog(
            title = vista_text[31],
            transient_for = self.get_root(),
            modal = True
        )
        dialog.add_buttons(vista_text[17], Gtk.ResponseType.CANCEL, vista_text[18], Gtk.ResponseType.OK)
        content_area = dialog.get_content_area()
        content_area.set_spacing(6)
        entries = {}
        fields = [
            ('name', vista_text[21]+' '),
            ('dosage', vista_text[22]+' '),
            ('start_date', vista_text[23]+' (YYYY-MM-DD) '),
            ('treatment_duration', vista_text[25]+' ')
        ]
        for field, label in fields:
            box = Gtk.Box(
                orientation = Gtk.Orientation.HORIZONTAL,
                spacing = 6
            )
            label_widget = Gtk.Label(label = label)
            entry = Gtk.Entry()
            entry.set_text(str(medication.get(field, '')))
            box.append(label_widget)
            box.append(entry)
            content_area.append(box)
            entries[field] = entry
        dialog.connect("response", self.on_modify_dialog_response, medication['id'], entries)
        dialog.present()

    def on_modify_dialog_response(self, dialog, response, medication_id, entries):
        if response == Gtk.ResponseType.OK:
            medication_data = {field: entry.get_text() for field, entry in entries.items()}
            if self.controller:
                self.controller.modify_medication(medication_id, medication_data)
        dialog.destroy()

    def on_delete_clicked(self, button, medication_id):
        if self.controller:
            self.get_root().show_confirmation_dialog(
                "¿Está seguro de que desea eliminar esta medicación?",
                lambda: self.controller.delete_medication(medication_id)
            )

    def on_back_clicked(self, button):
        self.switch_callback()
