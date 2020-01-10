#!/bin/zsh
#declara o path do projeto onde todos os demais scripts deve estar.
declare -x path_proj=$HOME/.config/polybar/taskbar
#declara o file que será escrito ou consultado para manipular as ids das windows e desenho das labels.
declare -x bd=/tmp/taskbar
case $1 in
  start ) . $path_proj/taskbar.func.zsh; start &> /dev/null &;;
  stop ) . $path_proj/taskbar.func.zsh; stop;;
  restart )  . $path_proj/taskbar.func.zsh; restart;;
    * ) . $path_proj/taskbar.func.zsh; $1 $2;;
esac	
