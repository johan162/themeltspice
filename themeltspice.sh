#!/usr/bin/env bash
#=======================================================================
# Name: themeltspice.sh
# Description: Set and create the color theme for OSX version of LTSpice
# Author: Johan Persson <johan162@gmail.com>
#
# MIT License
#
# Copyright (c) 2022 Johan Persson <johan162@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#=======================================================================

# Warn about unbound variable usage
set -u

# Default locations for theme and configuration files
version="1.6.0"
ltspice_plist_file=/Users/$(whoami)/Library/Preferences/com.analog.LTspice.App.plist
ltspice_theme_dir=/Users/$(whoami)/.ltspice_themes
ltspice_theme_file=${ltspice_theme_dir}/themes.ltt
ltspice_version_file=${ltspice_theme_dir}/version
ltspice_theme_file_new=${ltspice_theme_dir}/themes.ltt.NEW
copied_plist_file=/tmp/com.analog.LTspice.App.plist

# Print error messages in red
red="\033[31m"
magenta="\033[35m"
yellow="\033[33m"
default="\033[39m"

# Format error message
errlog() {
    printf "$red*** ERROR *** "
    printf "$@"
    printf "$default\n"
}

# Format error message
warnlog() {
    printf "${yellow}Warning: "
    printf "$@"
    printf "$default\n"
}

# Format info message
infolog() {
    [[ ${quiet_flag} -eq 0 ]] && printf "$@" && printf "\n"
}

# Check that the system have the expected bash version and warn otherwise
chk_bash_version() {
    declare supported_version="3.2.57(1)-releas"
    if [ "${supported_version}" != "${BASH_VERSION}" ]; then
        warnlog "Non-supported BASH version found ${BASH_VERSION}"
        return 1
    fi
    return 0
}

# Check if an older version is already installed by reading the
# version file in the theme directory.
# Return 1 if the current version is newer than the one already installed,
# return 0 otherwise
chk_new_version() {
    local maj min p curr_maj curr_min curr_p
    if [ ! -f ${ltspice_version_file} ]; then
        echo ${version} > ${ltspice_version_file}
        return 1
    else
        # IF="." && cat ${ltspice_version_file} | read  maj min p
        #while IFS= read -r versionline; do
        #    echo "Read line: $versionline"
        #    IFS="." &&  read  maj min p <<< "${versionline}"
        #done<${ltspice_version_file}
        OIFS=$IFS
        #echo "Reading from: $ltspice_version_file"
        IFS="." &&  read maj min p < "${ltspice_version_file}"
        #echo "EXISTING: $maj $min $p"

        IFS="." &&  read curr_maj curr_min curr_p <<< "${version}"
        #echo "NEW: $curr_maj $curr_min $curr_p"
        IFS=$OIFS

        if [ $curr_maj -gt $maj ]; then
            return 1
        elif [ $curr_min -gt $min ]; then
            return 1
        elif [ $curr_p -gt $p ]; then
            return 1
        fi
    fi
    return 0
}

# Make sure the theme directory and a default theme file exists
init_theme_dir() {
    if [[ ! -d ${ltspice_theme_dir} ]]; then
        infolog "Creating local theme dir: ${ltspice_theme_dir}"
        mkdir ${ltspice_theme_dir}
    fi
}

