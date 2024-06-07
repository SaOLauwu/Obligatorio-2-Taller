#!/bin/bash

# Creado por: Tomas Arregui 342914, Santiago Vellozo 342308, Santiago Alvarez Olivera 333568

# Decidimos darles valores iniciales a las variables utilizadas para la consulta para evitar errores.

inicial="a"
final="s"
contenida="n"
vocal="a"
declare usuario # Con declare creamos la variable usuario sin ningún dato para que se almacene el usuario que inicie sesión


login(){
    login=false # Variable booleana que verifica que el inicio de sesión sea correcto.
    while [ "$login" = false ] # Mientras que la variable sea false (el inicio de sesión sea incorrecto) se repetirá lo siguiente
    do
      echo "Bienvenido al sistema, ahora inicie sesión."
      echo "Usuario:"
      read intento # guarda en la variable intento lo que ingrese el usuario
      echo "Ingrese su contraseña"
      read -s pass # guarda en la variable pass lo que ingrese el usuario pero esto no se muestra en pantalla gracias al -s
      if grep -q "^$intento:$pass$" usuarios.txt; then # si encuentra en el archivo usuarios.txt el usuario ingresado : contraseña ingresada realiza lo siguiente
         login=true # login correcto, lo ponemos en true
	 usuario="$intento" # guardamos en la variable usuario lo que ingreso el usuario
      else
	 clear # limpiamos la terminal
         echo "Inicio de sesion incorrecto."
      fi
    done
	clear
        echo "Inicio de sesión realizado con éxito"
        echo "Presione enter para acceder al sistema..."
        read
        menu # llamamos a la funcion menu
}

listarUsuarios(){
	echo "Usuarios registrados:"
    	cut -d':' -f1 ./usuarios.txt # busca en el archivo usuarios.txt y cuando encuentra el caracter : lo separa y muestra la primer columna
}

altaUsuarios(){
	echo "Ingrese el nombre del usuario a crear"
	read usu
	existe=false  # Variable para controlar si el usuario ya existe
	while IFS= read -r linea # lee linea por linea y guarda esa linea en la variable linea
	do
		existente=$(echo "$linea" | cut -d ':' -f1) # guarda en la variable existente el usuario almacenado en la linea actual
		if [ "$usu" = "$existente" ] # si el usuario ingresado por el usuario es igual al de la linea actual (por lo tanto ya existe un usuario con ese nombre)
		then
			echo "Ya existe un usuario con ese nombre, elija otro"
			existe=true  # Si el usuario existe, establece la variable a true
			break  # Salir del bucle ya que no necesitamos buscar más usuarios
		fi
	done < usuarios.txt # le dice al while que debe fijarse en el archivo usuarios.txt

	# Solo ejecutar si el usuario no existe
	if [ "$existe" = false ]
	then
		echo "Ingrese la contraseña del usuario a crear"
		read pass
		echo "$usu:$pass" >> usuarios.txt # le agrega al archivo usuarios.txt el usuario y contraseña ingresados
		echo "Usuario $usu creado con éxito"
	fi
}


letraInicio(){
   	 echo "Ingrese la letra que sera inicial"
	read ini
	inicial="$ini" # le asigna a la variable inicial lo que el usuario acaba de ingresar
	echo "Letra $inicial asignada como letra inicial"
}

letraFin(){
	echo "Ingrese la letra que sera final"
	read fin
	final="$fin" # le asigna a la variable final lo que el usuario acaba de ingresar
	echo "Letra $final asignada como letra final"
}

letraContenida(){
	    echo "Ingrese la letra que sera contenida"
	read co
	contenida="$co" # le asigna a la variable contenida lo que el usuario acaba de ingresar
	echo "Letra $contenida asignada como letra contenida"
}

consultar(){
	    busqueda=$(grep -E "^$inicial.*$contenida.*$final$" ./diccionario.txt) # guarda en busqueda lo resultante del comando grep que busca al inicio de la linea la letra inicial, otras letras, la letra contenida, otras letras y al final de la linea la letra final
	    totalCumplen=$(grep -Ec "^$inicial.*$contenida.*$final$" ./diccionario.txt) # lo mismo que el anterior pero guarda la cantidad de palabras que cumplen
	    totalDiccionario=$(wc -l < diccionario.txt) #guarda la cantidad de lineas en diccionario.txt
	    fecha=$(date "+%Y-%m-%d") # guarda la fecha actual en formato año mes dia
	    porcentaje=$(echo "scale=2; $totalCumplen * 100 / $totalDiccionario" | bc) # calcula porcentaje de las palabras que cumplen en base a todas las palabras del diccionario

		# ingresa todos los datos a registro.txt

	    echo "Registro del dia $fecha ejecutado por $usuario" >> registro.txt 
            echo "" >> registro.txt
	    echo "$busqueda" >> registro.txt
	    echo "" >> registro.txt
	    echo "La cantidad de palabras del diccionario son: $totalDiccionario" >> registro.txt
	    echo "La cantidad de palabras que cumplen la condicion son: $totalCumplen" >> registro.txt
	    echo "El porcentaje de palabras que cumplen con respecto al total del diccionario son de $porcentaje%" >> registro.txt
	    echo "----------------------------------------------------------" >> registro.txt
	    echo "" >> registro.txt

	    echo "Las palabras que coinciden con su busqueda son:"
	    echo "$busqueda" # muestra las palabras que coinciden con los parámetros

}

