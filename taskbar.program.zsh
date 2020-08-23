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
		declare -x controller="scope"
		analysis.scope
		main
	else
		declare -x controller="base"
		analysis.base
		main
	fi
}

analysis.scope ()
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
			declare -x contador=0
		elif [[ -z $scopenew ]]; then
			declare -x contador=0
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

analysis.base ()
{

	if [[ $baseold != $basenew || $controller == "scope" ]]; then
		
		declare -x workspace_focused=$(( ${${(f)basenew}[8]//\_NET\_CURRENT\_DESKTOP\(CARDINAL\) \= /} + 1 ))
		
		if [[ $workspace_focused_old != $workspace_focused ]]; then
			declare -x statusWorkspace="att"
			eval workspace='$'W"$workspace_focused"
			<<< $workspace >| $bk
			polybar-msg hook ws 1 
		else
			declare -x statusWorkspace="default"
		fi

		declare -x window_focused="${${(f)basenew}[1]//\_NET\_ACTIVE\_WINDOW\(WINDOW\)\:\ window\ id\ \# /}"
		
		case "$(wc -c <<< $window_focused)" in
			9 ) declare -x window_focused="${${window_focused}//0x/0x00}";;
			10 ) declare -x window_focused="${${window_focused}//0x/0x0}";;
		esac

		if [[ $window_focused_old != $window_focused ]]; then
		
			if [[ $controller == "base" ]]; then
		 		polybar-msg hook x"$xhook" 2
		 		sleep 0.02
				declare -x xhook=$(grep --line-number "$window_focused" $bd| cut -d ':' -f 1)
				declare -x xhookWorkspace=$(grep "$window_focused" $bd| cut -d ' ' -f 1)
				if [[ $xhookWorkspace == $workspace_focused ]]; then
					polybar-msg hook x"$xhook" 3 
					sleep 0.02
				else
					polybar-msg hook x"$xhook" 2 
					sleep 0.02
				fi
			else
				declare -x xhook=$(grep --line-number "$window_focused" $bd| cut -d ':' -f 1)
				declare -x xhookWorkspace=$(grep "$window_focused" $bd| cut -d ' ' -f 1)
			fi

		else
		 		
		 	if [[ $controller == "base" ]]; then
				
				declare -x xhook=$(grep --line-number "$window_focused" $bd| cut -d ':' -f 1)
		 		
		 		if [[ $xhookWorkspace -eq $workspace_focused ]]; then
			 		polybar-msg hook x"$xhook" 3
				else
			 		polybar-msg hook x"$xhook" 2
		 		fi
		 	elif [[ $controller == "scope" ]]; then
				declare -x xhook=$(grep --line-number "$window_focused" $bd| cut -d ':' -f 1)
		 	fi

		fi

		declare -x window_focused_old=$window_focused
		declare -x workspace_focused_old=$workspace_focused
		declare -x baseold=$basenew

	fi

}

modules ()
{

	analysis.base

	if [[ $contador -gt 0 ]]; then

		if [[ $contador -lt $contadorold ]]; then
			
			for (( i=1; i <= $xhook ; i++ ))
			{
		 		polybar-msg hook x"$i" 2 
			 	sleep 0.02
			}

			if [[ $xhookWorkspace == $workspace_focused ]]; then
				polybar-msg hook x"$xhook" 3 
				sleep 0.02
			else
				polybar-msg hook x"$xhook" 2 
				sleep 0.02
			fi

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
	else

		for (( i=1; i <= $contadorold; i++ ))
		{
		 	polybar-msg hook x"$i" 1 
		 	sleep 0.02
		}

	fi
	
	declare -x contadorold=$contador
	declare -x scopeold=$scopenew

}