# Update existing or add a new theme file as needed
init_theme_file() {
    # Initialize the theme file with the default LTSpice theme.
    # Use the following command to get the encoded version into the paste buffer
    # when theme is updated. Then do a CMD-V to past into this file.
    # cat themes.ltt|bzip2|base64 -b60|pbcopy
    cat <<NEWHEMEFILE | base64 -d | bzcat >${ltspice_theme_file_new}
QlpoOTFBWSZTWaCBGuYABidfgAAQAAP/8iqlDIo/79/AUAYZ52wAAAAIcACp
U0mmCSeyp+ghMRtT1Gj1MNIRoijRkwJiNMCZMJk9JgSaUhSMZTBkAmTEwExM
YyGQ0Gg0aANAA0MEiBBFTVDGoAAwAgfmDDOXpA3sQ1GVHFHFku6FIa2YzCiL
rKZCGBK0Spk4TDi1TTVnuZZZ1yy01Wi3etymfEBfMJVVcl5yZcsNNbYG2ljN
kYpOKSpNG1uUzKJGiiEra2MoTQ6EiEYIyWSw0ouYWSOCw/x9jDGcvYVGNMNP
A+IT41zYU59qHBNhMgwGxlmdHS7me3GNM8NulafiE4UMbKiPmZZfErMLUIMN
IgaJLGpFzi096UEr9tQbKRkBR9OGI53kaovhxUqzihZopmGaukMLIthRXg5K
+oJGxptJoYwbGLu2Sb9hPjFgBZ4pSOoTYUAbDKFsaKAGCpa1CKAarjDXFgkw
JAlMJvwlbYkHz0hYeZhUphOEdY2xMGkMbYNHvsIz2TZaVHCUU5SLT2eGyw95
mE0GiuCiZ0LzA0baN6O830qL5SKvXFWk0XeLa4zSyjXjGmDbSYDBZOra0d4L
aIVkXkJ50RK3S6q2G1MHFStPxFjFsKTxLsIonh1NanYSrpeLQ0JjSYPUa4aT
1HJVrhOlR2ZklPXdbcmQqC9rW5uCplSFAwp6LODsk8VrngC4GNWGLray7kmy
S0QrVVavwVoOh4PF+qpCQPIJsoaJ9R42jqsKRrwxaKlYrwijBeBGWrC2s1Kd
Bs89AJ+fOZEPvshPoekQbsm1R6iy9r0jcOVg55orShem4VqLxvKIRxoIaaNn
Va4mCDSaFXVaRZZ6ASV08zxacnBoXWvLWFwCyppGjia5yoOGy151DsKJbdkG
oGoJaSaNnSziYKIVGxTPgBXy9PPfYNQojqpdIEWhqDxZbwzwyHH3WQvBhDXY
7pUcXcXFIlZS0aU7TqUj5SfIA3L1kQcqW9G4Yz0ofs1Kjw2QvRsGDYy9C4s9
WWHg1whBDrwre3s6pGG10QcPOn0fIA5+5V6HEUQeN1R8L4XwaNGjRCZZZ6VO
+6WbXFIHI4R8ML7wur01uSDZgYanuypzTYcWs2G0wh0YFYVhOEHBlmJ0HFS5
W5uSS9QFcvZOnmp5Zwy6NIxdT0Yhm6d1dEyqWijmd5lbtpoxLp8wPpAkPthO
HCGoiFFggoiIwQUWMYxAa0jEoUYlGsQaRKRC0LYJaWWI1BhRGDEFQYiJGCIi
CRiKCRggiPkH6QZOcCG0A4kBDlVIkYVEnCzu2dKY0/3DKlapbk08smfgInf/
Akr95b02/eyvR6oidBEpOc/Qo1DPLC70EeFPF2/Akl3jxy9oRNXF6iN2fLL3
r7X436ONWgidnXz5SuRE6tw89dXL5F1YjhScRF4uxzb6fVRnhaI0ggszpN0I
lNfUZ054/AQVTEIMRGpVL8BJDa8uoys4TYNutf86oRv2Qjsv9LKvzSbBEyFg
isRhLb5jVN61daKgk7rqcx/xdyRThQkKCBGuYA==
NEWHEMEFILE
   # echo "" >>${ltspice_theme_file_new}
     if [[ ! -f ${ltspice_theme_file} ]]; then
        # Nothing exists since before so just install it
        mv ${ltspice_theme_file_new} ${ltspice_theme_file}
     else
        # There is  previous version so we merge the new theme file with the old
        # if necessary
        declare diff_filename="diff.txt"
        cd ${ltspice_theme_dir}
        diff "${ltspice_theme_file_new}" "${ltspice_theme_file}" > "${diff_filename}"
        if [  -s "${diff_filename}" ]; then
            # There is a difference so patch
            patch -b ${ltspice_theme_file} diff.txt
            if [ $? -eq 0 ]; then
                infolog "Patched old themefile with updates. Original theme file in *.orig"
            else
                errlog "Patching existing theme file failed! Original file in *.orig\n"
                return 1
            fi
        else
            infolog "Theme files are identical. No update necessary."
        fi
        rm "${ltspice_theme_file_new}"
        rm "${diff_filename}"
     fi
     return 0
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

    echo "[${theme_name}]" >>${theme_file}

    for field in ${fields[@]}; do
        val=$(plutil -extract ${field} raw -expect integer -n ${plist_file})
        if [[ $? -eq 0 ]]; then
            printf "%s=%d\n" ${field} ${val} >>${theme_file}
        else
            errlog "Field '${field}' does not exist in plist."
        fi
    done
    echo "" >>${theme_file}

}

