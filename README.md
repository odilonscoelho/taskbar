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
	> **taskbar.zsh start**
	* inicia o backend *taskbar.program.zsh*, responsável por gerar as informações no arquivo */tmp/taskbar* (títulos, workspace, programa e id de cada janela ativa), que serão usados para desenhar as labels nos módulos da polybar e automatizar funções com mouse (módulo polybar) ou shell a partir dos ids disponíveis.

* taskbar.icons.zsh
	* É onde você pode atribuir os icones (fontes com glifos) que quer utilizar para os programas, há comentários no script sobre como proceder com o nome das aplicações ao atribuir um ícone a um novo programa, há possibilidade de atribuir um ícone **default** que será usado para programas ainda não atribuídos.

* taskbar.func.zsh
	* script que contém as funções de chamadas front-end do programa, literalmente as funções necessárias para desenhar os módulos, iniciar e parar o back-end.
	* Esse script não é executado diretamente, apenas tem suas funções importadas e executadas por taskbar.zsh, isso vale para o backend que tbm é iniciado pela função *start* desse script.

* taskbar.program.zsh
	* Programa back-end responsável por monitorar o estado das janelas e atualizar o arquivo /tmp/taskbar.


## Configuração

1. clone esse repositório em local de sua preferência.

2. atualize a variável **$path_proj** em **taskbar.zsh** com o caminho de onde clonou o repositório:
	> declare -x path_proj=/path

3. crie um link ou copie **taskbar.zsh** para o seu path.

4. crie os módulos da polybar de acordo com sua twm, você pode adicionar quantos módulos quiser, particularmente acho 20 um número suficiente em uma barra dedicada só para os módulos da taskbar. ;) :

* bspwm

> [module/x1] > type = custom/ipc > hook-0 = echo > hook-1 = taskbar.zsh label 1 > hook-2 = taskbar.zsh > labelmin 1 > initial = 1 > format-padding = 1 > format-foreground = ${colors.background} > format-background > ${colors.foreground} > click-left = taskbar.zsh foco 1 > click-right = taskbar.zsh close 1 > click-middle = polybar-msg -p %pid% hook x1 2 > scroll-up = taskbar.zsh tiled 1 > scroll-down = taskbar.zsh floating 1
	 

* Geral polybar
> modules-{center,left ou right} = x1 x2 x3 x4.....

4. Início automático
	* bspwm
	* Adicione ao bspwmrc:
	> taskbar.zsh start

	* i3wm
	* Adicione ao seu config
	> exec_always --no-startup-id taskbar.zsh start




