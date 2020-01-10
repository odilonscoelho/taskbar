#!/bin/zsh
foco () {wmctrl -i -a "$(sed -n $1'p' $bd |awk {'print $2'})"}
close () {wmctrl -i -c "$(sed -n $1'p' $bd |awk {'print $2'})"}
fullscreen () {wmctrl -i -r "$(sed -n $1'p' $bd |awk {'print $2'})" -b toggle,fullscreen}
monitores () {xrandr|grep -E "'[A-Z]'|connected "|grep -v "disconnect"|awk {'print $1'}|sed -n $1'p'}

#BSPC
labelmin () {printf '%4s' "$(printf '%-1s' "%{T1}%{T-}") $(sed -n $1'p' $bd|awk {'print "%{T2}"$3"%{T-}"'})"}
label () {printf '%18s' "$(sed -n $1'p' $bd|awk {'print "%{T2}"$4"%{T-}"'}) $(printf '%17s' "$(sed -n $1'p' $bd|awk {'print $5,$6,$7,$8'}|tail -c 17)") %{T4}$(sed -n $1'p' $bd|awk {'print "%{T3}"$3"%{T-}"'})"}
tiled () {bspc node $(sed -n $1'p' $bd |awk {'print $2'}) -t tiled}
floating () {bspc node $(sed -n $1'p' $bd |awk {'print $2'}) -t floating}
sticky () {bspc node $(sed -n $1'p' $bd |awk {'print $2'}) --flag sticky=on}
stickyoff () {bspc node $(sed -n $1'p' $bd |awk {'print $2'}) --flag sticky=off}
xterm.sticky () {{nohup xterm -title "Xterm Sticky ON" -geometry 100x1+0+2060 &>/dev/null &}; sleep 1 && bspc node --flag sticky=on}

#i3
labeli3 () {printf '%18s' "$(sed -n $1'p' $bd|awk {'print "%{T2}"$3"%{T-}"'}) $(printf '%17s' "$(sed -n $1'p' $bd|awk {'print $4,$5,$6,$7'}|tail -c 17)") $(printf '%-1s' "%{T1}%{T-}")"}
i3floating () {i3-msg '[id='$(sed -n $1'p' $bd |awk {'print $2'})']' floating toggle}


#funções de serviços pro programa
start () {
while true; do
  zsh $path_proj/taskbar.program.zsh
  sleep 0.5
done
}

restart () {
pid_task=($(ps aux |grep -E '[p]rogram.zsh$|[t]askbar.zsh start$'|awk {'print $2'}))
kill $pid_task[@]
start
}

stop () {
pid_task=($(ps aux |grep -E '[p]rogram.zsh$|[t]askbar.zsh start$'|awk {'print $2'}))
kill $pid_task[@]
}


