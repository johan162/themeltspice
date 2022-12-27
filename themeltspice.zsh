#!/usr/bin/env zsh
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
version="2.0.1"
ltspice_plist_file=/Users/$(whoami)/Library/Preferences/com.analog.LTspice.App.plist
ltspice_theme_dir=/Users/$(whoami)/.ltspice_themes
ltspice_theme_file=${ltspice_theme_dir}/themes.ltt
ltspice_version_file=${ltspice_theme_dir}/version
ltspice_theme_file_new=${ltspice_theme_dir}/themes.ltt.NEW
copied_plist_file=/tmp/com.analog.LTspice.App.plist

# Color for use in notice, warning messages etc.
red="\033[31m"
magenta="\033[35m"
yellow="\033[33m"
default="\033[39m"

# Format error message
errlog() {
    printf "${red}ERROR: "
    printf "$@"
    printf "$default\n"
}

# Format notice message
noticelog() {
    printf "${yellow}Notice: "
    printf "$@"
    printf "$default\n"
}

# Format info message
infolog() {
    [[ ${quiet_flag} -eq 0 ]] && printf "$@" && printf "\n"
}

# Format info message
verboselog() {
    [[ ${verbose_flag} -eq 1 ]] && printf "$@" && printf "\n"
}

# Check if an older version is already installed by reading the
# version file in the theme directory.
# Return 1 if the current version is newer than the one already installed,
# return 0 otherwise
chk_if_new_version() {
    local maj min p curr_maj curr_min curr_p
    if [ ! -f ${ltspice_version_file} ]; then
        # This is a very old version that doesn't even have a "version" file
        echo ${version} > ${ltspice_version_file}
        return 1
    else
        OIFS=$IFS
        IFS="." &&  read maj min p < "${ltspice_version_file}"
        IFS="." &&  read curr_maj curr_min curr_p <<< "${version}"
        IFS=$OIFS

        if [ $curr_maj -gt $maj ]; then
            verboselog "Upgrading v${maj}.${min}.${p} -> v${version}"
            return 1
        elif [ $curr_min -gt $min ]; then
            verboselog "Upgrading v${maj}.${min}.${p} -> v${version}"
            return 1
        elif [ $curr_p -gt $p ]; then
            verboselog "Upgrading v${maj}.${min}.${p} -> v${version}"
            return 1
        fi
        verboselog "Existing version is up to date."
    fi
    return 0
}

# Make sure the theme directory and a default theme file exists
init_theme_dir() {
    if [[ ! -d ${ltspice_theme_dir} ]]; then
        verboselog "Creating local theme dir: ${ltspice_theme_dir}"
        mkdir ${ltspice_theme_dir}
    else
        verboselog "Directory \"${ltspice_theme_dir}\" exists."
    fi
}

