// Esperar a que el DOM esté completamente cargado
/*document.addEventListener("DOMContentLoaded", function () {
    let pacientesCargados = []; // Lista para almacenar los pacientes cargados
    const listaPacientes = document.getElementById("listaPacientes");
    const cargarPacientesBoton = document.getElementById("cargarPacientesBoton");

    // Obtener el botón para cargar pacientes
    if (cargarPacientesBoton) {
        cargarPacientesBoton.addEventListener("click", function () {
            if (listaPacientes.style.display === "none" || listaPacientes.style.display === "") {
                // Mostrar la lista de pacientes
                listaPacientes.style.display = "block";
                cargarPacientes(); // Cargar pacientes al hacer clic en el botón
            } else {
                // Ocultar la lista de pacientes
                listaPacientes.style.display = "none";
                cargarPacientesBoton.textContent = "Mostrar pacientes"; // Cambiar el texto del botón
            }
        });
    }

    // Obtener el botón para buscar paciente por código
    const buscarPacienteBoton = document.getElementById("buscarPacienteBoton");

    if (buscarPacienteBoton) {
        buscarPacienteBoton.addEventListener("click", function () {
            const codigoPaciente = document.getElementById("codigoPaciente").value.trim();

            if (codigoPaciente) {
                if (pacientesCargados.length === 0) {
                    // Si no se han cargado pacientes, hacer la solicitud para obtenerlos
                    cargarPacientes().then(() => {
                        buscarPacientePorCodigo(codigoPaciente); // Buscar paciente una vez cargados
                    });
                } else {
                    // Si los pacientes ya están cargados, buscar en la lista
                    buscarPacientePorCodigo(codigoPaciente);
                }
            } else {
                alert("Por favor, ingresa un código de paciente.");
            }
        });
    }

    // Función para cargar los pacientes desde la API
    function cargarPacientes() {
        return fetch("http://127.0.0.1:8000/patients")
            .then(response => {
                if (!response.ok) {
                    throw new Error("Network response was not ok");
                }
                return response.json(); // Parsear la respuesta como JSON
            })
            .then(data => {
                pacientesCargados = data; // Guardar los pacientes cargados
                mostrarPacientes(data); // Mostrar los pacientes en la lista
            })
            .catch(error => {
                console.error("There was a problem with the fetch operation:", error);
            });
    }

    // Función para buscar un paciente por código en la lista cargada
    function buscarPacientePorCodigo(codigoPaciente) {
        const pacienteEncontrado = pacientesCargados.find(paciente => paciente.code === codigoPaciente);

        if (pacienteEncontrado) {
            // Si el paciente es encontrado, redirigir a la página de información con su id
            mostrarPacienteInfo(pacienteEncontrado);
        } else {
            // Si no se encuentra el paciente
            alert("Paciente no encontrado.");
        }
    }

    // Función para mostrar los pacientes en la lista
    function mostrarPacientes(pacientes) {
        if (listaPacientes) {
            // Limpiar el contenido previo antes de agregar nuevos pacientes
            listaPacientes.innerHTML = '';

            // Recorrer la lista de pacientes y crear elementos HTML
            pacientes.forEach(paciente => {
                const li = document.createElement("li"); // Crear un nuevo elemento de lista
                li.classList.add("paciente");

                // Crear elementos para mostrar los datos del paciente
                const nombre = document.createElement("a");
                nombre.classList.add("nombre");
                nombre.textContent = `${paciente.surname}, ${paciente.name}`;
                nombre.href = `pacienteInfo.html?patient_id=${paciente.id}`;

                const codigo = document.createElement("a");
                codigo.classList.add("codigo");
                codigo.textContent = paciente.code;

                // Agregar los elementos de nombre y código al <li>
                li.appendChild(nombre);
                li.appendChild(codigo);

                // Agregar el <li> al contenedor
                listaPacientes.appendChild(li);
            });
        }
    }

    // Función para mostrar la información del paciente buscado
    function mostrarPacienteInfo(paciente) {
        // Redirigir a la página de información del paciente con los datos
        const url = `pacienteInfo.html?patient_id=${paciente.id}`;
        window.location.href = url;
    }

    // Formatear el código de paciente con guiones automáticamente mientras el usuario escribe
    const codigoPacienteInput = document.getElementById("codigoPaciente");

    // Escuchar el evento de input para formatear el código
    codigoPacienteInput.addEventListener("input", function () {
        let value = codigoPacienteInput.value;

        // Eliminar todo lo que no sean números
        value = value.replace(/\D/g, "");

        // Formatear el código agregando los guiones
        if (value.length > 5) {
            value = value.substring(0, 3) + "-" + value.substring(3, 5) + "-" + value.substring(5, 9);
        } else if (value.length > 2) {
            value = value.substring(0, 3) + "-" + value.substring(3, 5);
        }

        // Actualizar el valor del input
        codigoPacienteInput.value = value;
    });
});
*/
document.addEventListener("DOMContentLoaded", function () {
    let pacientesCargados = [];
    const listaPacientes = document.getElementById("listaPacientes");
    const cargarPacientesBoton = document.getElementById("cargarPacientesBoton");
    const buscarPacienteBoton = document.getElementById("buscarPacienteBoton");
    const codigoPacienteInput = document.getElementById("codigoPaciente");

    if (cargarPacientesBoton) {
        cargarPacientesBoton.addEventListener("click", function () {
            if (listaPacientes.style.display === "none" || listaPacientes.style.display === "") {
                listaPacientes.style.display = "block";
                cargarPacientes();
                cargarPacientesBoton.textContent = "Ocultar pacientes";
                cargarPacientesBoton.setAttribute("aria-expanded", "true");
            } else {
                listaPacientes.style.display = "none";
                cargarPacientesBoton.textContent = "Mostrar pacientes";
                cargarPacientesBoton.setAttribute("aria-expanded", "false");
            }
        });
    }

    if (buscarPacienteBoton) {
        buscarPacienteBoton.addEventListener("click", buscarPaciente);
    }

    codigoPacienteInput.addEventListener("keyup", function(event) {
        if (event.key === "Enter") {
            buscarPaciente();
        }
    });

    function buscarPaciente() {
        const codigoPaciente = codigoPacienteInput.value.trim();
        if (codigoPaciente) {
            if (pacientesCargados.length === 0) {
                cargarPacientes().then(() => {
                    buscarPacientePorCodigo(codigoPaciente);
                });
            } else {
                buscarPacientePorCodigo(codigoPaciente);
            }
        } else {
            alert("Por favor, ingresa un código de paciente.");
            codigoPacienteInput.focus();
        }
    }

    function cargarPacientes() {
        return fetch("http://127.0.0.1:8000/patients")
            .then(response => {
                if (!response.ok) {
                    throw new Error("Network response was not ok");
                }
                return response.json();
            })
            .then(data => {
                pacientesCargados = data;
                mostrarPacientes(data);
            })
            .catch(error => {
                console.error("There was a problem with the fetch operation:", error);
                alert("Error al cargar los pacientes. Por favor, intenta de nuevo más tarde.");
            });
    }

    function buscarPacientePorCodigo(codigoPaciente) {
        const pacienteEncontrado = pacientesCargados.find(paciente => paciente.code === codigoPaciente);
        if (pacienteEncontrado) {
            mostrarPacienteInfo(pacienteEncontrado);
        } else {
            alert("Paciente no encontrado.");
            codigoPacienteInput.focus();
        }
    }

    function mostrarPacientes(pacientes) {
        if (listaPacientes) {
            listaPacientes.innerHTML = '';
            pacientes.forEach(paciente => {
                const li = document.createElement("li");
                li.classList.add("paciente");

                const nombre = document.createElement("a");
                nombre.classList.add("nombre");
                nombre.textContent = `${paciente.surname}, ${paciente.name}`;
                nombre.href = `pacienteInfo.html?patient_id=${paciente.id}`;
                nombre.setAttribute("aria-label", `Ver información de ${paciente.name} ${paciente.surname}`);

                const codigo = document.createElement("span");
                codigo.classList.add("codigo");
                codigo.textContent = paciente.code;
                codigo.setAttribute("aria-label", `Código: ${paciente.code}`);

                li.appendChild(nombre);
                li.appendChild(codigo);
                listaPacientes.appendChild(li);
            });
        }
    }

    function mostrarPacienteInfo(paciente) {
        window.location.href = `pacienteInfo.html?patient_id=${paciente.id}`;
    }

    codigoPacienteInput.addEventListener("input", function () {
        let value = codigoPacienteInput.value;
        value = value.replace(/\D/g, "");
        if (value.length > 5) {
            value = value.substring(0, 3) + "-" + value.substring(3, 5) + "-" + value.substring(5, 9);
        } else if (value.length > 2) {
            value = value.substring(0, 3) + "-" + value.substring(3, 5);
        }
        codigoPacienteInput.value = value;
    });
});