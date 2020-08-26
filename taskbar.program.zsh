#!/bin/zsh
init ()
{
	optnFocused=3
	optnOff=1
	scopeOld=""
	contadorOld=0
	baseOld=""
	workspaceFocusedOld=""
	windowFocusedOld=""
	xhookOld=""
}

base ()
{
  	{ wmctrl -l >| $bs } #|xargs
  	{ xprop -root >| $bf } #|xargs
	baseNew=$(< $bf)
	scopeNew=$(< $bs)
}

main ()
{
	interval
	base
	if [[ $scopeOld != $scopeNew ]]; then
		contador=$(wc -l <<< $scopeNew)
		controller="scope"
		analysis.scope
		analysis.base
		modules
		main
	else
		controller="base"
		analysis.base
		main
	fi
}

analysis.scope ()
{
	unset labelsnew
	unset alters
	if [[ $contador -gt 1 ]]; then
		for (( i = 1; i <= $contador; i++ ))
		{
			if [[ ${${(f)scopeNew}[$i]} != ${${(f)scopeOld}[$i]} ]];then
				id=${${(f)scopeNew}[$i][1,10]}
				indice=$(( ${${(f)scopeNew}[$i][13]} + 1 ))
				eval workspace='$'w"$indice"
				title=${${(f)scopeNew}[$i][15,-1]//$HOST/}
	    		analysis.exceptions
				eval icon='$'$program
				[[ -z $icon ]] && eval icon=$default
				labelsnew[$i]="$indice $id $workspace $icon $program $title"
				[[ -z $alters ]] && alters=("$i") || alters=("$alters" "$i")
			else
				labelsnew[$i]=$(grep ${${(f)scopeNew}[$i][1,10]} $bd)
			fi
		}
		<<< ${(F)${(on)${labelsnew[@]}}} >| $bd
	elif [[ $contador -eq 1 ]]; then
		if [[ -n $scopeNew && "${$(<$bd)[6,-1]}" == ${scopeNew[15,-1]} && "$(( ${scopeNew[13]} + 1 ))" == "${$(<$bd)[1]}" ]]; then
			contador=0
		elif [[ -z $scopeNew ]]; then
			contador=0
		else
			id=${scopeNew[1,10]}
			indice=$(( ${scopeNew[13]} + 1 ))
			eval workspace='$'w"$indice"
			title=${scopeNew[15,-1]//$HOST/}
			analysis.exceptions
			eval icon='$'$program
			[[ -z $icon ]] && eval icon=$default
			<<< "$indice $id $workspace $icon $program $title" >| $bd
			alters=("1")
		fi
	else
		contador=0
	fi
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
		*YouTube* ) program="YouTube"; title=${title//\-\ qutebrowser/};;
		*"- SpankBang -"* || *"SpankBang:"* || *"SpankBanger:"* ) program="spankbang"; title="Private!";;
		*"- XVIDEOS.COM -"* ) program="spankbang"; title="Private!";;
		*ranger* ) program="ranger";;
		*htop* ) program="htop";;
		*Netflix* ) program="Netflix";;
		WiFi* ) program="WiFiAudio";;
		*"(hdbkp) - Sublime Text (UNREGISTERED)"* ) program=${$(xwinfo -i $id)//-/}; title=${title//\(hdbkp\)\ \-\ Sublime\ Text\ \(UNREGISTERED\)/};;
		*"- Sublime Text (UNREGISTERED)"* ) program=${$(xwinfo -i $id)//-/}; title=${title//\-\ Sublime\ Text\ \(UNREGISTERED\)/};;
		*"- qutebrowser"* ) program=${$(xwinfo -i $id)//-/}; title=${title//\-\ qutebrowser/};;
		*"- Google Chrome"* ) program=${$(xwinfo -i $id)//-/}; title=${title//\-\ Google\ Chrome/};;
		* ) program=${$(xwinfo -i $id)//-/};;
	esac
}

