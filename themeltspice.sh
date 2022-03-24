#!/usr/bin/env bash
#=======================================================================
# Name: themeltspice.sh
# Description: Set and create the color theme for OSX version of LTSpice 
#=======================================================================

# Default locations for theme and configuration files
ltspice_plist_file=/Users/$(whoami)/Library/Preferences/com.analog.LTspice.App.plist
ltspice_theme_dir=/Users/$(whoami)/.ltspice_themes
ltspice_theme_file=${ltspice_theme_dir}/themes.ltt
copied_plist_file=/tmp/com.analog.LTspice.App.plist

# Print error messages in red
red="\033[31m"
default="\033[39m"
quiet=0

# Format error message
errlog() {
    printf "$red*** ERROR *** "
    printf "$@" 
    printf "$default\n"
}

# Format info message
infolog() {
    [[ ${quiet} -eq 0 ]] && printf "$@"
}


# Make sure the theme directory and a default theme file exists
init_theme_dir() {
    if [[ ! -d ${ltspice_theme_dir} ]]; then
        echo "Creating local theme dir: " ${ltspice_theme_dir}
        mkdir ${ltspice_theme_dir}
    fi

    if [[ ! -f ${ltspice_theme_file} ]]; then
        # Initialize the theme file with the default LTSpice theme
        # Use the following command to create the coded version of theme file
        # cat themes.ltt| bzip2 |base64 -b60 | pbcopy
        cat <<NEWHEMEFILE  | base64 -d | bzcat > ${ltspice_theme_file}
QlpoOTFBWSZTWQ9dhk4ABKnfgAAQQAP/8iqhCIo/79/AUAT4rIoqpaTGe7wQ
kiExMmqNGhkDQA9RoAyGghKgNNANAAAAkIQhSNQZAAAAAIqImJtU0/TVNlNA
D0mgGjyglPVUNGhoGgMTQAAB2aX0C9IHtd1B1ETwgHq1WEGvWWNUOOMjtkcc
Z7b1RdV7bC3e4P1ivrKLyF7kfGaZxi20afJpV0qut8XKT1dMLIjGuOKGRR3Z
DRipwyUXtlw0hdhxuP1wH2muvSeL8iwvdPm97PVfCKyg9zhkepfvmXHJkc3B
wjbLfyalaIqpLg1YDsBEsYOtHKL4e1PiIpwF21RGsZ4zDhVYXNWmqrlEMBIc
iOKK7BDM02hgxoaPTjK56QfTRoFnhQjsQ2rBcNWHBosE0i1vcCxM6w30tIGl
QUMM8i4xCwRrvMuk1WTptsGNJjQ0Occ1yBkgoagBNAMnN5IHNXUIC1oh4iyY
aRrDreurmUi9bWKw1ni4dvarfjYwbYNDEZza330G0QyZyD12BSo7VbDY+Kli
8Rpi2FJ6F1Auu+0zdcKWWvFtiGwMA1verLW+oM6EWVuIiC17vIqAgJw2sh1F
Qwp7w6HleLF4IOY7MXTfeZVZWBFgSky/AZB2eBHvpCCePEpiOiOHZQoDkiiq
WLKMDwmWYLre07Dh56Avj66yR9wJ4DjuNdSY6ISw9PkGlq4suescyJqoDgaY
gORmzJ0GJIssCNlEpdAGFzlcNtGMQeI4XBZdWjRxM55c65i87B4WU28m41Ka
BgoZyqmE7qNAhYFDS9lOyd6q6zdKQMnstY9GvDUc/LIeMI13NKuLrFwoRlrR
2q4ndJeyvYC5T3qSo9bpv0v0q7J3uL0bBg2OUwusrrKRZlVxO1oUpTNOymsx
KlrbNAVeJG5UIvZmjHBgxOc5umlK8YUzmZUVVAVXq+GCWehKkBmpBTG8CirZ
hgusAwsHVUqpVGmpFkNFHSyHdW4FanItquNSNKLAkbNYQ2Q0qVEFG1qt6pLC
wFEb7AfGDA+TlnZywcsHbBpsbG0wbbTGMYnIiJwjTI4xjiHBNSEgOSKJuMYQ
bTTTbGKMDCqDAioIIMKPMMSMGkiFuECF0P7V1p87cPFp6Gzv0x2CSDf7ghEP
snjXm/FUPsVCJyPYYlY4Tt+BXOPdw/hFLfCnMVCrLmK+888f2rhvoZUFQ0z4
kwBNPMfSyGo2xFcYmQrcNs5TN+F9orRFB2UidQqEbNRw4y0BQYEgUGQrXA23
iIszUZ4m4fEuiq43qspctkIG0VDcNYrUK3FlxVjnmUmJgQj1o/kL/F3JFOFC
QD12GTg=
NEWHEMEFILE
    echo "" >> ${ltspice_theme_file}
    fi
}