# Update existing or add a new theme file as needed
init_theme_file() {
    # Initialize the theme file with the default LTSpice theme.
    # Use the following command to get the encoded version into the paste buffer
    # when theme is updated. Then do a CMD-V to past into this file.
    # cat themes.ltt|bzip2|base64 -b60|pbcopy
    cat <<NEWTHEMEFILE | base64 -d | bzcat >${ltspice_theme_file_new}
QlpoOTFBWSZTWZ78OycAB49fgEAQAAP/8iqlDIo/79/AYAaeaaa+ANDIqVq3
w8DUIqERo0mxDEmhppk0yMAgyAFKNAAaNAAAAYDRkNBhANANNAACFKqZMAAA
AAAADaIgkaJEep6jEYBDTQMCKTECSoDQAAAABz1RSTa0fqhdojuYiadNOoJT
lESPBlYRB7ccULTFSZHBqMuoKnUnhIa8M73ESoSIvdyQZRpzHAQSsIYnFEOV
V5cxWW7u2jbStoW2JZZsmSjgoujRs3QzNlDRaglhmxlgxLZIMGWWaoyWTqL3
PpDJB69Z9rK158Oel3xKnK2sXVdAa20ZhklsAiliDzNLHkqVZxScizHDcScI
02XI/yM4McCWTJgiRk0iDRRgZQlxwaT3ohR5OpsuRKgOeGTIOaYtOYw4XAfK
QqZouhWTOqsTSwphpWX1HRfiihpjGxJoYxRBA93GiCnfrAQVA5BLfAkHoBHm
AsE4OrA4QlAkC073gaEgK3nspvrtQhCVJCA0acPIdQKmQDT3OWpYSbcdIYiF
gYFggiAgfPMLnkm2wKOOJGooAt29dth5vRlmg0UcXEzpfMjp3A70d5vpWL5S
VeuNaYG7y7DkOnNGvCGAgIiEIUgXM6uHT04u0wFtXUZwET0GXdJ1rYbCcyY4
1bljxLYHQUxpDuBzbWOPWA3VDLdPjpgAhgSAixcveFilrLGAMCNRcbTMwYst
RWiqyoaUCgvbvc3hqZZShgKjTZwiyXxt54K8TMBY5exAZu5CbZbHDYVTbfg2
D1PCLy+3dDKHmGTLRCT6HyIWdtjY68dBkqXGW/NM5NLQ41YWFwGdSxQbPPQJ
48cYkfTmkq5S5UcXRYLWCzkTwY2ctk3HRhOuNJXohybhgmMt5tRHDBRjFtLo
YRwIUIhR0wAV1sW230CRL5fhjPjmJeMAHYfLcl4AMlE0mjjAc5XJYdtvnRju
RsqIjLUm5IcBUKEDwstrjgEsWqIbCq6pCvtydeeYtQk6FnQgjCGQ9ObjJnw7
qYn9MuAt3gJh7ju2nrnLwJQMFmlozex4tB2VHZIXFPeZFu6b0bjGclj59F4t
KcnBDsNpNJtNY2HQz2M4RymcGAcQV6a3uNnWWA29ROPrp7/tgnPka9DwLIdW
mrVnc7pd1o0aNEGYMHJdVvporZwWBGLhXcQCNMEPFBDVuGLCQZNNpYdppEBw
lrO0tjRHZlGSsmTJDgZgyO0cFnF20KrFTFKBGRZakmrfIkuVhxQMgaFKMg3c
mzMTeaZlp008z3ma3cMJlDr8InsEkfIxssWDGTGhkomJlgppggghIyxZnBxm
cbJhsGowZMwcwYyxnGbIYcZkmSiGCYlhmZklgmggIZJiHEKoDBD1EHUCZoAi
m6AohfNqpIcseOPO6uMiDRUZ/msxHwIAav0FAl2cPKrZPIznQEA5CAEQ3v4J
EmEosw1yjxEH2j7mnuKIUa72vqoAUz3nQQdFm3B2lpNlucvhr0CAGXx9bWSI
B4LRNuCFHkSiQg3RbxBxCUU2EbZGYi2Y8Ig50REnsi6FACODwJZNL7p7giJD
4CIngg0Q56KAPuHs+r3/9E9hq5yiWYSnzMoN2VQasXCeG6LkEAMwk4gyIPXX
HyH4zRvQkAoHvbx+An/i7kinChIT34dk4A==
NEWTHEMEFILE
     if [[ ! -f ${ltspice_theme_file} ]]; then
        # Nothing exists since before so just install it
        mv ${ltspice_theme_file_new} ${ltspice_theme_file}
     else
        # There is  previous version. Unfortunately there is no
        # easy way to do a robust update by patching and merging
        # any new schemas (or deleted) schemas done locally with
        # updates in the new version. This would require a 3-way merge.
        # So we do a 80/20 solution  that will be good for 80%
        # of all users. We copy the original (if different) to a 
        # backup and write the new file.
        cd ${ltspice_theme_dir}

        # Check if there is a difference
        typeset diff_filename="diff.txt"
        diff "${ltspice_theme_file_new}" "${ltspice_theme_file}" > "${diff_filename}"
        if [  -s "${diff_filename}" ]; then
            # There is a difference so create a backup copy
            cp "${ltspice_theme_file}" "${ltspice_theme_file}.BACKUP"
            mv "${ltspice_theme_file_new}" "${ltspice_theme_file}"
            noticelog "Theme file updated. Original theme file saved as ${ltspice_theme_file}.BACKUP"
        else
            noticelog "Theme files are identical. No backup necessary."
        fi
        rm "${diff_filename}"
     fi

     return 0
}