analysis.base ()
{
	if [[ $baseOld != $baseNew || $controller == "scope" ]]; then
		workspaceOld=$workspaceFocusedOld
		workspaceFocused=$(( ${${(f)baseNew}[8]//\_NET\_CURRENT\_DESKTOP\(CARDINAL\) \= /} + 1 ))
		if [[ $workspaceFocusedOld != $workspaceFocused ]]; then
			eval workspace='$'W"$workspaceFocused"
			<<< $workspace >| $bk
			polybar-msg hook ws 1 
		fi
		windowFocused="${${(f)baseNew}[1]//\_NET\_ACTIVE\_WINDOW\(WINDOW\)\:\ window\ id\ \# /}"
		case "$(wc -c <<< $windowFocused)" in
			9 ) windowFocused="${${windowFocused}//0x/0x00}";;
			10 ) windowFocused="${${windowFocused}//0x/0x0}";;
		esac
		if [[ $windowFocusedOld != $windowFocused ]]; then
			if [[ $controller == "base" ]]; then
				polybar-msg hook x"$xhook" 2	
				xhookWorkspace=$(grep "$windowFocused" $bd| cut -d ' ' -f 1)
				xhook=$(grep --line-number "$windowFocused" $bd| cut -d ':' -f 1)
				if [[ $xhookWorkspace == $workspaceFocused ]]; then
					polybar-msg hook x"$xhook" 3
					interval.polybar 
				else
					polybar-msg hook x"$xhook" 2 
					interval.polybar 
				fi	
			else
				xhook=$(grep --line-number "$windowFocused" $bd| cut -d ':' -f 1)
				xhookWorkspace=$(grep "$windowFocused" $bd| cut -d ' ' -f 1)
			fi
		else
		 	if [[ $controller == "base" ]]; then
				xhook=$(grep --line-number "$windowFocused" $bd| cut -d ':' -f 1)
				xhookWorkspace=$(grep "$windowFocused" $bd| cut -d ' ' -f 1)
					if [[ $xhookWorkspace == $workspaceFocused ]]; then
						polybar-msg hook x"$xhook" $optnFocused
						interval.polybar 
					else
						polybar-msg hook x"$xhook" $optnUnFocused 
						interval.polybar 
					fi
		 	elif [[ $controller == "scope" ]]; then
				xhookWorkspace=$(grep "$windowFocused" $bd| cut -d ' ' -f 1)
				xhook=$(grep --line-number "$windowFocused" $bd| cut -d ':' -f 1)
		 	fi
		fi
		windowFocusedOld=$windowFocused
		workspaceFocusedOld=$workspaceFocused
		baseOld=$baseNew
	fi
}

modules ()
{
	if [[ $contador -le 8 ]]; then
		optnUnFocused=2
	else
		optnUnFocused=4
	fi
	if [[ $contador -gt 0 ]]; then
		[[ -z $xhook ]] && Continue=$contador || Continue=$xhook
		if [[ $contador -lt $contadorOld ]]; then
			for (( i=$(( $contador + 1 )); i <= $contadorOld; i++ ))
			{
			 	polybar-msg hook x"$i" $optnOff > /dev/null
			 	interval.polybar
			}
		fi
		for (( i=1; i < $Continue ; i++ ))
		{
	 		polybar-msg hook x"$i" $optnUnFocused > /dev/null
		 	interval.polybar 
		}
		if [[ $xhookWorkspace == $workspaceFocused ]]; then
			polybar-msg hook x"$Continue" "$optnFocused"
			interval.polybar 
		elif [[ $xhookWorkspace != $workspaceFocused ]]; then
			polybar-msg hook x"$Continue" "$optnUnFocused" 
			interval.polybar 
		fi
		for (( i=$(( $Continue + 1 )); i <= $contador ; i++ ))
		{
			polybar-msg hook x"$i" $optnUnFocused > /dev/null
			interval.polybar 
		}
	else
		for (( i=1; i <= $contadorOld; i++ ))
		{
		 	polybar-msg hook x"$i" $optnOff > /dev/null 
		 	interval.polybar
		}
	fi
	contadorOld=$contador
	scopeOld=$scopeNew
	[[ -n $xhook ]] && xhookOld=$xhook
}

create.vars ()
{
	if [[ $contador -gt 1 ]]; then
		titleOld=${${(s: :)${(f)scopeOld}[$1]}[4,-1]}
		titleNew=${${(s: :)${(f)scopeNew}[$1]}[4,-1]}
		idOld=${${(s: :)${(f)scopeOld}[$1]}[1]}
		idNew=${${(s: :)${(f)scopeNew}[$1]}[1]}
		workspaceOld=$(( ${${(s: :)${(f)scopeOld}[$1]}[2]} + 1 ))
		workspaceNew=$(( ${${(s: :)${(f)scopeNew}[$1]}[2]} + 1 ))
	else
		titleOld=${scopeOld[15,-1]//$HOST/}
		titleNew=${scopeNew[15,-1]//$HOST/}
		idOld=${scopeOld[1,10]}
		idNew=${scopeNew[1,10]}
		workspaceOld=$(( ${scopeOld[13]} + 1 ))
		workspaceNew=$(( ${scopeNew[13]} + 1 ))
	fi
}
