# Interfaz.ps1

Add-Type -AssemblyName System.Windows.Forms

function Mostrar-Interfaz {
    $form = New-Object Windows.Forms.Form
    $form.Text = "Mantenimiento de PC"
    $form.StartPosition = "CenterScreen"
    $form.Size = New-Object Drawing.Size(400, 300)

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
        $form.Controls.Add($checkBox)
        $checkBoxes[$option] = $checkBox
        $topMargin += $checkBox.Height + 5
    }

    $buttonEjecutar = New-Object Windows.Forms.Button
    $buttonEjecutar.Location = New-Object Drawing.Point(10, $topMargin)
    $buttonEjecutar.Size = New-Object Drawing.Size(150, 30)
    $buttonEjecutar.Text = "Ejecutar"
    $buttonEjecutar.Add_Click({
        $outputTextBox.Clear()
        $selectedOptions = $checkBoxes.Values | Where-Object { $_.Checked }

        if ($selectedOptions.Count -eq 0) {
            $outputTextBox.AppendText("No se ha seleccionado ninguna función para ejecutar.")
            return
        }

        foreach ($option in $selectedOptions) {
            $outputTextBox.AppendText("Ejecutando: $($option.Text)`r`n")
            Ejecutar-Funcion $option.Text
        }
    })
    $form.Controls.Add($buttonEjecutar)

    $buttonSalir = New-Object Windows.Forms.Button
    $buttonSalir.Location = New-Object Drawing.Point(180, $topMargin)
    $buttonSalir.Size = New-Object Drawing.Size(150, 30)
    $buttonSalir.Text = "Salir"
    $buttonSalir.Add_Click({
        $form.Close()
    })
    $form.Controls.Add($buttonSalir)

    $form.Add_Shown({$form.Activate()})
    $form.ShowDialog()
}

function Ejecutar-Funcion($funcion) {
    # Implementa la lógica de las funciones según tus necesidades
    switch ($funcion) {
        "Desfragmentar el disco" { Write-Host "Desfragmentando el disco" }
        "Limpiar archivos temporales" { Write-Host "Limpiando archivos temporales" }
        # Agrega más funciones según sea necesario
        default { Write-Host "Opción no válida: $funcion" }
    }
}

# Ejecución del programa
Mostrar-Interfaz
