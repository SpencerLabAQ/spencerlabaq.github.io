#!/bin/bash
#
# Download Spencer's bibliography from the web.
#

VITTORIO='c/VittorioCortellessa'
ANTINISCA='m/AntiniscaDiMarco'
DANIELE='171/1962'
MICHELE='76/1930-1'
LUCA='225/0294'
FEDERICO='319/9491'

MEMBERS_PID=( $VITTORIO $ANTINISCA $DANIELE $MICHELE $LUCA $FEDERICO )

echo "Activating virtual environment"
source .venv/bin/activate

for pid in "${MEMBERS_PID[@]}"
do
    echo "Downloading $(printf "%q" ${pid})"
    echo ${pid//\//_}.bib
    wget -O ./bibs/${pid//\//_}.bib "https://dblp.org/pid/${pid}.bib"
    echo "Import bib files into database"
    academic import --bibtex ./bibs/${pid//\//_}.bib
done

echo "Deactivating virtual environment"
deactivate

echo "All bib files downloaded and imported into database"
