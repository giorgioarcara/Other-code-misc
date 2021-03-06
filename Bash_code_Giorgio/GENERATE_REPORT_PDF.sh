# This script create a set of report pdf files using the images generated with the
#Participation report script.
# It needs that in the DESTINATION FOLDER:

# 1) one .txt file named "IDs_correspondence.txt", with correspondence between IDs and initial words
#(lile NP801	Matteo	o). Tab as separator. and three values 
# a) folder with figures name, b) name of the participant c) o or a, to adjust the report for gender.

# 2) a set of report Figure as obrained by the MAtlab script (in a folder to be set as SOURCE_FOLDER).

# 3) the Figure "forward_inverse.jpeg" or any other figure to be 

# 4) a Report_template.tex file, to be located in the Destination folder.



# It works like this. 
# I take the correspondence specified in IDs_correspondence.txt and substitute them in a .tex file
# that is compiled with pdflatex and filled with the path changed in every compilation (via regular expression).
# (e.g., SUBJ_FOLDER is replaecd with NP801).

# (two key things: extract array

# This script copy the segmented MRI from a source folder to the appropriate destination folder
# based on an indices file, that is expected to be contained in the destination folder

## insert here the path with Report Figures (with one folder for each subject)
SOURCE_FOLDER=/Users/giorgioarcara/Documents/Prove_CODE_Giorgio/PDF_reports/Figures


# insert here the path with the project folder
DESTINATION_FOLDER=/Users/giorgioarcara/Documents/Prove_CODE_Giorgio/PDF_reports

# create two folders
mkdir -p $DESTINATION_FOLDER/Temp_Folder
mkdir -p $DESTINATION_FOLDER/Final_PDFs

# clone the original data (to be erased later)
cp -R $SOURCE_FOLDER/. $DESTINATION_FOLDER/Temp_Folder


indices_file='IDs_correspondence.txt'


######################################
# read all lines and store in an array
#######################################
index=0
while read line; do
  myArray[index]="$line"
index=$(($index+1))
done < $DESTINATION_FOLDER/$indices_file


####
# INSERT LOOP OVER SUH


#######################################
# loop over array and copy folders
#######################################
# loop over array and extract the pairs.
# then copy the free surfer folder corresponding to the subject (subjxxx) to 
# the project folder with freesurfer segmented data
 
LIMIT=${#myArray[@]}
for ((k=0; k < LIMIT ; k++)); do 

	IN=${myArray[$k]}

	IFS=$'\t' read -ra curr_line <<< "$IN"

	echo ${curr_line[0]}
	echo ${curr_line[1]}
	echo ${curr_line[2]}


	# substitute SUBJ with curr_line[1] (taken from myArray) and move to  a temp file
	while read -r a ; do 
	echo ${a//SUBJ/${curr_line[1]}} ; 
	done < $DESTINATION_FOLDER/Report_template.tex > $DESTINATION_FOLDER/Temp_Folder/Temp_Report.tex
	
	# noy replace GENDER with curr_line[2] to create the final file
	while read -r a ; do 
	echo ${a//GENDER/${curr_line[2]}} ; 
	done < $DESTINATION_FOLDER/Temp_Folder/Temp_Report.tex > $DESTINATION_FOLDER/Temp_Folder/${curr_line[0]}/${curr_line[0]}_Report.tex	
	
	# copy the figure with forward model (necessary to compile)
	cp $DESTINATION_FOLDER/forward_inverse.jpg $DESTINATION_FOLDER/Temp_Folder/${curr_line[0]}/forward_inverse.jpg
	
	# compile to Latex (NOTE: I had to change folder to make it work properly)
	cd $DESTINATION_FOLDER/Temp_Folder/${curr_line[0]}/

	# NOTE! I compile twice cause the first time some cross-ref are not properly created.	
	pdflatex ${curr_line[0]}_Report.tex
	pdflatex ${curr_line[0]}_Report.tex

	
	# copy (only pdf) to final destination folder
	cp $DESTINATION_FOLDER/Temp_Folder/${curr_line[0]}/${curr_line[0]}_Report.pdf $DESTINATION_FOLDER/Final_PDFs/${curr_line[0]}_Report.pdf


done 
# closed loop over all eleements of array (i.e., subjects).

# delete the Temp Folder
rm -R $DESTINATION_FOLDER/Temp_Folder
