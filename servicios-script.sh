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

srv=$1

while [ -z "$srv" ]
do
    read -p "Indique el nombre del servicio: " srv
done

status=$( systemctl status $srv )
active=$( systemctl is-active $srv )
enabled_masked=$( systemctl is-enabled $srv )

if [ "$status" =~ 'found.$' ]; then
    echo "$srv no es un servicio"
    exit 10
fi

if [ "$enabled_masked" = "masked" ]; then
    masked="esta enmascarado"
    enabled="esta deshabilitado"
else 
    masked="no esta enmascarado"
    enabled=$( systemctl is-enabled $srv )
fi

echo "$srv $active"
echo "$srv $enabled y $masked"
echo "$status"
