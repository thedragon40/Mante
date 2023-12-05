# Interfaz.ps1

# Cargar la Asamblea para Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Función para crear y mostrar la interfaz gráfica
function Mostrar-Interfaz {
    $form = New-Object Windows.Forms.Form
    $form.Text = "Mantenimiento de PC"
    $form.StartPosition = "CenterScreen"

    $estadosFunciones = @{}
    $topMargin = 10

    $opcionesMenu = @(
        "Desfragmentar el disco",
        "Limpiar archivos temporales",
        "Verificar y reparar errores en el disco",
        "Actualizar el sistema",
        "Escanear seguridad con Windows Defender",
        "Liberar espacio en disco",
        "Respaldar archivos importantes",
        "Crear un punto de restauración del sistema",
        "Desinstalar aplicaciones no deseadas",
        "Gestionar programas de inicio del sistema",
        "Ejecutar todas las opciones",
        "Salir"
    )

    foreach ($opcion in $opcionesMenu) {
        $checkBox = New-Object Windows.Forms.CheckBox
        $checkBox.Text = $opcion
        $checkBox.Location = New-Object Drawing.Point(10, $topMargin)
        $checkBox.AutoSize = $true
        $form.Controls.Add($checkBox)

        $checkBox.Add_Click({
            $checkBox.Text  # Esta línea te dará el texto de la opción seleccionada
            # Puedes agregar código adicional aquí si es necesario
        })

        $estadosFunciones[$opcion] = $checkBox
        $topMargin += $checkBox.Height + 5
    }

    $buttonEjecutar = New-Object Windows.Forms.Button
    $buttonEjecutar.Location = New-Object Drawing.Point(150, $topMargin)
    $buttonEjecutar.Size = New-Object Drawing.Size(200, 30)
    $buttonEjecutar.Text = "Ejecutar"
    $buttonEjecutar.Add_Click({
        $funcionesActivadas = $estadosFunciones.Keys | Where-Object { $estadosFunciones[$_].Checked }

        if ($funcionesActivadas.Count -eq 0) {
            Write-Host "No se ha seleccionado ninguna función para ejecutar."
            return
        }

        # Desactivar otros controles y desmarcar funciones
        foreach ($control in $estadosFunciones.Values) {
            $control.Enabled = $false
            $control.Checked = $false
        }

        foreach ($funcion in $funcionesActivadas) {
            Write-Host "Ejecutando: $funcion"
            Ejecutar-Funcion $funcion
        }

        # Cerrar la ventana después de ejecutar
        $form.Close()
    })
    $form.Controls.Add($buttonEjecutar)

    $buttonSalir = New-Object Windows.Forms.Button
    $buttonSalir.Location = New-Object Drawing.Point(150, $topMargin + 40)
    $buttonSalir.Size = New-Object Drawing.Size(200, 30)
    $buttonSalir.Text = "Salir"
    $buttonSalir.Add_Click({
        $form.Close()
        # Exit-PSSession  # Este comando no es necesario aquí
    })
    $form.Controls.Add($buttonSalir)

    $form.Add_Shown({$form.Activate()})
    $form.ShowDialog()
}

function Ejecutar-Funcion($funcion) {
    switch ($funcion) {
        "Desfragmentar el disco" { Desfragmentar-Disco }
        "Limpiar archivos temporales" { Limpiar-Temporales }
        "Verificar y reparar errores en el disco" { Verificar-Errores-Disco }
        "Actualizar el sistema" { Actualizar-Sistema }
        "Escanear seguridad con Windows Defender" { Escanear-Seguridad }
        "Liberar espacio en disco" { Liberar-Espacio }
        "Respaldar archivos importantes" { Respaldar-Archivos }
        "Crear un punto de restauración del sistema" { Crear-Punto-Restauracion }
        "Desinstalar aplicaciones no deseadas" { Desinstalar-Aplicaciones }
        "Gestionar programas de inicio del sistema" { Gestionar-Inicio-Sistema }
        "Ejecutar todas las opciones" {
            foreach ($opcion in $opcionesMenu) {
                Ejecutar-Funcion $opcion
            }
        }
        "Salir" { $form.Close() }
        default { Write-Host "Opción no válida: $funcion" }
    }
}

# Ejecución del programa
Mostrar-Interfaz