# Dump the current configuration in the plist file as new named theme
# Arg 1: theme name
# Arg 2: theme file to dump values to
# Arg 3: plist file
dump_current_theme() {
    typeset -a fields
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

    typeset theme_name=$1
    typeset theme_file=$2
    typeset plist_file=$3

    # If the theme file exist then check that the given theme name doesn't already exist
    if [[ -f ${theme_file} ]]; then
        theme_exists ${theme_file} ${theme_name}
        if [[ $? -eq 0 ]]; then
            errlog "Theme name '${theme_name}' already exist in theme file '${theme_file}'."
            exit 1
        fi
    fi

    verboselog "Dumping current color setup from '%s' to '%s' as theme '%s'\n" $3 $2 $1
    touch ${theme_file}

    # We don't support using a theme comment when dumping so just leave it blank
    typeset theme_comment=""
    echo "${theme_comment}" >>${theme_file}
    echo "[${theme_name}]" >>${theme_file}

    for field in ${fields[@]}; do
        val=$(plutil -extract ${field} raw -expect integer -n ${plist_file})
        if [[ $? -eq 0 ]]; then
            printf "%s=%d\n" ${field} ${val} >>${theme_file}
        else
            errlog "Field '${field}' does not exist in plist."
        fi
    done

    # Mark the end of the theme with a blank line
    echo "" >>${theme_file}

    return 0
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
    typeset theme_file=$1
    typeset theme_name=$2
    typeset theme_name_regex="\[${theme_name}\]"
    typeset -i lineno=0
    typeset -i start_lineno=0
    typeset -i end_lineno=0
    typeset -i intheme=0
    typeset -i n=0

    if [[ ! -f ${theme_file} ]]; then
        errlog "Theme file '%s' does not exist." ${theme_file}
        exit 1
    fi

    theme_exists "${theme_file}" "${theme_name}"
    if [[ $? -eq 1 ]]; then
        errlog "Cannot delete non-existant theme '%s'." "${theme_name}"
        exit 1
    fi

    if [[ ${theme_name} = "default"  ]]; then
        errlog "Cannot delete default theme."
        exit 1
    fi

    # This gets a bit convoluted since we need to keep track also of the immediate
    # line above the theme name since it could be a reference URL to the theme
    # in order to give credit to the creator of the theme.
    while read -r line; do
        lineno=$((lineno + 1))
        if [[ ${line} =~ "${theme_name_regex}" ]]; then
            if [[ intheme -eq 1 ]]; then
                errlog "Corrupt theme file near line %d. Cannot delete theme." "${lineno}"
                exit 1
            fi
            intheme=1
            start_lineno=$lineno
            end_lineno=$lineno
        elif [[ ${intheme} -eq 1 ]]; then
            if [[ -z ${line}  ]]; then
                break
            fi
            n=$((n + 1))
            end_lineno=$((end_lineno + 1))
            if [[ ${n} -ge 35 ]]; then
                errlog "Corrupt theme file near line %d. Cannot delete theme." "${lineno}"
                exit 1
            fi
        fi
    done <${theme_file}

    # Also delete comment and blank line before.
    start_lineno=$((start_lineno - 2))

    if [[ ${verbose_flag} -eq 1 ]]; then
        infolog "Deleting line range [${start_lineno},${end_lineno}] in '${theme_file}'."
        sed -n "${start_lineno},${end_lineno}p" ${theme_file}
        echo ""
    fi

    ask_yn "Are you sure you wish to delete the above theme '${theme_name}' in '${theme_file}'?"
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
        noticelog "${yellow}Theme '${theme_name}' NOT deleted.${default}\n"
        exit 0
    fi

}


# Set a new theme by updating the configuration file in the third argument with the
# named theme.
# Arg1: Theme name
# Arg2: Theme file
# Arg2: LTSpice configuration (plist) file
set_theme() {
    typeset theme_name_regex="\[${1}\]"
    typeset theme_file=$2
    typeset -i intheme=0
    typeset -i n=0
    typeset empty='^[[:space:]]*$'

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
            keypair="^([[:alnum:]]+)=([0-9]+)"
            [[ ${line} =~ ${keypair} ]]
            plutil -replace ${match[1]} -integer ${match[2]} $3
        fi
        if [[ ${line} =~ "${theme_name_regex}" ]]; then
            intheme=1
        fi
    done <${theme_file}
    if [[ ${intheme} -eq 0 ]]; then
        errlog "Specfied theme '%s' does not exist in theme file '%s'." $1 ${theme_file}
        exit 1
    fi

    return 0
}

# Do everything needed to update the theme
# Arg1: Theme name
# Arg2: Theme file
# Arg3: The copied version of the original LTSpice config file that we modify
update_theme() {
    typeset theme_name=$1
    typeset theme_file=$2
    typeset copied_ltspice_file=$3

    # Do the update and check file integrity
    set_theme ${theme_name} ${theme_file} ${copied_ltspice_file}
    plutil -lint ${copied_ltspice_file} >/dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        cp ${copied_ltspice_file} ${ltspice_plist_file}
        if [[ ! $? -eq 0 ]]; then
            errlog "Could not copy '${copied_ltspice_file}' to '${ltspice_plist_file}'."
            exit 1
        fi
        infolog "Successfully updated new theme to '%s'" ${theme_name}
    else
        errlog "Could not update theme, no changes made."
        exit 1
    fi

    # Finally we need to reload the plist-cache for the change to take effect
    defaults read ${ltspice_plist_file} >/dev/null
    [[ ! $? -eq 0 ]] && errlog "Failed to reload cache."

    return 0
}

