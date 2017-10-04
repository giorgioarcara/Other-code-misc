cd "$(dirname "$0")"

# cancello tutte le eventuali variabili
unset temp

# creo una lista associativa con item e tempi misurati in CheckVocal
mydatalist=*-datalist.txt


myindices=$(sed -n '1p' $mydatalist)
myvalues=$(sed -n '2p' $mydatalist)

# creo due array che contengono indici e value
# la sintassi indica di creare due array con separatore tabulazione

IFS=$'\t' read -a arindices_temp <<< "$myindices"
IFS=$'\t' read -a arvalues_temp <<< "$myvalues"

# recupero il nome del soggetto per output in .txt
Subjname=${arvalues_temp[0]}


# escludo il primo valore che è la header
arindices=("${arindices_temp[@]:1}")
arvalues=("${arvalues_temp[@]:1}")

# recupero indice delle risposte

#######################################
# leggo tutto il file .azk in un array 
#######################################
index=0
while read line; do
  myArray[index]="$line"
index=$(($index+1))
done < *.azk 

# seleziono tutto a partire dalla 7 riga (quindi escluse le iniziali).
A=("${myArray[@]:7}")


# faccio due cicli nested. uno per tutte le possibili risposte dall'azk e uno per recuperare l'indice della risposta da arindices

LIMIT=${#A[@]}
for ((i=0; i < LIMIT ; i++));
do 
	curr_line=${A[$i]}
	curr_item=${curr_line% *}

# ciclo nested per cercare nell'array con gli indici, quello corrente.
	
	for (( k = 0; k < LIMIT; k++ )); do
   		if [ "${arindices[$k]}" = "${curr_item}" ]; then
       		ordarray[$i]=$k; # creo ordarray che è un array con l'ordine di presentazione degli stimoli
   	fi
	done
done


###
# SELEZIONO IL RUN
##########
RUN=3


###################################
# leggo il marker file  dal file .txt
###################################
ctf_markerfile="MarkerFile"$RUN".txt"


# faccio lo stesso che ho fatto per l'azk, ma recuperando dalla riga di interesse
index=0
while read line; do
  trig_exacttime[index]="$line"
index=$(($index+1))
done < $ctf_markerfile

# a questo punto basta che recupero usando l'ordine degli indici in ordarray e sommo rispetto a trig_exacttime.	A quel punto avrò la correzione
# creo manualmente un indice i per trigger_exacttime in cui devo recuperare in ordine.


if [[ ${#trig_exacttime[@]} != "56" ]]; then
	echo ERROR: the Marker file contains ${#trig_exacttime[@]} responses
	exit 0 
	fi


echo -n "" > $Subjname"_Correct_run"$RUN".txt"
echo -n "" > $Subjname"_Wrong_run"$RUN".txt"
echo -n "" > $Subjname"_Noresp_run"$RUN".txt"



for ((i=0; i < ${#trig_exacttime[@]}; i++)); do
	# curr_index=${ordarray[$i]} # recupero l'indice del primo elemento presentato. AGGIUSTO PER IL RUN IN QUESTIONE!!!
	# curr_index=${ordarray[ $(( $i + 56)) ]} # RIGA CON SITASSI PER SECONDO RUN.
	 curr_index=${ordarray[ $(( $i + 112)) ]} # RIGA CON SITASSI PER TERZO RUN.
	curr_value=${arvalues[$curr_index]} # recupero il valore in base all'indice
  	# AGGIUNTA NUOVA
  	curr_value=$(echo "scale=4; $curr_value/1000" | bc) # divido per mille, visto che è in ms
  	
	## aggiungo un check per risposte corrette, sbagliate o mancate, basandomi sul primo carattere
	first_char="$(echo $curr_value | head -c 1)"
	
	echo ${arindices[$curr_index]} >> indices.txt
		
	if [[ $first_char != "-" ]] ; then
	echo "corr"
	echo ${trig_exacttime[$i]} + $curr_value | bc >> $Subjname"_Correct_run"$RUN".txt" # nota il /1000 è perché CheckVocal da ouptut in ms.
	fi
	
	if [[ "$curr_value" = "-10.0000" ]] ; then
	response=2
	### AGGIUNTA NUOVA
	echo "no resp"
	echo ${trig_exacttime[$i]} + $response | bc >> $Subjname"_Noresp_run"$RUN".txt"
	fi	

	if [[ "$first_char" = "-" && "$curr_value" != "-10.0000" ]] ; then
	echo "wrong"
	curr_value=${curr_value//-/}
	echo ${trig_exacttime[$i]} + $curr_value | bc >> $Subjname"_Wrong_run"$RUN".txt" # nota il /1000 è perché CheckVocal da ouptut in ms.
	fi
	
	#AGGIUNTA NUOVA
	if [[ "$curr_value" = "0.0" ]] ; then
		echo "Warning: item " ${arindices[$curr_index]}  " is 0.0"
	fi	
done

echo "

Files Created


"





