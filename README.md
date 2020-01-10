# taskbar
taskbar - labels de janelas para polybar - bspwm/i3wm

## Dependências
* zsh - não precisa ser seu shell padrão, mas é necessário para a execução das chamadas para a polybar.
* wmctrl - utilitário que fornece ações e informações sobre as janelas ativas.
* xwinfo - utilitário que fornece informações sobre as janelas ativas.

## o que é o taskbar.zsh? como funciona?

O conjunto de scripts fornecem uma maneira de desenhar 

taskbar.zsh é apenas um direcionador, que carrega as funções disponíveis em taskbar.func.zsh e as executa, quando chamado com a função start inicia o backend, de onde a polybar pega as informações para cada módulo. 

o script funciona como um programa backend que gera informações sobre as janelas abertas (títulos, workspace, programa, id), que podem ser usados para desenhar as labels nos módulos da polybar, e automatizar funções com mouse ou shell a partir dos ids disponíveis.


