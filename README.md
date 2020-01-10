# taskbar
taskbar - labels de janelas para polybar - bspwm/i3wm

## Dependências
* zsh - não precisa ser seu shell padrão, mas é necessário para a execução das chamadas para a polybar.
* wmctrl - utilitário que fornece ações e informações sobre as janelas ativas.
* xwinfo - utilitário que fornece informações sobre as janelas ativas.

## o que é o taskbar.zsh? como funciona?

O conjunto de scripts fornecem uma maneira de desenhar na polybar via módulos IPC (polybar-msg) as labels das janelas ativas.

* taskbar.zsh
	* taskbar.zsh é apenas um direcionador, que carrega as funções disponíveis em taskbar.func.zsh e as executa. 
	* Quando chamado com a função start:
	> *taskbar.zsh start* 
	inicia o backend *taskbar.program.zsh*, responsável por gerar as informações no arquivo */tmp/taskbar* (títulos, workspace, programa e id de cada janela ativa), que serão usados para desenhar as labels nos módulos da polybar, e automatizar funções com mouse (módulo polybar) ou shell a partir dos ids disponíveis.

* taskbar.icons.zsh
	* É onde vocẽ pode atribuir os icones que quer utilizar para programa, há comentários no script sobre como proceder com o nome da aplicação ao atribuir um novo programa.

* taskbar.func.zsh
	* script que contém as funções de chamadas front-end do programa, literalmente as funções necessárias para desenhar os módulos, iniciar e parar o back-end.
	* Esse script não é executado, apenas tem suas funções importadas e executadas por taskbar.zsh.

* taskbar.program.zsh
	* Programa back-end responsável por monitorar o estado das janelas, e atualizar o arquivo /tmp/taskbar.









