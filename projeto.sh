#!/bin/bash

menup() {
	menu="$(zenity --width=600 --height=600 \
	--list --column="Escolha uma das opções abaixo:" \
	"Contatos" \
	"Paginas favoritas" \
	"Eventos" \
	"Auto desligar")"
	case $menu in
		"Contatos" )
			contatos
			;;
		"Paginas favoritas" )
			pgfavoritas
			;;
		"Eventos" )
			eventos
			;;
		"Auto desligar" )
			desligar
			;;
	esac
}

contatos() {
	contato="$(zenity --width=600 --height=600 \
	--list --column="Escolha uma das opções abaixo:" \
	"Adicionar contatos" \
	"Ver contatos")"
	if [ $? -eq 1 ];
	then
		menup
	else
		case $contato in
			"Adicionar contatos" )
				zenity --forms --title="Adicionar contatos" \
				--separator=" " \
				--add-entry="Nome" \
				--add-entry="Sobrenome" \
				--add-entry="Número" >> contatos.csv
			
				case $? in
						0 )
							zenity --info --text="Contato adicionado com sucesso"
							contatos
							;;
						1 )
							zenity --info --text="Cancelado"
							contatos
							;;
						-1 )
							zenity --info --text="Erro"
							contatos
							;;
				 esac
				 ;;
			"Ver contatos" )
				yad --text-info --width=500 --height=500 --title="Contatos" \
				--filename="contatos.csv" \
				--show-uri \
				--button='Voltar':0
				[ $? -eq 0 ] && [ contatos ]
				;;
		esac
	fi
}

pgfavoritas() {
	
	favoritos="$(zenity --width=600 --height=600 \
	--list --column="Escolha uma das opções abaixo:" \
	"Adicionar paginas" \
	"Ver paginas")"
	if [ $? -eq 1 ];
	then
		menup
	else
		case $favoritos in
			"Adicionar paginas" )
				zenity --forms --title="Adicionar paginas" \
				--separator=" " \
				--add-entry="Endereço" >> favoritos.txt
				case $? in
						0 )
							zenity --info --text="Pagina adicionado com sucesso"
							pgfavoritas
							;;
						1 )
							zenity --info --text="Cancelado"
							pgfavoritas
							;;
						-1 )
							zenity --info --text="Erro"
							pgfavoritas
							;;
				esac
				;;
			"Ver paginas" )
				sites=$(cat favoritos.txt)
				yad --width=600 --height=600 \
				--list --column="Escolha uma das opções abaixo:" \
				${sites[@]} \
				--button="Voltar":1 --button="Acessar paginas":0
				if [ $? -eq 1 ];
				then
					pgfavoritas
				else
					x-www-browser ${sites[@]}
				fi
				
				;;
		esac
		fi
}
eventos(){
	evento="$(zenity --width=600 --height=600 \
	--list --column="Escolha uma das opções abaixo:" \
	"Novo evento" \
	"Ver e editar evento")"
	if [ $? -eq 1 ];
	then
		menup
	else
		case $evento in
			"Novo evento" )
				zenity --forms --title="Novo evento" \
				--separator=" " \
				--add-entry="Nome evento" \
				--add-entry="Data" \
				--add-entry="Descrição" >> eventos.txt
				case $? in
						0 )
							zenity --info --text="Evento adicionado com sucesso"
							eventos
							;;
						1 )
							zenity --info --text="Cancelado"
							eventos
							;;
						-1 )
							zenity --info --text="Erro"
							eventos
							;;
				esac
				;;
			"Ver e editar evento" )
				CONTEUDO=$(yad --text-info --title="Agenda de Eventos" \
				--width=500 --height=500 \
				--filename="eventos.txt" \
				--editable \
				--show-uri \
				--button='Sair':1 --button='Salvar':0)
				if [ $? -eq 1 ];
				then
					eventos
				else
					yad --file --width='400' --height='350' --filename="/eventos.txt" --save --confirm-overwrite
					eventos
				fi
				;;
		esac
	fi
}

desligar(){
	yad --title='Aviso' --display=':0' \
	--image='preferences-system-time' --text='Sleep' \
	--button='Soneca':1 --button='Ok':0

	case $? in
		1) MIN=$( yad --entry --title='Adiar' --entry-label='Minutos' --entry-text='10' --numeric 0 59 1 --display=':0')
			[ $? -eq 0 ] &&  TEMPO=$(date --date "now +${MIN%%.*} min" | egrep -o '[0-9]{2}:[0-9]{2}') && at "$TEMPO" -f "$0" && exit 
		
			desligar
		;;
		252|0)
			yad --width=200 --height=200 \
			--text="Dormir agora?"
			if [ $? -eq 0 ];
			then
				poweroff
			else
				menup
			fi
			;;
	esac
}
menup

