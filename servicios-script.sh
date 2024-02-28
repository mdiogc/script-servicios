###########################################
#
# Autores: 
# Inna Vdovitsyna <vanadiumoxide39@gmail.com>
# Marina Giacomaniello Castro <mdiogcasko@gmail.com> 
#
# Nombre: servicios-script.sh
#
# Objetivo: Debe recibir un argumento (nombre del servicio), si el usuario no lo indica, se le pedirá luego por teclado hasta que especifique un nombre.
#

# Entradas: 
# Salidas: 
#
# Historial: 27/02/2024 #Primer esqueleto del ejercicio
#
###########################################

#Obtenemos el nombre del processo
srv=$1

while [ -z "$srv" ]
do
    read -p "Indique el nombre del servicio: " srv
done

#Comprobamos si el proceso indicado es un servicio
error=$( systemctl list-units --type=service | grep "$srv" )

if [ -z "$error" ]; then
    echo "$srv no es un servicio"
    exit 10
fi

#Comprobamos estado del servicio
status=$( systemctl status $srv)
active=$( systemctl is-active $srv )
enabled_masked=$( systemctl is-enabled $srv )

if [ "$enabled_masked" == "masked" ]; then
    masked="está enmascarado"
    enabled="está deshabilitado"
else 
    masked="no esta enmascarado"
    enabled=$( systemctl is-enabled $srv )
fi

#Mostramos estado del servicio
echo "$srv $active"
echo "$srv $enabled y $masked"
echo "$status"

#Configuramos opciones del menu que dependen del estado del servicio
if [ "$active" == "inactive" ] && [ "$masked" == "no esta enmascarado" ]; then
    to_active="Activar"
elif [ "$active" == "active" ]; then
    to_active="Desactivar"
else 
    to_active="No se puede activar processo enmascarado"
fi

if [ "$enabled" == "disabled" ]; then
    to_enable="Habilitar"
else
    to_enable="Deshabilitar"
fi

if [ "$masked" == "esta enmascarado" ]; then
    to_mask="Desenmascarar"
else
    to_mask="Enmascarar"
fi

#Mostramos opciones del menu
select option in "$to_active" "$to_enable" "$to_mask" "Configuracion" "Reiniciar(servicio activo)" "Reiniciar servicio(ultimo estado)" "Aplicar cambios(servicio activo)" "Aplicar cambios(ultimo estado del servicio)" "Configuracion del desarrallador" "Tiempo de carga del sistema" "Tiempo de carga del servicio" "Nivel de ejecucion" "Apagar equipo" "Reiniciar equipo" "Salir"
do
    case $option in
    "$to_active" | 1 ) 
        if [ "$to_active" == "Activar" ]; then
            sudo systemctl start $srv
        elif [ "$to_active" == "Desactivar" ]; then
            sudo systemctl stop $srv
        else
            echo $to_active
        fi
    ;;
    "$to_enable" | 2 )
        if [ "$to_enable" == "Dishabilitar" ]; then
            sudo systemctl disable $srv
        else
            sudo systemctl enable $srv
        fi
    ;;
    "$to_mask" | 3 )
        if [ "$to_mask" == "Desenmascarar" ]; then
            sudo systemctl unmask $srv
        else
            sudo systemctl mask $srv
        fi 
    ;;
    "Configuracion" | 4 )
        systemctl show $srv
    ;;
    "Reiniciar(servicio activo)" | 5 )
        sudo systemctl restart $srv && echo "Servicio $srv reiniciado dejándolo activo."
    ;;
    "Reiniciar servicio(ultimo estado)" | 6 )
        sudo systemctl try-restart $srv && echo "Servicio $srv reiniciado dejándolo en su último estado."
            ;;
    ;;
    "Aplicar cambios(servicio activo)" | 7 )
        sudo systemctl reload $srv  && echo "Cambios aplicados dejando el servicio activo."
            ;;
    ;;
    "Aplicar cambios(ultimo estado del servicio)" | 8 )
        sudo systemctl reload-or-restart $srv  && echo "Cambios aplicados dejando el servicio en su último estado."
            ;;
    ;;
    "Configuracion del desarrallador" | 9 )
        sudo systemctl preset $srv && echo "Configuración del desarrallador aplicada para el servicio $srv."
            ;;
    ;;
    "Tiempo de carga del sistema" | 10 )
        systemd-analyze
    ;;
    "Tiempo de carga del servicio" | 11 )
        systemd-analyze blame | grep "$srv"
    ;;
    "Nivel de ejecucion" | 12 )
        runlevel
    ;;
    "Apagar equipo" | 13 )
        sudo systemctl isolate runlevel0.target
    ;;
    "Reiniciar equipo" | 14 )
        sudo systemctl isolate runlevel6.target
    ;;
    "Salir" | 15 )
        exit
    esac 
done