vocal(){
	echo "Ingrese la letra que sera vocal"
	read vo
	vocal="$vo" # le asigna a la variable vocal lo que el usuario acaba de ingresar
	echo "Letra $vocal asignada como letra vocal"
}

consultarVocal(){

	# con el switch se fija que vocal es, o si no lo es, y dependiendo de eso busca las palabras que no contengan las demás vocales.

	case $vocal in
		"a")
			echo "Palabras del diccionario que contienen solo la vocal $vocal:"
			grep -i "^[^eiou]*$vocal[^eiou]*$" diccionario.txt
			;;
		"e")
			echo "Palabras del diccionario que contienen solo la vocal $vocal:"
			grep -i "^[^aiou]*$vocal[^aiou]*$" diccionario.txt
			;;
		"i")
			echo "Palabras del diccionario que contienen solo la vocal $vocal:"
			grep -i "^[^aeou]*$vocal[^aeou]*$" diccionario.txt
			;;
		"o")
			echo "Palabras del diccionario que contienen solo la vocal $vocal:"
			grep -i "^[^aeiu]*$vocal[^aeiu]*$" diccionario.txt
			;;
		"u")
			echo "Palabras del diccionario que contienen solo la vocal $vocal:"
			grep -i "^[^aeio]*$vocal[^aeio]*$" diccionario.txt
			;;
		*)
			echo "La letra configurada como vocal no es una vocal."
	esac
}

algoritmo1(){
	echo "Cuantos datos quiere ingresar?"
	read cant
	suma=0
	minimo=9999999999999999
	maximo=-9999999999999999

	for ((i=1; i<=$cant; i++)) # repite desde el numero 1 hasta el numero ingresado, sumando uno en cada iteración
	do
		echo "Ingrese el dato $i"
		read dato

		suma=$((suma + dato)) # le suma el dato ingresado a la variable suma

		if [ $dato -lt $minimo ]; then # si el dato es menor a la variable minimo
			minimo=$dato
		fi

		if [ $dato -gt $maximo ]; then # si el dato es mayor a la variable maximo
			maximo=$dato
		fi
	done

	promedio=$(echo "scale=2; $suma/$cant" | bc) # guarda el promedio de los datos
	echo "El promedio de los datos es: $promedio"
	echo "El menor dato es: $minimo"
	echo "El mayor dato ingresado es: $maximo"

}

algoritmo2(){
	echo "Ingrese una palabra para verificar si es capicua:"
	read palabraa 

	palabra=$(echo "$palabraa" | tr '[:upper:]' '[:lower:]') # guarda en la variable palabra lo que acaba de ingresar el usuario pero pasado a minusculas

	palabrarev=$(echo "$palabra" | rev) # guarda en la variable palabrarev la palabra en minusculas pero al reves

	if [ "$palabra" = "$palabrarev" ]; then # si palabra y palabrarev son iguales
		echo "$palabra es capicua."
	else
		echo "$palabra no es capicua."
	fi
}

menu(){
opcion=0
while [ "$opcion" != "11" ] # mientras que la opcion elegida por el usuario sea distinta de 11, la cual es la de salir
do
	clear
    	echo "Bienvenido al sistema $usuario. Escoja una opcion:"
    	echo "1- Listar usuarios registrados"
    	echo "2- Alta de usuario"
    	echo "3- Configurar letra de inicio"
    	echo "4- Configurar letra de fin"
    	echo "5- Configurar letra contenida"
    	echo "6- Consultar diccionario"
    	echo "7- Configurar vocal"
    	echo "8- Listar palabras con la vocal configurada"
    	echo "9- Algoritmo 1"
    	echo "10- Algoritmo 2"
    	echo "11- Salir"
    	echo "Su opcion:"
    	read opcion

    	case $opcion in # dependiendo de la opción elegida realiza diferentes acciones
        	"1")
            		listarUsuarios
            		echo "Presione enter para continuar..."
            		read
			;;
        	"2")
            		altaUsuarios
            		echo "Presione enter para continuar..."
            		read
			;;
        	"3")
            		letraInicio
            		echo "Presione enter para continuar..."
            		read
			;;
        	"4")
            		letraFin
            		echo "Presione enter para continuar..."
            		read
			;;
        	"5")
            		letraContenida
            		echo "Presione enter para continuar..."
            		read
			;;
        	"6")
            		consultar
            		echo "Presione enter para continuar..."
            		read
			;;
        	"7")
			vocal
            		echo "Presione enter para continuar..."
            		read
			;;
        	"8")
            		consultarVocal
            		echo "Presione enter para continuar..."
            		read
			;;
       		"9")
           		 algoritmo1
            		echo "Presione enter para continuar..."
			read
            		;;
        	"10")
            		algoritmo2
            		echo "Presione enter para continuar..."
            		read
			;;
        	"11")
            		echo "Adios..."
            		sleep 1
            		;;
        	*)
            		echo "Opción no reconocida. Intente de nuevo."
            		read
            		;;
    	esac
done
}


login # llama la función login
