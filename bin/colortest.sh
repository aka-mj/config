#!/bin/bash
# Original: http://frexx.de/xterm-256-notes/
#           http://frexx.de/xterm-256-notes/data/colortable16.sh
# Modified by Aaron Griffin


FGNAMES=(' black' '   red' ' green' 'yellow' '  blue' 'magnta' '  cyan' ' white')
BGNAMES=('BLK' 'RED' 'GRN' 'YEL' 'BLU' 'MAG' 'CYN' 'WHT')
for b in $(seq 0 7); do
    bg=$(($b+40))

    echo -en "\e[0m ${BGNAMES[$b]} :: "
    for f in $(seq 0 7); do
        echo -en "\e[${bg}m \e[$(($f+30))m ${FGNAMES[$f]} "
    done

    echo -en "\e[0m \e[0m \t\n     :: "
    for f in $(seq 0 7); do
        echo -en "\e[${bg}m \e[1;$(($f+30))m ${FGNAMES[$f]} "
    done
    echo -e "\e[0m"

    if [ "$b" -lt 7 ]; then
        echo "     -------------------------------------------------------------------"
    fi
done

echo
echo

