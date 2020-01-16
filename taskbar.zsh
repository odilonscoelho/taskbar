#!/bin/zsh

#Funções de serviço do programa
start () 
{
  while true; do
    zsh $path_proj/taskbar.program.zsh
    sleep 0.5
  done
}

restart () 
{
  pid_task=($(ps aux |grep -E '[p]rogram.zsh$|[t]askbar.zsh start$'|awk {'print $2'}))
  kill $pid_task[@]
  { start &> /dev/null } &
}

stop () 
{
  pid_task=($(ps aux |grep -E '[p]rogram.zsh$|[t]askbar.zsh start$'|awk {'print $2'}))
  kill $pid_task[@]
}

id () 
{
  awk '{print NR,$4,$5,"\t",$2}' $bd
}

#declara o path do projeto onde todos os demais scripts devem estar.
declare -x path_proj=$HOME/.config/polybar/taskbar
#declara o file que será escrito e consultado para manipular as ids das windows e desenho das labels.
declare -x bd=/tmp/taskbar
case $1 in
  start ) start &> /dev/null &;;
  stop ) stop;;
  restart ) restart;;
  id ) id;;
    * ) . $path_proj/taskbar.func.zsh; $@;;
esac	
