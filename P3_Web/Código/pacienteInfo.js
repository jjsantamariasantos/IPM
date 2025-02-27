function mostrarMedicaciones(medicaciones, container, fechaInicio, fechaFin, patientId) {
    container.innerHTML = '<h2>Medicaciones</h2>';
    const ul = document.createElement("ul");

    const solicitudes = medicaciones.map(med =>
        Promise.all([
            fetch(`http://127.0.0.1:8000/patients/${patientId}/medications/${med.id}/posologies`).then(response => {
                if (!response.ok) {
                    mostrarError(`Error al cargar posologías de ${med.name}`);
                    throw new Error(`Error al cargar posologías de ${med.name}`);
                }
                return response.json();
            }),
            fetch(`http://127.0.0.1:8000/patients/${patientId}/medications/${med.id}/intakes`).then(response => {
                if (!response.ok) {
                    mostrarError(`Error al cargar intakes de ${med.name}`);
                    throw new Error(`Error al cargar intakes de ${med.name}`);
                }
                return response.json();
            })
        ])
            .then(([posologies, intakes]) => {
                const tomasEsperadas = generarTomasEsperadas(med.start_date, med.treatment_duration, posologies, fechaInicio, fechaFin);
                const tomasRealizadas = new Map(intakes.map(intake => {
                    const intakeDate = new Date(intake.date);
                    return [`${intakeDate.getFullYear()}-${intakeDate.getMonth()}-${intakeDate.getDate()}-${intakeDate.getHours()}`, intakeDate];
                }));

                if (tomasEsperadas.length > 0) {
                    const li = document.createElement("li");
                    const medicamentoDiv = document.createElement("div");
                    medicamentoDiv.textContent = `Nombre: ${med.name}, Dosis: ${med.dosage}`;
                    medicamentoDiv.style.cursor = 'pointer';
                    medicamentoDiv.style.fontWeight = 'bold';
                    ul.appendChild(li);
                    li.appendChild(medicamentoDiv);

                    const tomasContainer = document.createElement("ul");
                    tomasContainer.style.display = 'none';
                    li.appendChild(tomasContainer);

                    medicamentoDiv.setAttribute('role', 'button');
                    medicamentoDiv.setAttribute('aria-expanded', 'false');
                    medicamentoDiv.setAttribute('aria-controls', `tomas-${med.id}`);
                    tomasContainer.id = `tomas-${med.id}`;
                    tomasContainer.setAttribute('role', 'region');
                    tomasContainer.setAttribute('aria-labelledby', medicamentoDiv.id);

                    tomasEsperadas.forEach(toma => {
                        const tomaLi = document.createElement("li");
                        const tomaClave = `${toma.fecha.getFullYear()}-${toma.fecha.getMonth()}-${toma.fecha.getDate()}-${toma.fecha.getHours()}`;
                        const tomaRealizada = tomasRealizadas.get(tomaClave);
                        if (tomaRealizada) {
                            const diferencia = tomaRealizada.getTime() - toma.fecha.getTime();
                            const esTarde = diferencia > 30 * 60 * 1000; // Más de 30 minutos tarde
                            tomaLi.classList.add(esTarde ? "toma-tarde" : "toma-realizada");
                            tomaLi.textContent = `Fecha: ${tomaRealizada.toLocaleDateString('es-ES')} ${tomaRealizada.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })} ${esTarde ? '(Tarde)' : ''}`;
                        } else {
                            tomaLi.classList.add("toma-pendiente");
                            tomaLi.textContent = `Fecha: ${toma.fecha.toLocaleDateString('es-ES')} ${toma.fecha.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })} (Pendiente)`;
                        }

                        tomasContainer.appendChild(tomaLi);
                    });

                    medicamentoDiv.addEventListener("click", () => {
                        const expanded = medicamentoDiv.getAttribute('aria-expanded') === 'true' || false;
                        medicamentoDiv.setAttribute('aria-expanded', !expanded);
                        tomasContainer.style.display = expanded ? 'none' : 'block';
                    });
                }
            })
            .catch(error => {
                mostrarError(error);
                console.error(error)
            })
    );

    Promise.all(solicitudes).then(() => {
        container.appendChild(ul);
    });
}

function generarTomasEsperadas(startDate, treatmentDuration, posologies, fechaInicio, fechaFin) {
    const tomas = [];
    const fechaInicioTratamiento = new Date(startDate);
    const fechaFinTratamiento = new Date(Math.min(fechaFin.getTime(), fechaInicioTratamiento.getTime() + treatmentDuration * 24 * 60 * 60 * 1000));

    for (let dia = new Date(Math.max(fechaInicioTratamiento, fechaInicio)); dia <= fechaFinTratamiento; dia.setDate(dia.getDate() + 1)) {
        posologies.forEach(posologia => {
            const fechaToma = new Date(dia);
            fechaToma.setHours(posologia.hour, posologia.minute, 0, 0);

            if (fechaToma >= fechaInicio && fechaToma <= fechaFin) {
                tomas.push({ fecha: fechaToma });
            }
        });
    }

    return tomas;
}

