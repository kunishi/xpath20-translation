#!/bin/sh

JARDIR=/opt/local/share/java

java -jar $JARDIR/saxon8.jar -o "$3" "$1" "$2" && \
tidy -utf8 -m "$3" 
