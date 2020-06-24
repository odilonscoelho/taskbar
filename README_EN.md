# taskbar
taskbar - window labels for polybar - bspwm / i3wm

## Dependencies
* zsh - it does not have to be your default shell, but it is necessary for making calls to the polybar.
* wmctrl - utility that provides actions and information about active windows.
* wmctrl - utility that provides information about active windows.

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
* **taskbar.program.zsh**
	* Back-end program responsible for monitoring the state of windows and updating the file /tmp/taskbar

## Configuration

1. clone this repository in a location of your choice.

2. update the **$ path_proj** variable in **taskbar.zsh** with the path from where you cloned the repository:
	> declare -x path_proj=/path

3. create a link or copy **taskbar.zsh** to your path.

4. create the polybar modules according to your twm, you can add as many modules as you want, particularly I find 20 enough in a dedicated bar just for the taskbar modules :

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

	* General polybar
	```
 	modules-{center,left ou right} = x1 x2 x3 x4.....
	```

5. Automatic start
	* bspwm - add to bspwmrc:
	> **taskbar.zsh start**

	* i3wm - add to config:
	> **exec_always --no-startup-id taskbar.zsh start**


## Functions
When assigning new icons, stop and restart the backend.

* Stop
> **taskbar.zsh stop**

* Start
> **taskbar.zsh start**

### Illustration
![Ilustração](https://github.com/odilonscoelho/taskbar/blob/master/print.jpg)<br/>
