# THIS COMMAND SHOULD MOVE TO THE DIRECTORY OF THE SCRIPT

cd "$(dirname "$0")"

myfile=$"*.csv"
Subjname=`echo $myfile| cut -d'_' -f 1`
wavfolder="*_wav"
Expname="MEGHEM_"

newdir=$Subjname"_CheckVocal"
newazk=$Expname".azk"
mkdir $newdir 

### FIRST CREATE THE FAKE .AZK

mycol1=($(cut -d ',' -f12 $myfile))
mycol2=($(cut -d ',' -f2 $myfile))

LIMIT=${#mycol1[@]}


# NOTA CHE PARTO DA 1 (cioè dal secondo elemento) per saltare leader.
for ((i=1; i < LIMIT ; i++)) 
do
	mydata[$(($i-1))]="$((${mycol1[i]}+1))""${mycol2[i]}"
done



# CREATE A FAKE .AZK HEADER
cd $newdir

echo -n "" > $newazk

printf " 
Subjects incorporated to date: 001
Data file started on machine B 

**********************************************************************
Subject 1, 02/02/2007 15:39:19 on B, refresh 16.61ms, ID  $Subjname 
Item	RT
" >> $newazk

LIMIT=${#mydata[@]}

for ((a=0; a < LIMIT ; a++))  # Double parentheses, and naked "LIMIT"
do
  echo "${mydata[$a]}" "-0000.00"
done >> $newazk

# creo due array che contengono rispettivamente risultati e ID degli Item
# in modo da poter fare una corrispondenza

RESULTS=(6 8 10 12 14 16 18 6 12 15 18 21 24 27 8 12 20 24 28 32 36 10 15 20 30 35 40 45 12 18 24 30 42 48 54 14 21 28 35 42 56 63 16 24 32 40 48 56 72 18 27 36 45 54 63 72 6 8 10 12 14 16 18 6 12 15 18 21 24 27 8 12 20 24 28 32 36 10 15 20 30 35 40 45 12 18 24 30 42 48 54 14 21 28 35 42 56 63 16 24 32 40 48 56 72 18 27 36 45 54 63 72)

ITEMS=(11001 11002 11003 11004 11005 11006 11007 11008 11009 11010 11011 11012 11013 11014 11015 11016 11017 11018 11019 11020 11021 11022 11023 11024 11025 11026 11027 11028 11029 11030 11031 11032 11033 11034 11035 11036 11037 11038 11039 11040 11041 11042 11043 11044 11045 11046 11047 11048 11049 11050 11051 11052 11053 11054 11055 11056 21001 21002 21003 21004 21005 21006 21007 21008 21009 21010 21011 21012 21013 21014 21015 21016 21017 21018 21019 21020 21021 21022 21023 21024 21025 21026 21027 21028 21029 21030 21031 21032 21033 21034 21035 21036 21037 21038 21039 21040 21041 21042 21043 21044 21045 21046 21047 21048 21049 21050 21051 21052 21053 21054 21055 21056)

LIMIT=${#RESULTS[@]}


echo -n "" > $Expname"-ans.txt"

for ((a=0; a < LIMIT ; a++))  # Double parentheses, and naked "LIMIT"
do
  echo "${ITEMS[$a]}" "${RESULTS[$a]}"
done >> $Expname"-ans.txt"

cd ..

cd $wavfolder

# retrieve the  lines
mylines=$((${#mydata[@]})) # nota il -1, per togliere "ID"

# Then I count the .wav files in the folder
n=0
	for d in *.wav; do
	    n=$((n+1)) 
        done

if [ $mylines = $n ]
then cp -R cleaned/. ../$newdir     
#cleaned/. indica di copiare i files dentro "cleaned" e non la cartella

cd ../$newdir

n=0
for d in *.wav; do
	    curr_item=${mydata[n]}
	    mv $d $Expname$Subjname$curr_item".wav"
	    n=$((n+1)) 
        done
cd ..
else
cd ..
	echo "ERROR: the number of .wav files is different then the list length"
fi





                       
