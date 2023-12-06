# MaintenanceForm.ps1
Add-Type -AssemblyName System.Windows.Forms

# Cargar funciones desde el archivo MaintenanceFunctions.ps1
$Functions = . ".\MaintenanceFunctions.ps1"

# Crear diccionario para mapear nombres mostrados a nombres internos de funciones
$FunctionNameMappings = @{
    "Desfragmentar el disco"                     = "DefragmentDisk"
    "Limpiar archivos temporales"                = "CleanTemporaryFiles"
    "Verificar y reparar errores en el disco"    = "CheckDiskErrors"
    "Actualizar el sistema"                      = "UpdateSystem"
    "Escanear seguridad con Windows Defender"    = "ScanWithWindowsDefender"
    "Liberar espacio en disco"                   = "FreeUpDiskSpace"
    "Respaldar archivos importantes"             = "BackupImportantFiles"
    "Crear un punto de restauración del sistema" = "CreateSystemRestorePoint"
    "Desinstalar aplicaciones no deseadas"       = "UninstallUnwantedApplications"
    "Gestionar programas de inicio del sistema"  = "ManageStartupPrograms"
    # Agregar otras entradas según sea necesario
}

# Función para ejecutar la tarea correspondiente
function Execute-Task {
    param (
        [string]$TaskOption
    )

    try {
        # Deshabilitar todos los botones para evitar clics múltiples
        $Form.Controls | Where-Object { $_ -is [System.Windows.Forms.Button] } | ForEach-Object { $_.Enabled = $false }

        # Actualizar la etiqueta de estado
        $StatusLabel.Text = "Ejecutando: $TaskOption"

        # Ejecutar la lógica correspondiente a cada opción
        $ProgressBar.Value = 0
        $ProgressBar.Maximum = 100

        # Llamada a la función correspondiente según la opción seleccionada
        $Function = $Functions.$FunctionNameMappings[$TaskOption]
        if ($Function -ne $null) {
            & $Function
        }
        else {
            throw "Error: No se encontró una función asociada a la tarea '$TaskOption'."
        }
    }
    catch {
        Write-Host "Error: $_"
    }
    finally {
        # Restaurar la barra de progreso y la etiqueta de estado
        $ProgressBar.Value = 0
        $StatusLabel.Text = "Completado: $TaskOption"

        # Habilitar todos los botones después de completar la tarea
        $Form.Controls | Where-Object { $_ -is [System.Windows.Forms.Button] } | ForEach-Object { $_.Enabled = $true }
    }
}

# Crear la ventana principal
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Mantenimiento de Windows"
$Form.Size = New-Object System.Drawing.Size(500, 700)
$Form.StartPosition = "CenterScreen"
$Form.BackColor = [System.Drawing.Color]::FromArgb(34, 34, 34)  # Cambiar el color de fondo principal a gris oscuro
$Form.MaximizeBox = $false  # Desactivar la posibilidad de maximizar la ventana

# Agregar una barra de progreso
$ProgressBar = New-Object System.Windows.Forms.ProgressBar
$ProgressBar.Location = New-Object System.Drawing.Point(50, 600)
$ProgressBar.Size = New-Object System.Drawing.Size(400, 20)
$Form.Controls.Add($ProgressBar)

# Agregar una etiqueta de estado
$StatusLabel = New-Object System.Windows.Forms.Label
$StatusLabel.Location = New-Object System.Drawing.Point(50, 630)
$StatusLabel.Size = New-Object System.Drawing.Size(400, 20)
$StatusLabel.ForeColor = [System.Drawing.Color]::White  # Cambiar el color del texto a blanco
$Form.Controls.Add($StatusLabel)

# Crear botones para cada opción
$Options = @(
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

$YPos = 130
foreach ($Option in $Options) {
    $Button = New-Object System.Windows.Forms.Button
    $Button.Text = $Option
    $Button.Location = New-Object System.Drawing.Point(50, $YPos)
    $Button.Size = New-Object System.Drawing.Size(400, 30)
    $Button.BackColor = [System.Drawing.Color]::FromArgb(64, 64, 64)  # Cambiar el color de fondo de los botones a gris oscuro
    $Button.ForeColor = [System.Drawing.Color]::White
    $Button.Tag = $Option  # Almacena el nombre de la opción en el Tag del botón
    $ScriptBlock = [scriptblock]::Create({
            param($ClickedOption)
            Execute-Task -TaskOption $ClickedOption
        })

    $Button.Add_Click($ScriptBlock)

    $Form.Controls.Add($Button)
    $YPos += 40
}

# Mostrar la ventana de manera modal
$Form.ShowDialog() | Out-Null
