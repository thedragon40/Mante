# MaintenanceFunctions.ps1

function DefragmentDisk {

    Write-Host "Desfragmentando el disco..."
    
    Optimize-Volume -DriveLetter C -Defrag -Verbose

}

function CleanTemporaryFiles {

    Write-Host "Limpiando archivos temporales..."
    
    Remove-Item -Path $env:TEMP\* -Recurse -Force -Verbose
    
}

function CheckDiskErrors {

    Write-Host "Verificando y reparando errores en el disco..."
    
    chkdsk C: /f /r /x /v
    
}

function UpdateSystem {

    Write-Host "Actualizando el sistema..."
    
    Invoke-Expression "& $($env:systemroot)\system32\windowspowershell\v1.0\powershell.exe -nop -c `"install-module pswindowsupdate; get-windowsupdate`" -verb runAs"
    
}

function ScanWithWindowsDefender {

    Write-Host "Escaneando seguridad con Windows Defender..."
    
    Start-MpScan -ScanType FullScan -Verbose

}

function FreeUpDiskSpace {
    Write-Host "Liberando espacio en disco..."
    # Agrega aquí los comandos específicos para liberar espacio en disco
    Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Force -Recurse -Verbose
}

function CreateSystemRestorePoint {

    Write-Host "Creando un punto de restauración del sistema..."
    
    Checkpoint-Computer -Description "Maintenance Restore Point" -RestorePointType MODIFY_SETTINGS

}

function UninstallUnwantedApplications {

    Write-Host "Desinstalando aplicaciones no deseadas..."
    
    Get-WmiObject -Class Win32_Product -Filter "Name LIKE '%badapp%'" | ForEach-Object {$_.Uninstall()}
    
}

function ManageStartupPrograms {
    Write-Host "Gestionando programas de inicio del sistema..."
    # Agrega aquí los comandos específicos para gestionar programas de inicio del sistema
    Get-CimInstance -ClassName Win32_StartupCommand | Select-Object Caption, Command -Verbose
}

# Agrega funciones adicionales según sea necesario...
