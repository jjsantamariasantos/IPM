import sys
import gi

gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')

from gi.repository import Adw
from vista import VentanaPrincipal
from controlador import Controller
from model import Model

class EntornoEscritorio(Adw.Application):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.win = None
        self.controller = None

    def do_activate(self):
        self.win = VentanaPrincipal(application=self)
        model_instance = Model()
        self.controller = Controller(model_instance, self.win)
        self.win.set_controller(self.controller)
        self.win.present()

def main():
    app = EntornoEscritorio(application_id="com.example.gtkmedication")
    return app.run(sys.argv)

if __name__ == '__main__':
    main()