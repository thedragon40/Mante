# Interfaz.ps1

Add-Type -AssemblyName System.Windows.Forms

# Cargar funciones desde Funciones.ps1
. ".\Funciones.ps1"

function Mostrar-Interfaz {
    $form = New-Object Windows.Forms.Form
    $form.Text = "Mantenimiento de PC"
    $form.StartPosition = "CenterScreen"
    $form.Size = New-Object Drawing.Size(400, 300)
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog  # Impide que la ventana se pueda maximizar o redimensionar

    # Cambiar el color de fondo y el color de la fuente
    $form.BackColor = [System.Drawing.Color]::LightYellow
    $form.ForeColor = [System.Drawing.Color]::DarkSlateGray

    # Cambiar el icono de la ventana
    $iconPath = "C:\Ruta\A\Tu\Icono.ico"  # Ruta al archivo de icono personalizado
    if (Test-Path $iconPath) {
        $form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($iconPath)
    }

    $outputTextBox = New-Object Windows.Forms.TextBox
    $outputTextBox.Multiline = $true
    $outputTextBox.ScrollBars = "Vertical"
    $outputTextBox.Location = New-Object Drawing.Point(10, 10)
    $outputTextBox.Size = New-Object Drawing.Size(380, 150)
    $outputTextBox.ReadOnly = $true
    $form.Controls.Add($outputTextBox)

    $toggleButtons = @{}
    $options = @(
        "Desfragmentar el disco",
        "Limpiar archivos temporales",
        "Verificar y reparar errores en el disco",
        "Actualizar el sistema",
        "Escanear seguridad con Windows Defender",
        "Liberar espacio en disco",
        "Respaldar archivos importantes",
        "Crear un punto de restauración del sistema",
        "Desinstalar aplicaciones no deseadas",
        "Gestionar programas de inicio del sistema"
    )

    $topMargin = 170

    foreach ($option in $options) {
        $toggleButton = New-Object Windows.Forms.CheckBox
        $toggleButton.Text = $option
        $toggleButton.Location = New-Object Drawing.Point(10, $topMargin)
        $toggleButton.AutoSize = $true
        $toggleButton.ForeColor = [System.Drawing.Color]::DarkSlateGray
        $form.Controls.Add($toggleButton)
        $toggleButtons[$option] = $toggleButton
        $topMargin += $toggleButton.Height + 5
    }

    $buttonEjecutar = New-Object Windows.Forms.Button
    $buttonEjecutar.Location = New-Object Drawing.Point(10, $topMargin)
    $buttonEjecutar.Size = New-Object Drawing.Size(150, 30)
    $buttonEjecutar.Text = "Ejecutar"
    $buttonEjecutar.BackColor = [System.Drawing.Color]::PaleGreen
    $buttonEjecutar.Add_Click({
        $outputTextBox.Clear()
        $selectedOptions = $toggleButtons.Values | Where-Object { $_.Checked }

        if ($selectedOptions.Count -eq 0) {
            $outputTextBox.AppendText("No se ha seleccionado ninguna función para ejecutar.")
            return
        }

        foreach ($option in $selectedOptions) {
            $outputTextBox.AppendText("Ejecutando: $($option.Text)`r`n")
            Ejecutar-Funcion $option.Text
            $option.Checked = $false  # Desactivar el botón después de ejecutar
        }
    })
    $form.Controls.Add($buttonEjecutar)

    $buttonSalir = New-Object Windows.Forms.Button
    $buttonSalir.Location = New-Object Drawing.Point(180, $topMargin)
    $buttonSalir.Size = New-Object Drawing.Size(150, 30)
    $buttonSalir.Text = "Salir"
    $buttonSalir.BackColor = [System.Drawing.Color]::LightCoral
    $buttonSalir.Add_Click({
        $form.Close()
    })
    $form.Controls.Add($buttonSalir)

    $form.Add_Shown({$form.Activate()})
    $form.ShowDialog()
}

# Ejecución del programa
Mostrar-Interfaz
