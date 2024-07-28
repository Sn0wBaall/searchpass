#!/bin/bash

## COLOURS

greenColour="\e[0;32m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m"
blueColour="\e[0;34m"
yellowColour="\e[0;33m"
purpleColour="\e[0;35m"
turquoiseColour="\e[0;36m"
grayColour="\e[0;37m"

## BOLD COLOURS

BgreenColour="\e[1;32m"
BendColour="\033[0m\e[0m"
BredColour="\e[1;31m"
BblueColour="\e[1;34m"
ByellowColour="\e[1;33m"
BpurpleColour="\e[1;35m"
BturquoiseColour="\e[1;36m"
BgrayColour="\e[1;37m"

## Variables globales

rockyou_file="/opt/searchpass/rockyou_dictionary.txt"

banner="
██████╗ ██╗    ██╗███╗   ██╗███████╗██████╗ ██████╗ 
██╔══██╗██║    ██║████╗  ██║██╔════╝██╔══██╗╚════██╗   
██████╔╝██║ █╗ ██║██╔██╗ ██║█████╗  ██║  ██║  ▄███╔╝  [ by Sn0wBaall]
██╔═══╝ ██║███╗██║██║╚██╗██║██╔══╝  ██║  ██║  ▀▀══╝ 
██║     ╚███╔███╔╝██║ ╚████║███████╗██████╔╝  ██╗   
╚═╝      ╚══╝╚══╝ ╚═╝  ╚═══╝╚══════╝╚═════╝   ╚═╝   
"

## Funciones

function helpPanel(){
  clear
  echo -e "\n${yellowColour}$banner${endColour}"
  echo -e "\n${ByellowColour}[+]${endColour}${grayColour} Uso:${endColour}"
  echo -e "\t${BpurpleColour}d)${endColour}${grayColour} Descarga el diccionario${endColour}${blueColour} (Si es tu primera vez ejecutalo)${endColour}"
  echo -e "\t${BpurpleColour}e)${endColour}${grayColour} Busca la contraseña exacta en el${endColour}${turquoiseColour} rockyou${endColour}"
  echo -e "\t${BpurpleColour}c)${endColour}${grayColour} Busca coincidencias con la contraseña en el${endColour}${turquoiseColour} rockyou${endColour} "
  echo -e "\t${BpurpleColour}h)${endColour}${grayColour} Muestra este panel de ayuda${endColour}\n\n"
}

function exact(){
  clear
  echo -e "\n${yellowColour}$banner${endColour}"
  echo -ne "\n${ByellowColour}[+]${endColour}${grayColour} Introduce la contraseña que quieras buscar${endColour}${turquoiseColour} -->${endColour} "
  read -s passwd
  echo ""

  searchPasswd=$(cat $rockyou_file | grep -m 1 -w "^$passwd$")
  
  if [ $? -eq 0 ] ;then
    echo -e "\n${purpleColour}$passwd${endColour}"
  else
    echo -e "\n${BgreenColour}[+]${endColour}${grayColour} No hemos encntrado la contraseña :D${endColour}"
  fi
}

function coincidence(){ 
  clear
  echo -e "\n${yellowColour}$banner${endColour}"
  echo -ne "\n${ByellowColour}[+]${endColour}${grayColur} Introuduce la contraseña que quieras buscar${endColour}${turquoiseColour} -->${endColour} "
  read -s passwd
  echo ""

  searchPasswd=$(cat $rockyou_file | grep -i $passwd)
  countCoincidences=$(cat $rockyou_file | grep -c $passwd)
  
  if [ $? -eq 0 ];then
    echo -e "${grayColour}$searchPasswd${endColour}"
    echo -e "\n${ByellowColour}[!]${endColour}${grayColour} Se han encontrado${endColour}${purpleColour} $countCoincidences${endColour}${grayColour} coincidencias :O${endColour}"
  else
    echo -e "${BgreenColour}[+]${endColour}${grayColour} No hemos encontrado la contraseña :D${endColour}"
  fi
}

function dFiles(){
  clear
  echo -e "\n${yellowColour}$banner${endColour}"
  if [ ! -f $rockyou_file  ];then
    echo -ne "\n${BredColour}[!]${endColour}${grayColour} No cuentas con los archivos necesarios, quieres descargarlos?${endColour}${greenColour} [y]${endColour}${redColour} [n]${endColour} " & read options
    
    if [ $options = "y" ];then
      tput civis
      echo -e "\n${ByellowColour}[!]${endColour}${grayColour} Descargando archivos necesarios...${endColour}"
      sleep 1.5 
      search_rockyou=$(find / -type f -name rockyou.txt 2>/dev/null)
      cp $search_rockyou . 
      mv /opt/searchpass/rockyou.txt $rockyou_file
      echo -e "${greenColour}[+]${endColour}${grayColour} Listo todos los archivos han sido descargados${endColour}"
      sleep 1.5
      clear
      /opt/searchpass/./searchpass.sh
      tput cnorm
    elif [ $options = "n" ];then
      echo -e "\n\n${BredColour}[!] SALIENDO...${endColour}\n"
      exit 1
    fi
  else 
    echo -e "${BgreenColour}[!]${endColour}${grayColour} Tienes todo los archivos descargados :D${endColour}"
  fi
}

function ctrl_c(){
  echo -e "\n\n${BredColour}[!] SALIENDO...${endColour}\n"
  tput cnorm && exit 1 
}

trap ctrl_c INT
sleep 1


## Indicadores

declare -i parameter_counter=0

while getopts "cedh" arg; do
  case $arg in 
    c) let parameter_counter+=1;;
    e) let parameter_counter+=2;;
    d) let parameter_counter+=3;;
    h) ;;
  \?) clear && echo -e "\n${BredColour}[*]${endColour}${grayColour} Opcion invalida, porfavor ejecuta el script con el parametro${endColour}${prupleColour} -h${endColour}${grayColuor} para ver el panel de ayuda${endColour}\n" >&2; exit 1;;
  esac
done

## Condicionales

if [ $parameter_counter -eq 1 ]; then
  coincidence
elif [ $parameter_counter -eq 2 ]; then
  exact
elif [ $parameter_counter -eq 3 ]; then
  dFiles
else
  helpPanel
fi



