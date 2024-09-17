#!/bin/bash
# Requires: python3, pip, curl

AUTHORS_DIR="content/authors"
PUBLICATIONS_DIR="content/publication"

function setup_python_env() {
    if [ ! -d .venv ]; then
        python3 -m venv .venv
    fi
    source .venv/bin/activate

    if ! pip show academic; then
        pip install academic
    fi
}

function cleanup() {
    deactivate
    rm dblp.bib
}

setup_python_env

# Process all the authors from the AUTHORS_DIR
for author in $AUTHORS_DIR/*/_index.md; do

    # Look for the dblp link
    dblp=$(grep -oP 'https://dblp.[^/]+/pid/[^\.]+\.' $author)
    if [ -z "$dblp" ]; then
        echo "No dblp link found in $author"
        continue
    fi

    # Download the bibtex file
    curl -o dblp.bib $(echo $dblp | sed 's/dblp\.[^/]\+/dblp.org/')bib

    # Update the publications
    academic import dblp.bib $PUBLICATIONS_DIR --compact --normalize -v
done

cleanup