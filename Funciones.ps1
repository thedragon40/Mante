# MaintenanceFunctions.ps1

function DefragmentDisk {
    Write-Output "Desfragmentando el disco..."
    Optimize-Volume -DriveLetter C -Defrag -Verbose
}

function CleanTemporaryFiles {
    Write-Output "Limpiando archivos temporales..."
    Remove-Item -Path $env:TEMP\* -Recurse -Force -Verbose
}

function CheckDiskErrors {
    Write-Output "Verificando y reparando errores en el disco..."
    chkdsk C: /f /r /x /v
}

function UpdateSystem {
    Write-Output "Actualizando el sistema..."
    Invoke-Expression "& $($env:systemroot)\system32\windowspowershell\v1.0\powershell.exe -nop -c `"install-module pswindowsupdate; get-windowsupdate`" -verb runAs"
}

function ScanWithWindowsDefender {
    Write-Output "Escaneando seguridad con Windows Defender..."
    Start-MpScan -ScanType FullScan -Verbose
}

function FreeUpDiskSpace {
    Write-Output "Liberando espacio en disco..."
    Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Force -Recurse -Verbose
}

function CreateSystemRestorePoint {
    Write-Output "Creando un punto de restauración del sistema..."
    Checkpoint-Computer -Description "Maintenance Restore Point" -RestorePointType MODIFY_SETTINGS
}

function UninstallUnwantedApplications {
    Write-Output "Desinstalando aplicaciones no deseadas..."
    Get-WmiObject -Class Win32_Product -Filter "Name LIKE '%badapp%'" | ForEach-Object { $_.Uninstall() }
}

function ManageStartupPrograms {
    Write-Output "Gestionando programas de inicio del sistema..."
    Get-CimInstance -ClassName Win32_StartupCommand | Select-Object Caption, Command -Verbose
}

# Agrega funciones adicionales según sea necesario...
