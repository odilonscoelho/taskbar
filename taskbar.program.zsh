#!/bin/zsh
start () {
#intervalo de comparação, verifica se houve aterações no scope das janelas. 
sleep 0.5 

#escopo atual das janelas abertas.
declare -x scopenew="$(wmctrl -l)" 

#valida se o escopo antigo $scopeold (inicialmente nulo "null") é diferente do $scopenew (atual), se houve alterações nos títulos ou disposição ;
#das janelas, ele vai gravar o $scopeold como o $scopenew (atual) para a proxima validação, e vai chamar a função ;
#assignments(){atribuições de informações janela a janela} se os scopeold e scopenew forem iguais retoma a função start para nova validação. 
test "$scopeold" != "$scopenew" && declare -x scopeold=$scopenew && assignments || start
}

assignments () {
#separa os ids das janelas em um array.

#declare -x ids=($(echo $scopenew|awk {'print $1'}))
declare -x ids=($(awk {'print $1'} <<< "${(g::)scopenew}"))

#loop para atribuir icones, títulos qual o programa e o workspace com base na quantidade de janelas abertas ${#ids}.
for (( i=1;  i<=${#ids}; i++ ))
{
	#organiza as janelas em lista crescente de workspaces ativos.	

	#indice=$(($(wmctrl -l |grep "${ids[$i]}" |awk {'print $2'}) + 1))
	indice=$(($(awk {'print $2'} <<< $(grep "${ids[$i]}" <<< "${(g::)scopenew}")) + 1))

	#atribui o ícone do workspace, definido em taskbar.icons.zsh.
	eval workspace='$'w"$indice" 

	#atribui o título da janela.
	#title=`wmctrl -l |grep "${ids[$i]}" |awk {'print $4,$5,$6'}`
	title=$(awk {'print $4,$5,$6'} <<< $(grep "${ids[$i]}" <<< "${(g::)scopenew}"))

	#atribui o nome do programa.
	#program=`xwinfo -i ${ids[$i]}|sed 's/\-//g'` 
	program=$(sed 's/\-//g' <<< "$(xwinfo -i "${ids[$i]}")")

	#atribui o ícone ao programa, definido em taskbar.icons.zsh.
	eval icon='$'$program 

	#se o programa não estiver definido taskbar.icons.zsh, usar o icon $default.
	[[ -z $icon ]] && icon=$default 

	#enquanto o loop rodar para atribuição de janela por janela, salvar o resultado na variável $labels, uma linha por janela ativa.
	labels+="$indice ${ids[$i]} $workspace $icon $program $title\n"
}
#escreve o conteúdo de $labels ordenado por workspace em /tmp/taskbar ${bd}.
grep -v '^$' <<< $(sort -nk1 <<< "${(g::)labels}") > $bd 
#define $labels como nula " " para a proxima rodada de atribuições.
unset labels
#chama a função modules para informar a polybar sobre quais módulos desenhar.
modules
}

modules () {
#loop para informar a polybar via ipc-msg (polybar-msg) com base no número de janelas ativas ${#ids};
#quais o módulos devem imprimir ou atualizar a label do módulo, se a quantidade de janelas abertas;
#for maior que 10, a label será solicitada como minimal para ter espaço na bar.
for (( i=1; i <= ${#ids}; i++ )) 
{ 
	[[ ${#ids} -gt 10 ]]&&
		{polybar-msg hook x$i 3
		sleep 0.05} ||\
		{polybar-msg hook x$i 2
		sleep 0.05}
}

#loop para informar a polybar via ipc-msg (polybar-msg) com base no número de janelas ativas ${#ids};
#quais o módulos devem ser zerados, apagados ou no caso com label echo "";
for (( i=$(( ${#ids} + 1 )); i <= $contadorold; i++ ))
{ 
	polybar-msg hook x$i 1
	sleep 0.05 
}  

#salvaremos a quantidade de janelas abertas nesse ciclo como $contadorold para que no proximo ciclo;
#a validação das labels que precisam ser desligadas seja exatamente a quantidade de janelas fechadas;
#a fim de não precisar desligar todos os modulos de labels definidos na bar;
declare -x contadorold=${#ids}

#inica um novo cilo de validação das janelas abertas.
start
}

#importa os ícones que foram atribuidos em taskbar.icons.zsh
. $path_proj/taskbar.icons.zsh

declare -x scopeold=""
#valor inicial de $contadorold para assegurar que todos os módulo sejam att no primeiro ciclo.
declare -x contadorold=0
#caso o arquivo exista em /tmp/taskbar ele vai excluí-lo, em caso de restart.
[[ -e $bd ]] && rm -f $bd
#inicia o programa.
start
