#!/bin/zsh
init ()
{
	declare -x scopeold=""
	declare -x contadorold=0
	declare -x baseold=""
	declare -x workspace_focused_old=""
	declare -x window_focused_old=""
}

base ()
{
  wmctrl -l >| $bs
  xprop -root >| $bf
}

main ()
{
	interval
	base
	declare -x basenew=$(<$bf)
	declare -x scopenew=$(< $bs)

	if [[ $scopeold != $scopenew ]]; then
		declare -x contador=$(wc -l <<< $scopenew)
		analysis.scope
		main
	else
		analysis.base
		main
	fi
}

analysis.scope ()
{
	# Vai pegar qualquer alteração em wmctrl -l, apenas alterações de focus em que não houve nenhuma alteração,
	# de títulos ou workspaces, além obviamente da abertura e fechamento de janelas.

	unset labelsnew
	if [[ $contador -gt 1 ]]; then

		for (( i = 1; i <= $contador; i++ ))
		{
			if [[ ${${(f)scopenew}[$i]} != ${${(f)scopeold}[$i]} ]];then
				id=${${(f)scopenew}[$i][1,10]}
				indice=$(( ${${(f)scopenew}[$i][13]} + 1 ))
				eval workspace='$'w"$indice"
				title=${${(f)scopenew}[$i][15,-1]//$HOST/}
	    		analysis.exceptions
				eval icon='$'$program
				[[ -z $icon ]] && eval icon=$default
				declare -x labelsnew[$i]="$indice $id $workspace $icon $program $title"
			else
				declare -x labelsnew[$i]=$(grep ${${(f)scopenew}[$i][1,10]} $bd)
			fi
		}

		<<< ${(F)${(on)${labelsnew[@]}}} >| $bd

	elif [[ $contador -eq 1 ]]; then

		if [[ -n $scopenew && "${$(<$bd)[6,-1]}" == ${scopenew[15,-1]} && "$(( ${scopenew[13]} + 1 ))" == "${$(<$bd)[1]}" ]]; then
			export contador=0
		elif [[ -z $scopenew ]]; then
			export contador=0
		else
			id=${scopenew[1,10]}
			indice=$(( ${scopenew[13]} + 1 ))
			eval workspace='$'w"$indice"
			title=${scopenew[15,-1]//$HOST/}
			analysis.exceptions
			eval icon='$'$program
			[[ -z $icon ]] && eval icon=$default
			<<< "$indice $id $workspace $icon $program $title" >| $bd
		fi
		
	else
		declare -x contador=0
	fi
	modules
}

analysis.base ()
{
	# essa função não deve passar por modules
	# Caso não houve alteração em títulos, nem em quantidade de janelas abertas,
	# mas a base foi alterada o window_focused ou workspace_focused precisa ser atualizados.

	if [[ $baseold != $basenew ]]; then
		
		declare -x workspace_focused=$(( ${${(f)basenew}[8]//\_NET\_CURRENT\_DESKTOP\(CARDINAL\) \= /} + 1 ))
		
		if [[ $workspace_focused_old != $workspace_focused ]]; then
			eval workspace='$'W"$workspace_focused"
			<<< $workspace >| $bk
			polybar-msg hook ws 1 
		fi

		declare -x window_focused="${${${(f)basenew}[1]//\_NET\_ACTIVE\_WINDOW\(WINDOW\)\:\ window\ id\ \# /}//0x/0x0}"
		
		if [[ $(wc -c <<< $window_focused) -eq 10 ]]; then
			declare -x window_focused="$(sed 's/0x0/0x00/g' <<< $window_focused)"
		fi
		
		if [[ $window_focused_old != $window_focused ]]; then
			declare -x window_focused_old=$window_focused
		 	polybar-msg hook x"$xhook" 2 
			declare -x xhook=$(grep --line-number "$window_focused" $bd| cut -d ':' -f 1)
			polybar-msg hook x"$xhook" 3 
		fi

		declare -x workspace_focused_old=$workspace_focused
		declare -x baseold=$basenew
	fi
}

analysis.focused ()
{
	declare -x workspace_focused=$(( ${${(f)basenew}[8]//\_NET\_CURRENT\_DESKTOP\(CARDINAL\) \= /} + 1 ))
	
	if [[ $workspace_focused_old != $workspace_focused ]]; then
		eval workspace='$'W"$workspace_focused"
		<<< $workspace >| $bk
		polybar-msg hook ws 1 #&> /dev/null
	fi

	declare -x window_focused="${${${(f)basenew}[1]//\_NET\_ACTIVE\_WINDOW\(WINDOW\)\:\ window\ id\ \# /}//0x/0x0}"
	
	if [[ $(wc -c <<< $window_focused) -eq 10 ]]; then
		declare -x window_focused="${${window_focused}//0x0/0x00}"
	fi
	
	if [[ $window_focused_old != $window_focused ]]; then
		declare -x window_focused_old=$window_focused
		declare -x xhook=$(grep --line-number "$window_focused" $bd| cut -d ':' -f 1)
	elif [[ $window_focused_old == $window_focused && $workspace_focused_old != $workspace_focused ]]; then
		declare -x xhook=$(grep --line-number "$window_focused" $bd| cut -d ':' -f 1)
	fi

	declare -x workspace_focused_old=$workspace_focused
	declare -x baseold=$basenew
}

analysis.exceptions ()
{
	case "$title" in
		*"the home for *NIX"* ) program="reddit";;
		*"reddit:"* ) program="reddit";;
		*"In -"* ) program="linkedin";;
		*"Twitter -"* ) program="twitter";;
		*"GitHub - "* || *"odilonscoelho"* ) program="github";;
		*pulsemixer* ) program="pulsemixer";;
		*"- VIM"* ) program="vim";;
		*YouTube* ) program="YouTube";;
		*"- SpankBang -"* ) program="spankbang";;
		*"- XVIDEOS.COM -"* ) program="spankbang";;
		*ranger* ) program="ranger";;
		*htop* ) program="htop";;
		*Netflix* ) program="Netflix";;
		WiFi* ) program="WiFiAudio";;
		* ) program=${$(xwinfo -i $id)//-/};;
	esac
}

modules ()
{

	analysis.focused

	if [[ $contador -lt $contadorold ]]; then
		
		for (( i=1; i <= $xhook ; i++ ))
		{
	 		polybar-msg hook x"$i" 2 
		 	sleep 0.02
		}

		polybar-msg hook x"$xhook" 3 
		sleep 0.02

		for (( i=$(( $xhook + 1 )); i <= $contador ; i++ ))
		{
	 		polybar-msg hook x"$i" 2 
		 	sleep 0.02
		}
		
		for (( i=$(( $contador + 1 )); i <= $contadorold; i++ ))
		{
		 	polybar-msg hook x"$i" 1 
		 	sleep 0.02
		}

	else

		for (( i=1; i <= $xhook ; i++ ))
		{
	 		polybar-msg hook x"$i" 2 
		 	sleep 0.02
		}
		
		polybar-msg hook x"$xhook" 3 
		sleep 0.02

		for (( i=$(( $xhook + 1 )); i <= $contador ; i++ ))
		{
	 		polybar-msg hook x"$i" 2
		 	sleep 0.02
		}

	fi

	declare -x contadorold=$contador
	declare -x scopeold=$scopenew

}
