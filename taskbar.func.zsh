#!/bin/zsh
foco () 
{
	wmctrl -i -a \
	"$(awk -v linha=$1 'NR == linha {print $2}' /tmp/taskbar)"
}

close () 
{
	wmctrl -i -c \
	"$(awk -v linha=$1 'NR == linha {print $2}' /tmp/taskbar)"
}

fullscreen () 
{
	wmctrl -i -r \
	"$(awk -v linha=$1 'NR == linha {print $2}' /tmp/taskbar)" \
	-b toggle,fullscreen
}

monitores () 
{
	xrandr|grep -E "'[A-Z]'|connected "|grep -v "disconnect"|awk {'print $1'}|sed -n $1'p'
}

#BSPC
labelmin () 
{
	printf '%4s' "\
	$(awk {'print "%{T2}"$4"%{T-}"'} <<< $(sed -n $1'p' $bd)) \
	%{T4}$(awk {'print "%{T3}"$3"%{T-}"'} <<< $(sed -n $1'p' $bd))\
	"
}

label () 
{
	printf '%1s%18s%1s' \
	"$(awk -v linha=$1 'NR == linha {print "%{T2}"$4"%{T-}"}' $bd)" \
	"$(tail -c 18 <<< $(awk -v linha=$1 'NR == linha {print $5,$6,$7,$8}' $bd))" \
	%{T4}"$(awk -v linha=$1 ' NR == linha {print "%{T3}"$3"%{T-}"}' $bd)"
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

#i3
labeli3 () 
{
	printf '%18s' "\
	$(sed -n $1'p' $bd|awk {'print "%{T2}"$3"%{T-}"'}) \
	$(printf '%17s' "$(sed -n $1'p' $bd|awk {'print $4,$5,$6,$7'}|tail -c 17)") \
	$(printf '%-1s' "%{T1}%{T-}")\
	"
}

i3floating () 
{
	i3-msg \
	'[id='$(sed -n $1'p' $bd |awk {'print $2'})']' \
	floating toggle
}
