#!/bin/zsh
start ()
{
  # . $path_proj/taskbar.program.zsh
  . $path_proj/taskbar.program.zsh
  . $path_proj/taskbar.icons.zsh
  init
  $(main)
  start
}

stop ()
{
  pid_task=($(ps aux |grep -E '[t]askbar.zsh start|[t]askbar start'|awk {'print $2'}))
  kill $pid_task[@]
}

id ()
{
  awk '{print NR,$4,$5,"\t",$2}' $bd
}

interval ()
{
  sleep 0.2
}
declare -x path_proj=~/path/taskbar
declare -x bd=/tmp/taskbar
declare -x bw="/tmp/taskbar.focused"
declare -x bk="/tmp/taskbar.workspace"
declare -x bs="/tmp/taskbar.scopenew"
declare -x bf="/tmp/taskbar.workfocus"
[[ -z $@ ]] && echo "usage : taskbar start|stop" || \
  case $1 in
    start ) { wq notificatime 5000 "taskbar start" & }; { start &> /dev/null & } || <<< "falha ao iniciar" ;;
    stop ) { wq notificatime 5000 "taskbar stop" & }; { stop &> /dev/null & } || <<< "taskbar não está em execução" ;;
    restart ) nohup $(sleep 2 && taskbar start) > /dev/null & { stop &> /dev/null & };;
    id ) id;;
    loopbase ) $(loopbase) 2> /dev/null &;;
      * ) . $path_proj/taskbar.func.zsh; $@;;
  esac