# Dump the current configuration in the plist file as new named theme
# Arg 1: theme name
# Arg 2: theme file to dump values to
# Arg 3: plst file
dump_current_theme() {
    declare -a fields 
    fields=(GridColor
        InActiveAxisColor
        WaveColor0
        WaveColor1
        WaveColor2
        WaveColor3
        WaveColor4
        WaveColor5
        WaveColor6
        WaveColor7
        WaveColor8
        WaveColor9
        WaveColor10
        WaveColor11
        WaveColor12
        WaveColor13
        SchematicColor0
        SchematicColor1
        SchematicColor2
        SchematicColor3
        SchematicColor4
        SchematicColor5
        SchematicColor6
        SchematicColor7
        SchematicColor8
        SchematicColor9
        SchematicColor10
        SchematicColor11
        SchematicColor12
        NetlistEditorColor0
        NetlistEditorColor1
        NetlistEditorColor2
        NetlistEditorColor3
        NetlistEditorColor4)

    declare theme_name=$1
    declare theme_file=$2
    declare plist_file=$3

    # If the theme file exist then check that the given theme name deosn't already exist
    if [[ -f ${theme_file} ]]; then
        list_themes ${theme_file} ${theme_name}
        if [[ $? -eq 1 ]]; then
            errlog "Theme name '${theme_name}' already exist in theme file '${theme_file}'."
            exit 1
        fi
    fi

    infolog "Dumping current color setup from '%s' to '%s' as theme '%s'\n" $3 $2 $1
    touch ${theme_file}
  
    echo "[${theme_name}]" >> ${theme_file}

    for field in ${fields[@]}; do
        val=$(plutil -extract ${field} raw -expect integer -n ${plist_file})
        if [[ $? -eq 0 ]]; then
            printf "%s=%d\n" ${field} ${val} >> ${theme_file}
        else
            errlog "Field '${field}' does not exist in plist."
        fi
    done
    echo "" >> ${theme_file}

}

# Set a new theme by updating the configuration file in the third argument with the
# named theme.
# Arg1: Theme name
# Arg2: Theme file
# Arg2: LTSpice configuration (plist) file
set_theme() {
    declare theme_name_regex="\[${1}\]"
    declare theme_file=$2
    declare -i intheme=0
    declare -i n=0
    declare empty='^[[:space:]]*$'

    if [[ ! -f ${theme_file} ]]; then 
        errlog "Theme file '%s' does not exist." ${theme_file} 
        exit 1
    fi

    while read -r line;
    do
        if [[ (-z ${line} || §{line} =~ ${empty}) && ${intheme} -eq 1 ]]; then
            break
        fi
        if [[ ${intheme} -eq 1 && ${n} -le 35 ]]; then
            n=$((n+1))
            keypair='^([[:alnum:]]+)=([0-9]+)'
            [[ ${line} =~ ${keypair} ]]
            plutil -replace ${BASH_REMATCH[1]} -integer ${BASH_REMATCH[2]} $3
        fi
        if [[ ${line} =~ ${theme_name_regex} ]]; then
            intheme=1 
        fi
    done < ${theme_file}
    if [[ ${intheme} -eq 0 ]]; then
        errlog "Specfied theme '%s' does not exist in theme file '%s'." $1 ${theme_file}
        exit 1
    fi
}

# Do everything needed to update the theme
# Arg1: Theme name
# Arg2: Theme file
# Arg3: The copied version of the original LTSpice config file that we modify
update_theme() {
    declare theme_name=$1
    declare theme_file=$2
    declare copied_ltspice_file=$3

    # Do the update and check file integrity
    set_theme ${theme_name} ${theme_file} ${copied_ltspice_file}
    plutil -lint ${copied_ltspice_file} > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        cp ${copied_ltspice_file} ${ltspice_plist_file}
        if [[ ! $? -eq 0 ]]; then
            errlog "Could not copy '${copied_ltspice_file}' to '${ltspice_plist_file}'."
            exit 1
        fi
        printf "Successfully updated new theme to '%s'\n" ${theme_name}
    else
        errlog "Could not update theme, no changes made."
        exit 1
    fi

    # Finally we need to reload the plist-cache for the change to take effect
    defaults read ${ltspice_plist_file} > /dev/null
    [[ ! $? -eq 0 ]] && errlog "Failed to reload cache."
}


