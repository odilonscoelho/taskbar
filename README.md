
### On english:
![README_EN](https://github.com/odilonscoelho/taskbar/blob/master/README_EN.md)<br/>

<div align="center">
<img src="https://img.shields.io/badge/taskbar-bspwm-&color=3c3836?style=for-the-badge"/>
</div>

## Dependências
<img src="https://img.shields.io/static/v1?label=ZSH&message=Nao precisa ser seu shell padrao&color=white"/>
<img src="https://img.shields.io/static/v1?label=wmctrl&message=Utilitario para capturar informacoes do xorg&color=white"/>
<img src="https://img.shields.io/static/v1?label=xwinfo&message=Utilitario para capturar informacoes do a cerca das janelas&color=white&?style=for-the-badge"/>


## o que é o taskbar? como funciona?
É um conjunto de scripts que conversam com a polybar via módulos IPC (polybar-msg), um dos scripts monitora as alterações nas labels das janelas abertas no bspwm e gera as informações: id, programa (atribuição de ícones), título e workspace (atribuição de ícones) de cada janela e escreve as informações no arquivo */tmp/taskbar*, após, informa a polybar via polybar-msg quais módulos deve desenhar/alterar/apagar, a polybar solicita a label formata ao taskbar que retorna de acordo com as definições do arquivo taskbar.conf, as cores são configuráveis, assim como as fontes que vão reinderizar os ícones e textos dos módulos, o arquivo de configuração tem aparencia de texto mas é na verdade um shell script, então ao definir/alterar valores, não deixe espaço entre as palavras/valores e o sinal de "=".

## Configuração

1. **Download**
	* clone esse repositório em local de sua preferência.

2. **Dê permissão de execuão aos scripts**
	```
	cd taskbar/
	chmod +x taskbar*
	```

3. **Deixe os scripts visíveis**
	* Adicione o repositório ao seu path.
	* Caso use o zsh como shell default, isso vai incrementar seu path no .zshrc 
	```
	cd taskbar/
	taskbar configure 
	```

	* Caso use bash, adicione ao ~/.bashrc:
	```
	PATH=${PATH}:/caminho/taskbar
	```
4. **Crie os módulos para polybar** 
	* crie os módulos da polybar de acordo com sua twm, você pode adicionar quantos módulos quiser, particularmente acho 20 um número suficiente em uma barra dedicada só para os módulos da taskbar. ;) :

	* bspwm
	 ```
	[module/x1]
	type = custom/ipc
	hook-0 = " "
	hook-1 = taskbar label 1
	hook-2 = taskbar labelfocused 1
	hook-3 = taskbar labelmin 1
	initial = 1
	format-padding = 0
	click-left = taskbar foco 1
	click-right = taskbar close 1
	click-middle = polybar-msg -p %pid% hook x1 2
	scroll-up = taskbar tiled 1
	scroll-down = taskbar floating 1
	```
	```
	[module/x2]
	type = custom/ipc
	hook-0 = " "
	hook-1 = taskbar label 2
	hook-2 = taskbar labelfocused 2
	hook-3 = taskbar labelmin 2
	initial = 1
	format-padding = 0
	click-left = taskbar foco 2
	click-right = taskbar close 2
	click-middle = polybar-msg -p %pid% hook x2 2
	scroll-up = taskbar tiled 2
	scroll-down = taskbar floating 2
	```

	* i3wm
	```
	[module/x1]
	type = custom/ipc
	hook-0 = " "
	hook-1 = taskbar labeli3 1
	hook-2 = taskbar labeli3focused 1
	hook-3 = taskbar labeli3min 1
	initial = 1
	format-padding = 0
	click-left = taskbar foco 1
	click-right = taskbar close 1
	click-middle = polybar-msg -p %pid% hook x1 2
	scroll-up = taskbar i3floating 1
	scroll-down = taskbar i3floating 1
	```
	```
	[module/x2]
	type = custom/ipc
	hook-0 = " "
	hook-1 = taskbar labeli3 2
	hook-2 = taskbar labeli3focused 2
	hook-3 = taskbar labeli3min 2
	initial = 1
	format-padding = 0
	click-left = taskbar foco 2
	click-right = taskbar close 2
	click-middle = polybar-msg -p %pid% hook x2 2
	scroll-up = taskbar i3floating 2
	scroll-down = taskbar i3floating 2
	```

	* Módulo WS para workspaces

	* bspwm
	```
	[module/ws]
	type = custom/ipc
	hook-0 = taskbar labelws
	initial = 1
	scroll-up =$(bspc desktop next -f; polybar-msg hook ws 1)
	scroll-down = $(bspc desktop prev -f; polybar-msg hook ws 1)
	format-prefix = ""
	format-padding = 0
	format-background = "#1d2021"
	format-foreground = "#83a598"
	```

	* i3wm
	```
	[module/ws]
	type = custom/ipc
	hook-0 = taskbar labelws
	initial = 1
	scroll-up = $(workspace next; polybar-msg hook ws 1)
	scroll-down = $(workspace prev; polybar-msg hook ws 1)
	format-prefix = ""
	format-padding = 0
	format-background = "#1d2021"
	format-foreground = "#83a598"
	```

	* Geral polybar
	```
 	modules-{center,left ou right} = ws x1 x2 x3 x4.....
	```
5. **Configure os ícones,fontes e cores para os módulos:**
	* No arquivo taskbar.conf é onde se define os ícones para cada programa, as cores e as fontes que irão reinderizar os ícones e os textos da label, o arquivo é todo comentado, com a explicação do que se trata cada opção.

6. **Início automático**
	* bspwm - adicione ao bspwmrc:
	```
	taskbar start &
	```

	* i3wm - adicione ao seu config:
	```
	exec_always --no-startup-id taskbar start &
	```

## Funções

Ao atribuir novos ícones, pare e reinicie o programa.

* Stop
```
taskbar stop
```
* Start
```
taskbar start
```

### Imagem
![Ilustração](print.jpg)<br/>
