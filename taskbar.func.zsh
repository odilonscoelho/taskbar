#!/bin/zsh

foco ()
{
	wmctrl -i -a \
	"$(awk -v linha=$1 'NR == linha {print $2}' $bd)"
}

close ()
{
	wmctrl -i -c \
	"$(awk -v linha=$1 'NR == linha {print $2}' $bd)"
}

fullscreen ()
{
	wmctrl -i -r \
	"$(awk -v linha=$1 'NR == linha {print $2}' $bd)" \
	-b toggle,fullscreen
}

# bspwm
labelmin ()
{
	printf '%4s' "\
	$(awk {'print "%{T2}"$4"%{T-}"'} <<< $(sed -n $1'p' $bd)) \
	%{T4}$(awk {'print "%{T3}"$3"%{T-}"'} <<< $(sed -n $1'p' $bd)) \
	"
}

labelfocused ()
{
	labelSize=$(($sizeLabel+16))
	printf '%-30s %-'$labelSize's %16s' \
	"%{B$colorBackgroundFocused}%{F$colorIconProgramFocused}%{T$fontProgram} $(awk -v linha=$1 'NR == linha {print $4}' $bd)" \
	"%{F$colorForegroundFocused}%{T$fontLabelFocused}$(tail -c $sizeLabel <<< $(awk -v linha=$1 'NR == linha {print $6,$7,$8,$9,$10,$11}' $bd))" \
	"%{F$colorIconWorkspaceFocused}%{T$fontWorkspace}$(awk -v linha=$1 ' NR == linha {print $3}' $bd) %{F- B-}"
}


label ()
{
	labelSize=$(($sizeLabel+16))
	printf '%-30s %-'$labelSize's %16s' \
	"%{B$colorBackgroundUnFocused}%{F$colorIconProgramUnFocused}%{T$fontProgram} $(awk -v linha=$1 'NR == linha {print $4}' $bd)" \
	"%{F$colorForegroundUnFocused}%{T$fontLabelUnFocused}$(tail -c $sizeLabel <<< $(awk -v linha=$1 'NR == linha {print $6,$7,$8,$9,$10,$11}' $bd))" \
	"%{F$colorIconWorkspaceUnFocused}%{T$fontWorkspace}$(awk -v linha=$1 ' NR == linha {print $3}' $bd) "
}

tiled ()
{
	bspc node \
	$(awk -v linha=$1 'NR == linha {print $2}' $bd) \
	-t tiled
}

floating ()
{
	bspc node \
	$(awk -v linha=$1 'NR == linha {print $2}' $bd) \
	-t floating
}

# i3wm
labeli3 ()
{
	labelSize=$(($sizeLabel+16))
	printf '%-30s %-'$labelSize's %16s' \
	"%{B$colorBackgroundUnFocused}%{F$colorIconProgramUnFocused}%{T$fontProgram} $(awk -v linha=$1 'NR == linha {print $4}' $bd)" \
	"%{F$colorForegroundUnFocused}%{T$fontLabelUnFocused}$(tail -c $sizeLabel <<< $(awk -v linha=$1 'NR == linha {print $6,$7,$8,$9,$10,$11}' $bd))" \
	"%{F$colorIconWorkspaceUnFocused}%{T$fontWorkspace}$(awk -v linha=$1 ' NR == linha {print $3}' $bd) "
}

labeli3focused ()
{
	labelSize=$(($sizeLabel+16))
	printf '%-30s %-'$labelSize's %16s' \
	"%{B$colorBackgroundFocused}%{F$colorIconProgramFocused}%{T$fontProgram} $(awk -v linha=$1 'NR == linha {print $4}' $bd)" \
	"%{F$colorForegroundFocused}%{T$fontLabelFocused}$(tail -c $sizeLabel <<< $(awk -v linha=$1 'NR == linha {print $6,$7,$8,$9,$10,$11}' $bd))" \
	"%{F$colorIconWorkspaceFocused}%{T$fontWorkspace}$(awk -v linha=$1 ' NR == linha {print $3}' $bd) %{F- B-}"
}


i3floating ()
{
	i3-msg \
	'[id='$(sed -n $1'p' $bd |awk {'print $2'})']' \
	floating toggle
}

# WS Workspaces

labelws ()
{
	</tmp/taskbar.workspace
}