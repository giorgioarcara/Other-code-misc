GLI SCRIPT MEGHEM_events_mrk_run1.command

funzionano in teoria, ma solo se il numero di eventi "Second", nel markeFile è 56.
Per via del salvataggio tramite epoche nei file CTF, spesso c'è qualche evento in più che non è altro che un duplicato di un altro evento esistente
Questo rende di fatto inutili questi script.
L'alternativa è usare altri script che partono dagli eventi esportati da brainstorm








GLI SCRIPT MEGHEM_events_txt ERANO FUNZIONANTI ma ho trovato quello che sembrava essere un errore
nella sintassi della riga 53.
in questa versione è   

if [ "${arindices[$k]}" = "${curr_item}" ]; then

ma questa sintassi mi da problemi se copio il codice e lo incollo direttamente sul terminale con bash
(quindi non faccio doppio click su command).

la sintassi giusta pare avere doppie quadre

if [["${arindices[$k]}" = "${curr_item}"]]; then

Non so come mai mi funzionassero comunque e come non mi fossi accorto prima =_=

