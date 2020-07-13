#!/bin/zsh
init ()
{
	export scopeold=""
	export contadorold=0
}

val ()
{
	sleep 0.20
	if [[ $scopeold != $(wmctrl -l) ]]; then
		export scopenew=$(wmctrl -l)
		export contador=$(wc -l <<< $scopenew)
		anal
	else
		val
	fi
}

anal ()
{
	unset labelsnew
	if [[ $contador -gt 1 ]]; then
		for (( i = 1; i <= $contador; i++ ))
		{
			if [[ ${${(f)scopenew}[$i]} != ${${(f)scopeold}[$i]} ]];then
				id=${${(f)scopenew}[$i][1,10]}
				indice=$(( ${${(f)scopenew}[$i][13]} + 1 ))
				eval workspace='$'w"$indice"
				title=${${(f)scopenew}[$i][15,-1]//$HOST/}
	    		validar.program
				eval icon='$'$program
				[[ -z $icon ]] && eval icon=$default
				export labelsnew[$i]="$indice $id $workspace $icon $program $title"
			else
				export labelsnew[$i]=$(grep ${${(f)scopenew}[$i][1,10]} $bd)
			fi
		}
		<<< ${(F)${(on)${labelsnew[@]}}} >| $bd
	  	modules
	elif [[ $contador -eq 1 ]]; then
			if [[ -n $scopenew && "${$(<$bd)[6,-1]}" == ${scopenew[15,-1]} && "$(( ${scopenew[13]} + 1 ))" == "${$(<$bd)[1]}" ]]; then
				export contadorold=$contador
				export scopeold=$scopenew
			elif [[ -z $scopenew ]]; then
				export contador=0
	      		modules
			else
				id=${scopenew[1,10]}
				indice=$(( ${scopenew[13]} + 1 ))
				eval workspace='$'w"$indice"
				title=${scopenew[15,-1]//$HOST/}
				validar.program
				eval icon='$'$program
				[[ -z $icon ]] && eval icon=$default
				<<< "$indice $id $workspace $icon $program $title" >| $bd
	      		modules
			fi
	else
		export contador=0
	  modules
	fi
}

validar.program ()
{
	case "$title" in
		*pulsemixer* ) program="pulsemixer";;
		*"- VIM"* ) program="vim";;
		*YouTube* ) program="YouTube";;
		*"- SpankBang -"* ) program="spankbang";;
		*ranger* ) program="ranger";;
		htop ) program="htop";;
		Netflix* ) program="Netflix";;
		WiFi* ) program="WiFiAudio";;
		* ) program=${$(xwinfo -i $id)//-/};;
	esac
}

modules ()
{
	for (( i=1; i <=$contador ; i++ ))
	{
	 	[[ $contador -gt 10 ]]&& \
	 		{polybar-msg hook x"$i" 3 >/dev/null
	 		sleep 0.05} || \
	 		{polybar-msg hook x"$i" 2 >/dev/null
	 		sleep 0.05}
	}

	for (( i=$(( $contador + 1 )); i <= $contadorold; i++ ))
	{
	 	polybar-msg hook x"$i" 1 >/dev/null
	 	sleep 0.05
	}

	export contadorold=$contador
	export scopeold=$scopenew
}
