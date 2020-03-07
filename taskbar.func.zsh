#!/usr/bin/zsh
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
	printf '%2s %-20s %2s' \
	"$(awk -v linha=$1 'NR == linha {print "%{T2}"$4"%{T-}"}' $bd)" \
	"$(tail -c 20 <<< $(awk -v linha=$1 'NR == linha {print $6,$7,$8,$9}' $bd))" \
	%{T4}"$(awk -v linha=$1 ' NR == linha {print "%{T3}"$3"%{T-}"}' $bd)"
}

labeltest ()
{
	[[ "$(wc -l < $bd)" -gt 1 ]] && \
		printf '%-1s %-20s%1s' \
		%{T2}${${(f)"$(<$bd)"}[$1][16]}%{T-} \
		"$(tail -c 17 <<< ${${(f)"$(<$bd)"}[$1][18,60]})" \
		%{T3}${${(f)"$(<$bd)"}[$1][14]}%{T-} ||\
		printf '%-1s %-20s%1s' \
		%{T2}${${(f)"$(<$bd)"}[@][16]}%{T-} \
		"$(tail -c 17 <<< ${${(f)"$(<$bd)"}[@][18,60]})" \
		%{T3}${${(f)"$(<$bd)"}[@][14]}%{T-}
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

