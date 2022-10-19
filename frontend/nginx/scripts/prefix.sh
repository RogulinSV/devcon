#!/usr/bin/env /bin/bash

BGRESET='\e[49m'
declare -A BGCOLORS=(
    [black]='\e[30m'
    [red]='\e[41m'
    [green]='\e[42m'
    [yellow]='\e[43m'
    [blue]='\e[44m'
    [magenta]='\e[45m'
    [cyan]='\e[46m'
    [light_red]='\e[101m'
    [light_green]='\e[102m'
    [light_yellow]='\e[103m'
    [light_blue]='\e[104m'
    [light_magenta]='\e[105m'
    [light_cyan]='\e[106m'
)

FGRESET='\e[39m'
declare -A FGCOLORS=(
    [black]='\e[40m'
    [red]='\e[31m'
    [green]='\e[32m'
    [yellow]='\e[33m'
    [blue]='\e[34m'
    [magenta]='\e[35m'
    [cyan]='\e[36m'
    [light_red]='\e[91m'
    [light_green]='\e[92m'
    [light_yellow]='\e[93m'
    [light_blue]='\e[94m'
    [light_magenta]='\e[95m'
    [light_cyan]='\e[96m'
)

BGCOLOR=${BGCOLORS[$1]:-'\e[49m'}; shift
FGCOLOR=${FGCOLORS[$1]:-'\e[39m'}; shift

exec 3>&1
exec 4>&2

printf -v PREFIX "${BGCOLOR}${FGCOLOR}%10.10s${FGRESET}${BGRESET}" ${SUPERVISOR_PROCESS_NAME}

exec 1> >( perl -ne '$| = 1; print "'"${PREFIX}"' | $_"' >&3)
exec 2> >( perl -ne '$| = 1; print "'"${PREFIX}"' | $_"' >&4)

exec "$@"