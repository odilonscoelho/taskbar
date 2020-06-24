## Dependências
* zsh - não precisa ser seu shell padrão, mas é necessário para a execução das chamadas para a polybar.
* wmctrl - utilitário que fornece ações e informações sobre as janelas ativas.
* xwinfo - utilitário que fornece informações sobre as janelas ativas.

# taskbar
taskbar - window labels for polybar - bspwm / i3wm

## what is taskbar.zsh? how it works?
It is a set of scripts that provide the polybar via IPC modules (polybar-msg) with the labels of the windows opened in bspwm or i3wm.

* **taskbar.zsh**
	"taskbar.zsh is just a driver, which loads the functions available in taskbar.func.zsh and executes them."
	* When called with the start function:
	> **taskbar.zsh start**
	* starts the *taskbar.program.zsh* backend, responsible for generating the information in the file */tmp/taskbar* (titles, workspace, program and id of each active window), which will be used to design the labels in the polybar and automate functions with mouse (polybar module) or shell from the available ids.

* **taskbar.icons.zsh**
	* This is where you can assign the icons (fonts with glyphs) that you want to use for the programs, there are comments in the script on how to proceed with the name of the applications when assigning an icon to a new program, there is a possibility to assign an icon **default** that will be used for programs not yet assigned.
* **taskbar.func.zsh**
	* script that contains the functions called front-end of the program, literally the functions needed to design the modules.
	* This script is not executed directly, it just has its functions imported and executed by taskbar.zsh.
