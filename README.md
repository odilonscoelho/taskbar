<<<<<<< HEAD
# taskbar.zsh
O programa foi desenvolvido para desenhar na polybar, a partir de módulos IPC (polybar-msg), as labels das janelas ativas, ele roda em backend, monitorando o estado das janelas ativas, a cada alteração do título, alteraçao de workspace ou ao abrir/fechar janelas o escopo e as labels são atualizados na polybar.


## Dependencias
* zsh - não precisa ser seu shell padrão mas precisa estar instalado, pois é por meio dele que o programa garante a eficácia das chamadas, fique a vontade para adaptá-lo para o bash/sh ou posix.
* wmctrl
* xwinfo - utilitário para informações e controle de janelas abertas.
* polybar


