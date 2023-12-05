# Funciones.ps1

# Funciones para el mantenimiento de PC

function Desfragmentar-Disco {
    Write-Host "Desfragmentando el disco..."
    Optimize-Volume -DriveLetter C -Defrag -Verbose
}

function Limpiar-Temporales {
    Write-Host "Limpiando archivos temporales..."
    # Eliminar archivos temporales en la carpeta TEMP
    Remove-Item -Path "$env:TEMP\*" -Force -Recurse
}

function Verificar-Errores-Disco {
    Write-Host "Verificando y reparando errores en el disco..."
    # Verificar y reparar errores en el disco C:
    Repair-Volume -DriveLetter C -Verbose
}

function Actualizar-Sistema {
    Write-Host "Actualizando el sistema..."
    # Abrir la configuración de Windows Update
    Start-Process "ms-settings:windowsupdate" -Wait
}

function Escanear-Seguridad {
    Write-Host "Realizando escaneo de seguridad con Windows Defender..."
    # Iniciar un escaneo rápido con Windows Defender
    Start-MpScan -ScanType QuickScan
}

function Liberar-Espacio {
    Write-Host "Liberando espacio en disco..."
    # Ejecutar la Limpieza de disco con la configuración predefinida
    Cleanmgr /sagerun:1
    # Comprimir archivos del sistema para liberar espacio
    Compact /CompactOs:always
}

function Respaldar-Archivos {
    Write-Host "Respaldando archivos importantes..."
    # Agrega aquí los comandos o la lógica para respaldar archivos
}

function Crear-Punto-Restauracion {
    Write-Host "Creando un punto de restauración del sistema..."
    # Crear un punto de restauración con la descripción indicada
    Checkpoint-Computer -Description "Punto de restauración antes de mantenimiento" -RestorePointType MODIFY_SETTINGS
}

function Desinstalar-Aplicaciones {
    Write-Host "Desinstalando aplicaciones no deseadas..."
    # Agrega aquí los comandos o la lógica para desinstalar aplicaciones
}

function Gestionar-Inicio-Sistema {
    Write-Host "Optimizando programas de inicio del sistema..."
    # Agrega aquí los comandos o la lógica para gestionar el inicio del sistema
}

function Ejecutar-Opciones($opciones) {
    foreach ($opcion in $opciones) {
        switch ($opcion) {
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
                Desfragmentar-Disco; Limpiar-Temporales; Verificar-Errores-Disco;
                Actualizar-Sistema; Escanear-Seguridad; Liberar-Espacio; Respaldar-Archivos;
                Crear-Punto-Restauracion; Desinstalar-Aplicaciones; Gestionar-Inicio-Sistema
            }
            "Salir" { $form.Close() }
            default { Write-Host "Opción no válida: $opcion" }
        }
    }
}
