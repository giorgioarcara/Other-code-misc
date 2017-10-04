dat=read.table("~/Desktop/percheck.txt", header=T)
azk=read.table("~/Desktop/script_2/MEGHEM_.azk", header=T, skip=6)

datord=dat[match(azk$Item, dat$subject),]

datord$resp="corr"
datord$resp[datord$MH001<0]="wrong"
datord$resp[datord$MH001<=-10000]="noresp"

datordrun1=datord[1:56,]

table(datordrun1$resp)

corr=read.table("~/Desktop/script_2/MH001_Correct_run1.txt")
wrong=read.table("~/Desktop/script_2/MH001_Wrong_run1.txt")
noresp=read.table("~/Desktop/script_2/MH001_Noresp_run1.txt")

Markers=read.table("~/Desktop/script_2/MarkerFile1.txt")