# Arg1: theme_file (mandatory)
# Arg2: theme_name (mandatory). 
theme_exists() {
    if [[ ! -f $1 ]]; then
        errlog "Can not find theme file '%s'." $1
        exit 1
    fi
   
    while read -r line; do
        if [[ ${line} =~ "\[([-_[:alnum:]]+)\]" ]]; then
            if [[ ${match[1]} == $2 ]]; then
                return 0
            fi
        fi
    done <$1

    return 1
}

# With one argument lists the name of all themes in the theme file and
# with two argument checks of the theme name as a second argument already
# exists in the file. If it exists it sets the return value to 1 (true)
# Arg1: theme_file (mandatory)
# Arg2: theme_name (optional). If submitted then the routine will check if this
#                              name already exists in the theme file
list_themes() {
    typeset -i check_name=0
    typeset -i n=1

    if [[ $# -eq 2 ]]; then
        check_name=1
    fi

    if [[ ! -f $1 ]]; then
        errlog "Can not find theme file '%s'." $1
        exit 1
    fi
   
    [[ $# -eq 1 ]] && verboselog "Listing themes in '%s'" $1
    while read -r line; do
        if [[ ${line} =~ "\[([-_[:alnum:]]+)\]" ]]; then
            if [[ ${check_name} -eq 0 ]]; then
                infolog "%2d. %s" $n ${match[1]}
            else
                if [[ ${match[1]} == $2 ]]; then
                    infolog "Theme '${theme_name}' exists in '${ltspice_theme_file}'"
                    return 0
                fi
            fi
            n=$((n + 1))
        fi
    done <$1

    if [[ $check_name -eq 1 ]] && errlog "Theme '${theme_name}' DOESN'T exists in '${ltspice_theme_file}'"

    return 0
}

# Check if LTSpice has a running process
check_running_ltspice() {
    if [[ ! -z $(pgrep -i ltspice) ]]; then
        errlog "LTSpice is running. Please close application before changing theme."
        exit 1
    fi

    return 0
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
    
    typeset originalcopy="${ltspice_theme_dir}/$(basename ${ltspice_plist_file}.ORIGINAL)"
    [[ ! -f "${originalcopy}" ]] && cp "${ltspice_plist_file}" "${originalcopy}"

    return 0

}

# Dump the entire contet of the LTSpice configuration file in human readable format
print_ltspice_plist() {
    [[ ! -f ${ltspice_plist_file} ]] && errlog "LTSpice plist file not found at '%s'." "${ltspice_plist_file}" && exit 1
    infolog "'${ltspice_plist_file}':\n"
    plutil -p ${ltspice_plist_file}

    return 0
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

typeset -i OPTIND=0
typeset -i dump_flag=0
typeset -i list_flag=0
typeset -i delete_flag=0
typeset -i yes_flag=0
typeset -i quiet_flag=0
typeset -i verbose_flag=0
typeset theme_name=""

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
            infolog "v$version"
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
        theme_name+="${(P)OPTIND}"
        ((OPTIND++))
    fi
done

# Some sanity checks on args
if [[ $list_flag -eq 1 && $delete_flag -eq 1 ]]; then
    errlog "Cannot specify both -l and -x options at the same time."
    exit 1
fi

if [[ $dump_flag -eq 1 && $delete_flag -eq 1 ]]; then
    errlog "Cannot specify both -d and -x options at the same time."
    exit 1
fi

if [[ $dump_flag -eq 1 && $list_flag -eq 1 ]]; then
    errlog "Cannot specify both -d and -l options at the same time."
    exit 1
fi


# Check and create a local theme dir as necesary
init_theme_dir

# Check if this is a newer version or it has never been installed
chk_if_new_version
if [ $? -eq 1 ]; then
    noticelog "Existing theme file will be created or updated to v${version}"
    init_theme_file
    if [ $? -eq 0 ]; then
        echo "${version}" > "${ltspice_version_file}"
        verboselog "Updated to v${version}"
    fi
fi


if [[ $list_flag -eq 1 ]]; then
    if [[ ! -z ${theme_name} ]]; then
        list_themes "${ltspice_theme_file}" "${theme_name}"
    else
        list_themes ${ltspice_theme_file}
    fi
    exit 0
fi

if [[ -z ${theme_name} ]]; then
    errlog "No theme name specified."
    usage $(basename $0)
    exit 1
fi

if [[ ${delete_flag} -eq 1 ]]; then
    delete_theme ${ltspice_theme_file} ${theme_name}
    exit 0
fi

check_running_ltspice
copy_ltspice_plist

if [[ ${dump_flag} -eq 1 ]]; then
    dump_current_theme ${theme_name} ${ltspice_theme_file} ${copied_plist_file}
    exit 0
fi

# The default action with no options is to update the theme
update_theme ${theme_name} ${ltspice_theme_file} ${copied_plist_file}

exit 0
# <EOF>
