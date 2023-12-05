# MantenimientoPC.ps1

# Configuración de la codificación para mostrar caracteres especiales
$OutputEncoding = [System.Text.Encoding]::UTF8

# Cargar funciones desde GitHub
iex (iwr -useb https://raw.githubusercontent.com/thedragon40/Mante/main/Funciones.ps1).Content

# Cargar interfaz desde GitHub
iex (iwr -useb https://raw.githubusercontent.com/thedragon40/Mante/main/Interfaz.ps1).Content

# Ejecución del programa
Mostrar-Interfaz
