
### On english:
![README_EN](https://github.com/odilonscoelho/taskbar/blob/master/README_EN.md)<br/>

# taskbar
taskbar - labels de janelas para polybar - bspwm/i3wm

## Dependências
* zsh - não precisa ser seu shell padrão, mas é necessário para a execução das chamadas para a polybar.
* wmctrl - utilitário que fornece ações e informações sobre as janelas ativas.
* xwinfo - utilitário que fornece informações sobre as janelas ativas.

## o que é o taskbar.zsh? como funciona?
É um conjunto de scripts que fornecem à polybar via módulos IPC (polybar-msg) as labels das janelas abertas no bspwm ou no i3wm, gera as informações: títulos, workspace, programa e id de cada janela ativa, no arquivo */tmp/taskbar*, que serão usados para desenhar as labels nos módulos da polybar e automatizar funções com mouse (módulo polybar) ou shell a partir dos ids disponíveis, os ícones (fontes com glifos) são atribuídos em um dos scripts, como explicado abaixo.

## Configuração

1. **Download**
	* clone esse repositório em local de sua preferência.


2. **Configure o caminho do projeto no script taskbar.zsh** 
	* atualize a variável **$path_proj** em **taskbar.zsh** com o caminho de onde clonou o repositório:
	```
	declare -x path_proj=/path/taskbar
	```

3. **Deixe o script visível**
	* crie um link de **taskbar.zsh** no seu path.
	* Arch linux e derivados:
	```
	cd taskbar/
	sudo ln -srv taskbar.zsh /usr/bin/taskbar
	```

4. **Crie os módulos para polybar** 
	* crie os módulos da polybar de acordo com sua twm, você pode adicionar quantos módulos quiser, particularmente acho 20 um número suficiente em uma barra dedicada só para os módulos da taskbar. ;) :

	* bspwm
	 ```
	 [module/x1]
	 type = custom/ipc
 	 hook-0 = echo
	 hook-1 = taskbar label 1
	 hook-2 = taskbar labelmin 1
	 initial = 1
	 format-padding = 1
	 format-foreground = ${colors.background}
	 format-background = ${colors.foreground}
	 click-left = taskbar foco 1
	 click-right = taskbar close 1
	 scroll-up = taskbar tiled 1
	 scroll-down = taskbar floating 1
	```
	```
	 [module/x2]
	 type = custom/ipc
	 hook-0 = echo
	 hook-1 = taskbar label 2
	 hook-2 = taskbar labelmin 2
	 initial = 1
	 format-padding = 1
	 format-foreground = ${colors.background}
	 format-background = ${colors.foreground}
	 click-left = taskbar foco 2
	 click-right = taskbar close 2
	 scroll-up = taskbar tiled 2
	 scroll-down = taskbar floating 2
	```

	* i3wm
	```
	[module/x1]
	type = custom/ipc
	hook-0 = echo
	hook-1 = taskbar labeli3 1
	hook-2 = taskbar labelmin 1
	initial = 1
	format-padding = 1
	format-foreground = ${colors.background}
	format-background = ${colors.foreground}
	click-left = taskbar foco 1
	click-right = taskbar close 1
	scroll-up = taskbar i3floating 1
	scroll-down = taskbar i3floating 1
	```
	```
	[module/x2]
	type = custom/ipc
	hook-0 = echo
	hook-1 = taskbar labeli3 2
	hook-2 = taskbar labelmin 2
	initial = 1
	format-padding = 1
	format-foreground = ${colors.background}
	format-background = ${colors.foreground}
	click-left = taskbar foco 2
	click-right = taskbar close 2
	scroll-up = taskbar i3floating 2
	scroll-down = taskbar i3floating 2
	```

	* Geral polybar
	```
 	modules-{center,left ou right} = x1 x2 x3 x4.....
	```
5. **Configure os ícones,fontes e cores para os módulos:**
	* O script responsável por atribuir os ícones aos programas é o [taskbar.icons.zsh](taskbar.icons.zsh) ,o programa usa o nome de *class* do programa sem eventuais hífens que possuam, por exemplo, **telegram-desktop**, deve ser cadastrado como **telegramdesktop**, o nome de *class* pode ser verificado com:
	```
	xwinfo -c "id"
	```
	* retorna o nome de *class* do programa com o id "id", os ids estão disponíveis em /tmp/taskbar.
	```
	< /tmp/taskbar|awk '{print $2,$5}'
	```
	* Como a polybar precisa ser formatada módulo a módulo para configurações diferentes das configurações informadas para a toda barra, por exemplo, você pode querer a cor dos ícones diferentes do restante das informações da janela informada no módulo, a cor do ícone do workspace, essa configuração precisa ser feita no cadastro do ícone, essa configuração também permite informar qual fonte deve reinderizar o glifo informado para cada programa, se for omitida, será utiliado a font padrão da barra, geralmente font-0, o índice da polybar é baseado em 0, então, ao informar a font-0 da sua configuração use %{T1}, para a font-1, %{T2}, e assim por diante.
	* font = %{T[number]}
	* color = %{F[hexadecimal]} 
	* as opções de formatação da polybar podem estar dentro de variáveis como no exemplo abaixo, isso é util para quem usa pywal poe exemplo.
	* todas as opções abertas devem ser fechadas, %{F-} e/ou %{T-}, para que a alteração seja aplicada apenas ao ícone:

	##### Ícones dos programas
	```
	subl3="%{F$color11}%{T$fontprogramicon}﬏%{F-}%{T-}"
	```
	* se %{F}%{T} for omitido, a fonte e cor padrao da barra ou definida no módulo serão aplicadas.
	* Há a possibilidade de cadastrar um ícone **default** , que será usado para programas não cadastrados.
	##### Ícones dos workspaces
	```
	w1="%{F$color2}%{T$fontworkspaceicon}%{F-}%{T-}"
	```
	* como todos os ícones são variáveis para o programa, precisa cadastrá-los com o prefixo 'w' + os nomes ou números dos workspaces, o nome deve corresponder ao que *wmctrl -l* retorna.
	* se forem números:
	```
	w[number]=[number]
	```
	* se forem uma string
	```
	w[string]=[string]
	```
	* o programa reconhece o prefixo w[workspace] como um indicador do nome de workspace, desde que esse mesmo nome não seja usado para atribuir icone para nehum programa, pelo meus testes não há conflitos.


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
