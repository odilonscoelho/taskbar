# taskbar
taskbar - labels de janelas para polybar - bspwm/i3wm
"taskbar - window labels for polybar - bspwm / i3wm"

## Dependências "Dependencies"
* zsh - não precisa ser seu shell padrão, mas é necessário para a execução das chamadas para a polybar.
"it does not have to be your default shell, but it is necessary for making calls to the polybar."
* wmctrl - utilitário que fornece ações e informações sobre as janelas ativas.
"utility that provides actions and information about active windows."
* xwinfo - utilitário que fornece informações sobre as janelas ativas.
"utility that provides information about active windows."

## o que é o taskbar.zsh? como funciona?

É um conjunto de scripts que fornecem à polybar via módulos IPC (polybar-msg) as labels das janelas abertas no bspwm ou no i3wm.

"It is a set of scripts that provide the polybar via IPC modules (polybar-msg) with the labels of the windows opened in bspwm or i3wm."

* **taskbar.zsh**
	* taskbar.zsh é apenas um direcionador, que carrega as funções disponíveis em taskbar.func.zsh e as executa
	"taskbar.zsh is just a driver, which loads the functions available in taskbar.func.zsh and executes them."
	.
	* Quando chamado com a função start:
	"When called with the start function:"
		> **taskbar.zsh start**
	* inicia o backend *taskbar.program.zsh*, responsável por gerar as informações no arquivo */tmp/taskbar* (títulos, workspace, programa e id de cada janela ativa), que serão usados para desenhar as labels nos módulos da polybar e automatizar funções com mouse (módulo polybar) ou shell a partir dos ids disponíveis.

* **taskbar.icons.zsh**
	* É onde você pode atribuir os icones (fontes com glifos) que quer utilizar para os programas, há comentários no script sobre como proceder com o nome das aplicações ao atribuir um ícone a um novo programa, há possibilidade de atribuir um ícone **default** que será usado para programas ainda não atribuídos.
	"starts the * taskbar.program.zsh * backend, responsible for generating the information in the file * / tmp / taskbar * (titles, workspace, program and id of each active window), which will be used to design the labels in the polybar and automate functions with mouse (polybar module) or shell from the available ids."

* **taskbar.func.zsh**
	* script que contém as funções de chamadas front-end do programa, literalmente as funções necessárias para desenhar os módulos.
	"script that contains the functions called front-end of the program, literally the functions needed to design the modules."
	* Esse script não é executado diretamente, apenas tem suas funções importadas e executadas por taskbar.zsh.
	"This script is not executed directly, it just has its functions imported and executed by taskbar.zsh."

* **taskbar.program.zsh**
	* Programa back-end responsável por monitorar o estado das janelas e atualizar o arquivo /tmp/taskbar.
	"Back-end program responsible for monitoring the state of windows and updating the file / tmp / taskbar"

## Configuração

1. clone esse repositório em local de sua preferência.
"1. clone this repository in a location of your choice."

2. atualize a variável **$path_proj** em **taskbar.zsh** com o caminho de onde clonou o repositório:
"2. update the **$ path_proj** variable in **taskbar.zsh** with the path from where you cloned the repository:"
	> declare -x path_proj=/path

3. crie um link ou copie **taskbar.zsh** para o seu path.
"3. create a link or copy ** taskbar.zsh ** to your path."

4. crie os módulos da polybar de acordo com sua twm, você pode adicionar quantos módulos quiser, particularmente acho 20 um número suficiente em uma barra dedicada só para os módulos da taskbar. ;) :
"4. create the polybar modules according to your twm, you can add as many modules as you want, particularly I find 20 enough in a dedicated bar just for the taskbar modules :"

	* bspwm
	 ```
	 [module/x1]
	 type = custom/ipc
 	 hook-0 = echo
	 hook-1 = taskbar.zsh label 1
	 hook-2 = taskbar.zsh labelmin 1
	 initial = 1
	 format-padding = 1
	 format-foreground = ${colors.background}
	 format-background = ${colors.foreground}
	 click-left = taskbar.zsh foco 1
	 click-right = taskbar.zsh close 1
	 scroll-up = taskbar.zsh tiled 1
	 scroll-down = taskbar.zsh floating 1
	```
	```
	 [module/x2]
	 type = custom/ipc
	 hook-0 = echo
	 hook-1 = taskbar.zsh label 2
	 hook-2 = taskbar.zsh labelmin 2
	 initial = 1
	 format-padding = 1
	 format-foreground = ${colors.background}
	 format-background = ${colors.foreground}
	 click-left = taskbar.zsh foco 2
	 click-right = taskbar.zsh close 2
	 scroll-up = taskbar.zsh tiled 2
	 scroll-down = taskbar.zsh floating 2
	```

	* i3wm
	```
	[module/x1]
	type = custom/ipc
	hook-0 = echo
	hook-1 = taskbar.zsh labeli3 1
	hook-2 = taskbar.zsh labelmin 1
	initial = 1
	format-padding = 1
	format-foreground = ${colors.background}
	format-background = ${colors.foreground}
	click-left = taskbar.zsh foco 1
	click-right = taskbar.zsh close 1
	scroll-up = taskbar.zsh i3floating 1
	scroll-down = taskbar.zsh i3floating 1
	```
	```
	[module/x2]
	type = custom/ipc
	hook-0 = echo
	hook-1 = taskbar.zsh labeli3 2
	hook-2 = taskbar.zsh labelmin 2
	initial = 1
	format-padding = 1
	format-foreground = ${colors.background}
	format-background = ${colors.foreground}
	click-left = taskbar.zsh foco 2
	click-right = taskbar.zsh close 2
	scroll-up = taskbar.zsh i3floating 2
	scroll-down = taskbar.zsh i3floating 2
	```

	* Geral polybar
	* General polybar
	```
 	modules-{center,left ou right} = x1 x2 x3 x4.....
	```

5. Início automático
5. Automatic start
	* bspwm - adicione ao bspwmrc:
	* bspwm - add to bspwmrc:
	> **taskbar.zsh start**

	* i3wm - adicione ao seu config:
	* i3wm - add to config:
	> **exec_always --no-startup-id taskbar.zsh start**


## Funções

Ao atribuir novos ícones, pare e reinicie o backend.
"When assigning new icons, stop and restart the backend."

* Stop
> **taskbar.zsh stop**

* Start
> **taskbar.zsh start**

### Imagem
![Ilustração](https://github.com/odilonscoelho/taskbar/blob/master/print.jpg)<br/>