# Ask user a Y/N question
# Arg1: Prompt string
# Set exit code 1=YES, 0=NO
ask_yn() {
    [[ ${yes_flag} -eq 1 ]] && return 1

    printf "$@\n"
    select yn in "Yes" "No"; do
        echo $yn
        case $yn in
        Yes) return 1 ;;
        No) return 0 ;;
        esac
    done
}

# Delete named theme
# Arg1: Theme file
# Arg2: Theme name
delete_theme() {
    declare theme_file=$1
    declare theme_name=$2
    declare theme_name_regex="\[${theme_name}\]"
    declare -i lineno=0
    declare -i start_lineno=0
    declare -i end_lineno=0
    declare -i intheme=0
    declare -i n=0
    declare prevline=""

    if [[ ! -f ${theme_file} ]]; then
        errlog "Theme file '%s' does not exist." ${theme_file}
        exit 1
    fi

    list_themes "${theme_file}" "${theme_name}"
    if [[ $? -eq 0 ]]; then
        errlog "Theme '%s' does not exist." "${theme_name}"
        exit 1
    fi

    # This gets a bit convoluted since we need to keeptrack also of the immediate
    # line above the theme name since it could be a reference URL to the theme
    # in order to give credit to the creator of the theme.
    while read -r line; do
        lineno=$((lineno + 1))
        if [[ ${line} =~ ${theme_name_regex} ]]; then
            if [[ intheme -eq 1 ]]; then
                errlog "Corrupt theme file near line %d. Cannot delete theme." "${lineno}"
                exit 1
            fi
            intheme=1
            start_lineno=$lineno
            end_lineno=$lineno
        elif [[ ${intheme} -eq 1 ]]; then
            if [[ (-z ${line} || §{line} =~ ${empty}) ]]; then
                break
            fi
            n=$((n + 1))
            end_lineno=$((end_lineno + 1))
            if [[ ${n} -ge 35 ]]; then
                errlog "Corrupt theme file near line %d. Cannot delete theme." "${lineno}"
                exit 1
            fi
        fi
        # As long as we have not found the theme we record the previous line
        # in order to check if there is a single line URL to the source of the
        # specific theme that can optionally exist.
        [[ ${intheme} -eq 0 ]] && prevline="${line}"
    done <${theme_file}

    # If the line just above the theme name is a text and not a blank line
    # then we also delete that line (which is a theme comment)
    [[ ! -z ${prevline} ]] && start_lineno=$((start_lineno - 1))

    # Delete blank line after the theme. We are guaranteed that the line is blank
    # since finding a blank line is the only way to break out of the loop without
    # it being a detected error
    end_lineno=$((end_lineno + 1))

    if [[ ${verbose_flag} -eq 1 ]]; then
        infolog "Deleting line range [${start_lineno},${end_lineno}] in '${theme_file}'.\n\n"
        sed -n "${start_lineno},${end_lineno}p" ${theme_file}
    fi

    ask_yn "Are you sure you wish to delete theme '${theme_name}' in '${theme_file}'?"
    if [[ $? -eq 1 ]]; then
        sed -i '.BAK' "${start_lineno},${end_lineno}d" ${theme_file}
        if [[ $? -eq 0 ]]; then
            infolog "Theme '%s' deleted from '%s'.\n" "${theme_name}" "${theme_file}"
            exit 0
        else
            errlog "Could NOT delete theme '%s' from '%s'.\n" "${theme_name}" "${theme_file}"
            exit 1
        fi
    else
        infolog "${red}Theme '${theme_name}' NOT deleted.${default}\n"
        exit 0
    fi
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

    while read -r line; do
        if [[ (-z ${line} || §{line} =~ ${empty}) && ${intheme} -eq 1 ]]; then
            break
        fi
        if [[ ${intheme} -eq 1 && ${n} -le 35 ]]; then
            n=$((n + 1))
            keypair='^([[:alnum:]]+)=([0-9]+)'
            [[ ${line} =~ ${keypair} ]]
            plutil -replace ${BASH_REMATCH[1]} -integer ${BASH_REMATCH[2]} $3
        fi
        if [[ ${line} =~ ${theme_name_regex} ]]; then
            intheme=1
        fi
    done <${theme_file}
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
    plutil -lint ${copied_ltspice_file} >/dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        cp ${copied_ltspice_file} ${ltspice_plist_file}
        if [[ ! $? -eq 0 ]]; then
            errlog "Could not copy '${copied_ltspice_file}' to '${ltspice_plist_file}'."
            exit 1
        fi
        infolog "Successfully updated new theme to '%s'\n" ${theme_name}
    else
        errlog "Could not update theme, no changes made."
        exit 1
    fi

    # Finally we need to reload the plist-cache for the change to take effect
    defaults read ${ltspice_plist_file} >/dev/null
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
    declare -i n=1
    if [[ $# -eq 2 ]]; then
        check_name=1
    fi

    if [[ ! -f $1 ]]; then
        errlog "Can not find theme file '%s'." $1
        exit 1
    fi

    [[ $# -eq 1 ]] && infolog "Listing themes in '%s'" $1
    while read -r line; do
        if [[ ${line} =~ \[([-_[:alnum:]]+)\] ]]; then
            if [[ ${check_name} -eq 0 ]]; then
                infolog "%2d. %s" $n ${BASH_REMATCH[1]}
            else
                if [[ ${BASH_REMATCH[1]} == $2 ]]; then
                    return 1
                fi
            fi
            n=$((n + 1))
        fi
    done <$1
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
    [[ ! -f ${ltspice_plist_file} ]] && errlog "LTSpice plist file not found at '%s'." "${ltspice_plist_file}" && exit 1
    infolog "'${ltspice_plist_file}':\n"
    plutil -p ${ltspice_plist_file}
}

# Print usage
usage() {
    echo "Set or create a named color theme for LTSpice"
    echo "Usage:"
    echo "%$1 [-f <FILE>] [-d] [-l] [-h] [-p] [-q] [-v] [-x <THEME>] [-y] [<THEME>]"
    echo "-d          : Dump current plist to default or named theme file as specified theme"
    echo "-f <FILE>   : Use the specified file as theme file"
    echo "-h          : Print help and exit"
    echo "-l [<NAME>] : List themes in default or named theme file or íf <NAME> is specified check if <NAME> theme exists"
    echo "-p          : List content in LTSpice plist file"
    echo "-q          : Quiet  (no output to stdout)"
    echo "-V          : Verbose status output"
    echo "-v          : Print version and exit"
    echo "-x <NAME>   : Delete theme NAME from themes file"
    echo "-y          : Force 'yes' answer to any interactive questions (e.g. deleting theme)"
}

#
# Main script entry. Parse arguments and kick it off
#

declare -i OPTIND=0
declare -i dump_flag=0
declare -i list_flag=0
declare -i delete_flag=0
declare -i yes_flag=0
declare -i quiet_flag=0
declare -i verbose_flag=0
declare theme_name=""

# Give warning if user have a non-supported bash version
chk_bash_version

while [[ $OPTIND -le "$#" ]]; do
    if getopts f:pdlhqvxyV option; then
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
            quiet_flag=1
            ;;
        x)
            delete_flag=1
            ;;
        v)
            infolog "$version\n"
            exit 0
            ;;
        V)
            verbose_flag=1
            ;;
        y)
            yes_flag=1
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

