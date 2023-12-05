# Interfaz.ps1

Add-Type -AssemblyName System.Windows.Forms

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

    $checkBoxes = @{}
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
        $checkBox = New-Object Windows.Forms.CheckBox
        $checkBox.Text = $option
        $checkBox.Location = New-Object Drawing.Point(10, $topMargin)
        $checkBox.AutoSize = $true
        $checkBox.ForeColor = [System.Drawing.Color]::DarkSlateGray
        $form.Controls.Add($checkBox)
        $checkBoxes[$option] = $checkBox
        $topMargin += $checkBox.Height + 5
    }

    $buttonEjecutar = New-Object Windows.Forms.Button
    $buttonEjecutar.Location = New-Object Drawing.Point(10, $topMargin)
    $buttonEjecutar.Size = New-Object Drawing.Size(150, 30)
    $buttonEjecutar.Text = "Ejecutar"
    $buttonEjecutar.BackColor = [System.Drawing.Color]::PaleGreen
    $buttonEjecutar.Add_Click({
        $outputTextBox.Clear()
        $selectedOptions = $checkBoxes.Values | Where-Object { $_.Checked }

        if ($selectedOptions.Count -eq 0) {
            $outputTextBox.AppendText("No se ha seleccionado ninguna función para ejecutar.")
            return
        }

        $selectedOptionsText = $selectedOptions | ForEach-Object { $_.Text }
        $outputTextBox.AppendText("Ejecutando las siguientes funciones:`r`n$($selectedOptionsText -join "`r`n")`r`n")

        # Convertir nombres de opciones en un array
        $selectedOptionsArray = $selectedOptionsText -split "`r`n"

        # Ejecutar las funciones correspondientes
        Ejecutar-Opciones $selectedOptionsArray
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
