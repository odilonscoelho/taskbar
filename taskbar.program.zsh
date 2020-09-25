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
	scopeOldPosition=""
}

base ()
{
  	wmctrl -l >| $bs
  	xprop -root >| $bf
	scopeNew=$(< $bs)
	baseNew=$(< $bf)
}

main ()
{
	while true; do
		interval
		base
		if [[ $scopeOld != $scopeNew ]]; then
			contador=$(wc -l <<< "$scopeNew")
			controller="scope"
			analysis.scope
			analysis.base
			modules
		else
			controller="base"
			analysis.base
		fi
	done
}

analysis.scope ()
{
	unset labelsnew
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
		fi
	else
		contador=0
	fi
	scopeNewPosition="$(< $bd)"
}

analysis.exceptions ()
{
	case "$title" in
		*"YouTube - "* ) program="YouTube";;
		*"Facebook - "* ) program=facebook;;
		*"the home for *NIX"* ) program="reddit";;
		*"reddit:"* ) program="reddit";;
		*"LinkedIn - "* ) program="linkedin";;
		*"Twitter -"* ) program="twitter";;
		*"GitHub - "* || *"odilonscoelho"* ) program="github";;
		*pulsemixer* ) program="pulsemixer";;
		*"- VIM"* ) program="vim";;
		*ranger* ) program="ranger";;
		*htop* ) program="htop";;
		*Netflix* ) program="Netflix";;
		WiFi* ) program="WiFiAudio";;
		*"youtube-dl"* ) 
			title=$(awk '{print $2,$7,$8}' <<< $title)
			program=${$(xwinfo -i $id)//-/};;
		*"- SpankBang -"* || *"SpankBang:"* || *"SpankBanger:"* ) 
			program="spankbang"
			title="Private!";;
		*"- XVIDEOS.COM -"* ) 
			program="spankbang"
			title="Private!";;
		* ) program=${$(xwinfo -i $id)//-/};;
	esac
	title=${title//\-\ Google\ Chrome/}
	title=${title//\-\ qutebrowser/}
	title=${title//\(hdbkp\)\ \-\ Sublime\ Text\ \(UNREGISTERED\)/}
	title=${title//\-\ Sublime\ Text\ \(UNREGISTERED\)/}
}

analysis.base ()
{
	if [[ $baseOld != $baseNew || $controller == "scope" ]]; then
		workspaceOld=$workspaceFocusedOld
		workspaceFocused=$(( ${${(f)baseNew}[8]//\_NET\_CURRENT\_DESKTOP\(CARDINAL\) \= /} + 1 ))
		if [[ $workspaceFocusedOld != $workspaceFocused ]]; then
			eval workspace='$'W"$workspaceFocused"
			echo "%{T$fontWS}%{F$colorWSForeground}%{B$colorWSBackground} $workspace%{T- B- F-}" >| $bk
			polybar-msg hook ws 1 
		fi
		windowFocused="${${(f)baseNew}[1]//\_NET\_ACTIVE\_WINDOW\(WINDOW\)\:\ window\ id\ \# /}"
		case "$(wc -c <<< $windowFocused)" in
			9 ) windowFocused="${${windowFocused}//0x/0x00}";;
			10 ) windowFocused="${${windowFocused}//0x/0x0}";;
		esac
		if [[ $windowFocusedOld != $windowFocused && $controller == "base" ]]; then
			polybar-msg hook x"$xhook" $optnUnFocused	
			xhookWorkspace=$(grep "$windowFocused" $bd| cut -d ' ' -f 1)
			xhook=$(grep --line-number "$windowFocused" $bd| cut -d ':' -f 1)
			if [[ $xhookWorkspace == $workspaceFocused ]]; then
				polybar-msg hook x"$xhook" $optnFocused 
				interval.polybar 
			else
				polybar-msg hook x"$xhook" $optnUnFocused 
				interval.polybar 
			fi
		else
			xhookWorkspace=$(grep "$windowFocused" $bd| cut -d ' ' -f 1)
			xhook=$(grep --line-number "$windowFocused" $bd| cut -d ':' -f 1)
		fi
		windowFocusedOld=$windowFocused
		workspaceFocusedOld=$workspaceFocused
		baseOld=$baseNew
	fi
}

modules ()
{
	if [[ $contador -le $qtLabelMin ]]; then
		optnUnFocused=2
	else
		optnUnFocused=4
	fi
	if [[ $contador -gt 0 ]]; then
		for (( i=$(( $contador + 1 )); i <= $contadorOld; i++ ))
		{
		 	polybar-msg hook x"$i" $optnOff > /dev/null
		 	interval.polybar
		}
		for (( i=1; i <= $contador ; i++ ))
		{
			analysis.bool "$i"
			# Não houve alteração mas ela ganhou foco
			if [[ $alters == "false" && $focused == "true" && $focusedOld == "false" ]]; then
				polybar-msg hook x"$i" $optnFocused > /dev/null
				interval.polybar
			# Não houve alteração mas ela perdeu o foco
			elif [[ $alters == "false" && $focused == "false" && $focusedOld == "true" ]]; then
				polybar-msg hook x"$i" $optnUnFocused > /dev/null
				interval.polybar
			elif [[ $alters == "true" && $focused == "true" ]]; then
				polybar-msg	hook x"$i" $optnFocused > /dev/null
				interval.polybar
			elif [[ $alters == "true" && $focused == "false" ]]; then
				polybar-msg hook x"$i" $optnUnFocused > /dev/null
				interval.polybar
			fi
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
	scopeOldPosition=$scopeNewPosition
	[[ -n $xhook ]] && xhookOld=$xhook
}

analysis.bool ()
{
	if [[ $contador -gt 1 ]]; then
		[[ ${${(f)scopeOldPosition}[$1]} != ${${(f)scopeNewPosition}[$1]} ]] && alters="true" || alters="false"
		[[ $xhook == $1 ]] && focused="true" || focused="false"
		[[ $1 == $xhookOld ]] && focusedOld="true" || focusedOld="false"
		[[ $xhookWorkspace == $workspaceFocused ]] && workspaceFocusedStatus="true" || workspaceFocusedStatus="false"
	else
		[[ $scopeOldPosition != $scopeNewPosition ]] && alters="true" || alters="false"
		[[ $xhook == $1 ]] && focused="true" || focused="false"
		[[ $1 == $xhookOld ]] && focusedOld="true" || focusedOld="false"
		[[ $xhookWorkspace == $workspaceFocused ]] && workspaceFocusedStatus="true" || workspaceFocusedStatus="false"
	fi
}

analysis.NewVsOld ()
{
	titleOld=${${(s: :)${(f)scopeOldPosition}[$1]}[4,-1]}
	titleNew=${${(s: :)${(f)scopeNewPosition}[$1]}[4,-1]}
	idOld=${${(s: :)${(f)scopeOldPosition}[$1]}[1]}
	idNew=${${(s: :)${(f)scopeNewPosition}[$1]}[1]}
	workspaceOld=$(( ${${(s: :)${(f)scopeOldPosition}[$1]}[2]} + 1 ))
	workspaceNew=$(( ${${(s: :)${(f)scopeNewPosition}[$1]}[2]} + 1 ))

	titleOld=${scopeOldPosition[15,-1]//$HOST/}
	titleNew=${scopeNewPosition[15,-1]//$HOST/}
	idOld=${scopeOldPosition[1,10]}
	idNew=${scopeNewPosition[1,10]}
	workspaceOld=$(( ${scopeOldPosition[13]} + 1 ))
	workspaceNew=$(( ${scopeNewPosition[13]} + 1 ))
}