# Check and create a local theme dir as necesary
init_theme_dir

# Check if this is a newer version or it has never been installed
chk_new_version
if [ $? -eq 1 ]; then
    infolog "Existing Installation is older and theme file will be updated to v${version}"
    init_theme_file
    if [ $? -eq 0 ]; then
        echo "${version}" > "${ltspice_version_file}"
        infolog "Updated to v${version}\n"
    fi
fi

if [[ $list_flag -eq 1 ]]; then
    if [[ ! -z ${theme_name} ]]; then
        list_themes "${ltspice_theme_file}" "${theme_name}"
        if [[ $? -eq 1 ]]; then
            infolog "Theme '${theme_name}' exists in '${ltspice_theme_file}'"
        else
            errlog "Theme '${theme_name}' DOESN'T exists in '${ltspice_theme_file}'"
        fi
        exit 0
    fi
    list_themes ${ltspice_theme_file}
    exit 0
fi

check_running_ltspice
copy_ltspice_plist

if [[ -z ${theme_name} ]]; then
    errlog "No theme name specified."
    usage $(basename $0)
    exit 1
fi

if [[ ${dump_flag} -eq 1 ]]; then
    dump_current_theme ${theme_name} ${ltspice_theme_file} ${copied_plist_file}
    exit 0
fi

if [[ ${delete_flag} -eq 1 ]]; then
    delete_theme ${ltspice_theme_file} ${theme_name}
    exit 0
fi

# The default action with no options is to update the theme
update_theme ${theme_name} ${ltspice_theme_file} ${copied_plist_file}

exit 0
# <EOF>