# With one argument lists the name of all themes in the theme file and
# with two argument checks of the theme name as a second argument already
# exists in the file. If it exists it sets the return value to 1 (true)
# Arg1: theme_file (mandatory)
# Arg2: theme_name (optional). If submitted then the routine will check if this
#                              name already exists in the theme file
list_themes() {
    declare -i check_name=0
    if [[ $# -eq 2 ]]; then
        check_name=1
    fi
    if [[ ! -f $1 ]]; then
         errlog "Can not find theme file '%s'." $1    
         exit 1
    fi

    [[ $# -eq 1 ]] && infolog "Listing themes in '%s'\n" $1
    n=1
    while read -r line;
    do
        if [[ ${line} =~ \[([-_[:alnum:]]+)\] ]]; then
            if [[ ${check_name} -eq 0 ]]; then
                printf "%2d. %s\n" $n ${BASH_REMATCH[1]}
            else
                if [[ ${BASH_REMATCH[1]} == $2 ]]; then
                    return 1
                fi
            fi
            n=$((n+1))
        fi
    done < $1
    return 0
}

# Check if LTSpice has a running process
check_running_ltspice() {
    if [[ ! -z $(pgrep -i ltspice) ]]; then
        errlog "LTSpice is running. Please close application before changing theme."
        exit 1
    fi
}

# Copy the application configuration file to a temporary location where we do the
# changes on the config file and make a backup copy if one does not exist 
# and store it in the theme directory. This secures that the very first configuration
# file can be restored manually if something really goes wrong.
copy_ltspice_plist() {
    # Always make the changes on this copy
    cp "${ltspice_plist_file}" "/tmp"
    if [[ ! $? ]]; then
        errlog "LTSpice plist file not found at '%s'" "${ltspice_plist_file}"
        exit 1
    fi
    declare originalcopy="${ltspice_theme_dir}/$(basename ${ltspice_plist_file}.ORIGINAL)"
    [[ ! -f "${originalcopy}" ]] && cp "${ltspice_plist_file}" "${originalcopy}"
}

# Dump the entire contet of the LTSpice configuration file in human readable format
print_ltspice_plist() {
    [[ ! -f ${ltspice_plist_file} ]] && printf "$red*** ERROR *** LTSpice plist file not found at '%s'!\n" "${ltspice_plist_file}" && exit 1
    infolog "'${ltspice_plist_file}' content: "
    plutil -p ${ltspice_plist_file}
}

# Print usage
usage() {
    echo "Set or create a named color theme for LTSpice"
    echo "Usage:"
    echo "%$1 [-f <FILE>] [-d] [-l] [-h] [<THEME>]" 
    echo "-d          : Dump current plist to default or named theme file as specified theme"
    echo "-f <FILE>   : Use the specified file as theme file"
    echo "-h          : Print help and exit"
    echo "-l [<NAME>] : List themes in default or named theme file or íf <NAME> is specified check if <NAME> theme exists"
    echo "-p          : List content in LTSpice plist file"
    echo "-q          : Quiet no status output"
}

#
# Main script entry. Parse arguments and kick it off
#
declare -i OPTIND=0
declare -i dump_flag=0
declare -i list_flag=0

while [[ $OPTIND -le "$#" ]]; do
  if getopts f:pdlhq option; then
    case $option in
    f)
      ltspice_theme_file="${OPTARG}"
      ;;
    l)
      list_flag=1
      ;;
    d)
      dump_flag=1
      ;;
    h)
      usage "$(basename $0)"
      exit 0
      ;;
    p)
      print_ltspice_plist
      exit 0
      ;;
    q)
      quiet=1
      ;;
    [?])
      usage "$(basename $0)"
      exit 1
      ;;
    esac
  elif [[ $OPTIND -le "$#" ]]; then
      theme_name+="${!OPTIND}"
      ((OPTIND++))
  fi
done

check_running_ltspice
init_theme_dir
copy_ltspice_plist

if [[ $list_flag -eq 1 ]]; then
    if [[ ! -z ${theme_name} ]]; then
        list_themes ${ltspice_theme_file} ${theme_name}
        if [[ $? -eq 1 ]]; then
            infolog "Theme '${theme_name}' exists in '${ltspice_theme_file}'\n"
        else 
            errlog "Theme '${theme_name}' DOESN'T exists in '${ltspice_theme_file}'"
        fi
        exit 0
    fi
    list_themes ${ltspice_theme_file}
    exit 0
fi

if [[ -z ${theme_name} ]]; then
   errlog "No theme name specified."
   usage $(basename $0)
   exit 1
fi

if [[ ${dump_flag} -eq 1 ]]; then
    dump_current_theme ${theme_name} ${ltspice_theme_file} ${copied_plist_file}
    exit 0
fi

# The default action with no options is to update the theme
update_theme ${theme_name} ${ltspice_theme_file} ${copied_plist_file}

exit 0
# <EOF>
