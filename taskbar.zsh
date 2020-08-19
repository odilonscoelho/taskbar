#!/bin/zsh
start ()
{
  . $path_proj/taskbar.program.zsh
  . $path_proj/taskbar.icons.zsh
  init
  while true ;do
    $(execucaotaskbar)
    sleep 0.25
  done
  start
}

execucaotaskbar ()
{
  val
  execucaotaskbar
}

stop ()
{
  pid_task=($(ps aux |grep -E '[t]askbar.zsh start$|[/h]ome/losao/.local/bin/taskbar|[t]askbar start'|awk {'print $2'}))
  kill $pid_task[@]
}

id ()
{
  awk '{print NR,$4,$5,"\t",$2}' $bd
}

declare -x path_proj=~/hdbkp/taskbar.test
declare -x bd=/tmp/taskbar
[[ -z $@ ]] && echo "usage : taskbar start|stop" || \
  case $1 in
    start ) { wq notificatime 5000 "taskbar start" & }; { start &> /dev/null & } || <<< "falha ao iniciar" ;;
    stop ) { wq notificatime 5000 "taskbar stop" & }; { stop &> /dev/null & } || <<< "taskbar não está em execução" ;;
    restart ) nohup $(sleep 2 && taskbar start) > /dev/null & { stop &> /dev/null & };;
    id ) id;;
      * ) . $path_proj/taskbar.func.zsh; $@;;
  esac