document.addEventListener("DOMContentLoaded", function () {
    const medicacionesDiv = document.getElementById("medicaciones");
    const nombrePacienteDiv = document.getElementById("nombrePaciente");

    const filtrosMenuButton = document.getElementById("filtrosMenu");
    const menuDesplegable = document.getElementById("menuDesplegable");
    const filtroUltimoMes = document.getElementById("filtroUltimoMes");
    const filtroUltimosDias = document.getElementById("filtroUltimosDias");
    const filtroPersonalizado = document.getElementById("filtroPersonalizado");
    const diasInput = document.getElementById("diasInput");
    const fechaInicioInput = document.getElementById("fechaInicio");
    const fechaFinInput = document.getElementById("fechaFin");
    const aplicarFiltrosButton = document.getElementById("aplicarFiltros");

    const parametros = new URLSearchParams(window.location.search);
    const patientId = parametros.get("patient_id");

    function getUltimoMesFechas() {
        const fechaFin = new Date();
        const fechaInicio = new Date();
        fechaInicio.setMonth(fechaInicio.getMonth() - 1);
        fechaInicio.setHours(0, 0, 0, 0);
        fechaFin.setHours(23, 59, 59, 999);
        return { fechaInicio, fechaFin };
    }

    filtrosMenuButton.addEventListener("click", function () {
        menuDesplegable.classList.toggle("visible");
        menuDesplegable.classList.toggle("oculto");
    });

    filtroUltimosDias.addEventListener("change", () => {
        diasInput.disabled = !filtroUltimosDias.checked;
        fechaInicioInput.disabled = true;
        fechaFinInput.disabled = true;
    });

    filtroUltimoMes.addEventListener("change", () => {
        diasInput.disabled = true;
        fechaInicioInput.disabled = true;
        fechaFinInput.disabled = true;
    });

    filtroPersonalizado.addEventListener("change", () => {
        diasInput.disabled = true;
        fechaInicioInput.disabled = false;
        fechaFinInput.disabled = false;
    });

    diasInput.addEventListener("input", function() {
        if (this.value < 1) {
            this.value = 1;
        }
    });

    function aplicarFiltros() {
        let fechaInicio, fechaFin;

        if (filtroUltimoMes.checked) {
            ({ fechaInicio, fechaFin } = getUltimoMesFechas());
        } else if (filtroUltimosDias.checked) {
            const dias = parseInt(diasInput.value, 10);
            if (isNaN(dias) || dias < 1) {
                alert("Por favor, ingresa un número válido de días (mínimo 1).");
                return;
            }
            fechaFin = new Date();
            fechaInicio = new Date();
            fechaInicio.setDate(fechaInicio.getDate() - dias + 1);
        } else if (filtroPersonalizado.checked) {
            fechaInicio = new Date(fechaInicioInput.value);
            fechaFin = new Date(fechaFinInput.value);
            if (isNaN(fechaInicio.getTime()) || isNaN(fechaFin.getTime())) {
                alert("Por favor, ingresa fechas válidas.");
                return;
            }
            if (fechaFin < fechaInicio) {
                alert("La fecha de fin debe ser posterior a la fecha de inicio.");
                return;
            }
        } else {
            alert("Por favor, selecciona un filtro.");
            return;
        }

        // Ajustar las fechas para incluir todo el día
        fechaInicio.setHours(0, 0, 0, 0);
        fechaFin.setHours(23, 59, 59, 999);

        cargarYMostrarMedicaciones(fechaInicio, fechaFin);

        menuDesplegable.classList.remove("visible");
        menuDesplegable.classList.add("oculto");
    }

    aplicarFiltrosButton.addEventListener("click", aplicarFiltros);

    function cargarYMostrarMedicaciones(fechaInicio, fechaFin) {
        fetch(`http://127.0.0.1:8000/patients/${patientId}/medications`)
            .then(response => {
                if (!response.ok) {
                    throw new Error("Error al cargar las medicaciones");
                }
                return response.json();
            })
            .then(data => {
                mostrarMedicaciones(data, medicacionesDiv, fechaInicio, fechaFin, patientId);
            })
            .catch(error => {
                medicacionesDiv.innerHTML = `<p>Error al cargar las medicaciones: ${error.message}</p>`;
            });
    }

    if (patientId) {
        fetch(`http://127.0.0.1:8000/patients/${patientId}`)
            .then(response => {
                if (!response.ok) {
                    throw new Error("Error al cargar los datos del paciente");
                }
                return response.json();
            })
            .then(data => {
                nombrePacienteDiv.textContent = `${data.name} ${data.surname}`;
                const { fechaInicio, fechaFin } = getUltimoMesFechas();
                cargarYMostrarMedicaciones(fechaInicio, fechaFin);
            })
            .catch(error => {
                medicacionesDiv.innerHTML = `<p>Error al cargar: ${error.message}</p>`;
            });
    } else {
        medicacionesDiv.innerHTML = '<p>No se proporcionó un ID de paciente.</p>';
    }
});
function mostrarError(mensaje) {
    const errorDiv = document.createElement('div');
    errorDiv.textContent = mensaje;
    errorDiv.style.color = 'red';
    errorDiv.style.marginTop = '10px';
    document.body.appendChild(errorDiv);
}