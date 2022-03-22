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
        cat <<NEWHEMEFILE > ${ltspice_theme_file}
[default]
GridColor=6579300
InActiveAxisColor=9868950
WaveColor0=0
WaveColor1=11513775
WaveColor2=65280
WaveColor3=16711680
WaveColor4=255
WaveColor5=11513600
WaveColor6=16711935
WaveColor7=8421504
WaveColor8=32768
WaveColor9=11468800
WaveColor10=32943
WaveColor11=8388736
WaveColor12=128
WaveColor13=44975
SchematicColor0=16711680
SchematicColor1=16711680
SchematicColor2=8323072
SchematicColor3=16711680
SchematicColor4=12648447
SchematicColor5=0
SchematicColor6=0
SchematicColor7=0
SchematicColor8=13107200
SchematicColor9=16711680
SchematicColor10=65535
SchematicColor11=0
SchematicColor12=12632256
NetlistEditorColor0=9866370
NetlistEditorColor1=6592050
NetlistEditorColor2=9856050
NetlistEditorColor3=0
NetlistEditorColor4=1333980
NEWHEMEFILE
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
