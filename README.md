# README
> A color theme handler for the OSX version of the circuit simulator LTSpice.

## Introduction

This is not meant to be an introduction to either the usage or function of 
the electric circuit simulator **LTSpice** for neither OSX nor Windows. 
It is instead assumed you have basic knowledge of the OSX version of this simulator.

**Note:** This theme manager is unique to OSX and will not in any shape or form work 
on a Windows Machine. Instead see 
[Windows LTSpice theme manager](https://github.com/sakabug/LTspice-themes/blob/main/LTspice-themes.txt) 
if you are looking for a Windows theme manager.

This script is used to create and set a color theme for the OSX version of LTSpice. 
The themes are stored as a plain text file in an human readable and pretty obvious format 
(see the BNF grammar at the end of this README file).

While LTSpice does not inherently support any concept of a color theme the color settings
are stored in an OSX standard plist configuration file that can be updated outside
the LTSpice program.

**A note on the OSX version of LTSpice:** 

While much or all of the core funtionality of the simulator are exctly the same
between the OSX and Windows versions the UI is dramatically different. In fact,
many people are so stumped by the apparent frugility of the OSX version that they
end up using the Windows version under Wine. This is a mistake.

While the OSX version does not adhere to the ususal design guidelines for OSX programs
nor any other similar guidelines and in addition requires some "getting used to" 
it is a highly functional UI that one can claim is superior for professionals 
or even serious amateurs compared to the windows version.

Both the advantage and the drawback of the OSX UI is that it heavily relies on the user 
getting familiar and learning around 8 or 9 keystrokes. Once those keystrokes are
mastered it is usually substantially faster to create a diagram and setup a simulation
in the native OSX version than the Windows dito.

**Why do this as a bash shell script?**

Why oh why was this done as a bash shell script I can hear people cry. Couldn't it be written in [select favourite language] (e.g. Python). Of course it could. However, bash is the lowest common denominator that doesn't require any dependencies and the guiding principle of this has been that it should run out of the box. I did not want to run into "module-hell" of Python. Instead I claim it is perfectly possible to write readable, complex programs using bash, but it is of course not without its limitation. If you envision a program with more than around 500-800 lines of manually written code bash should most definetely not be your first choice. Especially not for the very old version of bash that default ship with OSX (v3.2.57).

So why not write it as a ```zsh``` script? It would be perfectly fine to convert the few bash:ism used to ```zsh``` 
and it might very well be a good idea. But having written bash scripts for a long (long) time it was simply quicker than working around some particulars that differs in zsh that I'm not totally up to speed on.

**Related work**

The inspiration for this work comes from the [Windows LTSpice theme manager](https://github.com/sakabug/LTspice-themes/blob/main/LTspice-themes.txt). While this implementation is widely different in both function, form and implementation the drive to write this came out of friendly "jealousy" that the windows world had this but not the OSX world. In addition for the last couple of years I have been promoting the OSX version of LTSpice as a better version of LTSpice and hence OSx also needed a theme manager. 

# Installation

To use the script either copy the script (```themeltspice.sh```) to some standard location for scripts as per your ```PATH``` variable or create a new directory and copy the file there and run it from this directory.

The script uses the default location of "```~/.ltspice_themes```" to store the theme file as well as some backup files. If the directory does not exist it will be created the first time you run the script. If no theme file exist a default theme file with the LTSpice "default" theme will be created.

In the distribution there is a default theme file "```themes.ltt```". This is a plain textfile which should be pretty obvious. For a BNF gramar please refer to the last section in this README. This default file contains 5 themes

1. default (LTSpice default)
2. sakabug
3. twilight-after-dawn
4. dracula
5. softdark

Themes no 2-4 are taken from the Windows cousin of theme manager (See related work above), "softdark" is a dfferent theme I personally like to use.

From time to time new themes may be added.

> **WARNING!** The format of the OSX and Windows version of the theme files are not compatible since the developer of LTSpice have used different names for the control fields in Windows and the OSX version.

## Known Limitations

- It is not (yet) possible to remove or overwrite an existing theme. For that you have to first manually delete the theme you want to overwrite in the themes file.
- Windows theme files are not compatible with OSX and vice versa.

&nbsp;

# Usage

```
Set or create a named color theme for LTSpice
Usage:
%themeltspice.sh [-f <FILE>] [-d] [-l] [-h] [<THEME>]
-d          : Dump current plist to default or named theme file as specified theme
-f <FILE>   : Use the specified file as theme file
-h          : Print help and exit
-l [<NAME>] : List themes in default or named theme file or íf <NAME> 
              is specified check if <NAME> theme exists
-p          : List content in LTSpice plist file
-q          : Quiet no status output
```

There are two major use cases for the program

1. Set a new theme to be used the next time LTSpice is run
2. Save an existing color configuration you have made as a new theme

In addition to these major use cases there are some supporting function that are available

- List the names of all defined themes in a specific themes file
- Check if a specified theme esists
- Print the **LTSpice** binary configuration file in a human readable format

Before we explain how to perform these tasks we need to discuss where files are stored.

At first run the script will create "```~/.ltspice_theme```" directory if it doesn't exist. This is where the theme file is stored. The default themes file is called "```themes.ltt```" and is a plain text file. The file-extension can be read as "**LT**Spice **T**hemes". By using the "-f" option you can also specify another file to be used a theme file.

> Note: A copy fo the original LTSpice plist configuration file is also stored in the theme directory with the extension ```*.BACKUP```. In case (for some reason) the configuration file gest corrupt you can always restore a clean backup.

Incuded in this distribution is a theme file which contains some themes including the LTSpice default theme. 

The included themese are listed in the ***Installation** section above.

&nbsp;

## Selecting a new theme

If we assume you have installed the script somewhere in your path you can now set the ```softdark```theme as so

```
$> themeltspice softdark
``` 

This will update the current LTSpice configuration file with this color schema. To restore back to the default schema just do

```
$> themeltspice dafault
``` 

and there is nothing more to it. The settings are done in an atomic way so a change go through totally successfull or not at all. This way you cannot end up with a half-updated configuration file.

> Atomic update: The way this is done is by first copying the config file to the ```.ltspice_theme``` directory, do the changes, run a integrity verification on the config file and then copy it back to the application location (i.e. ```/Users/<USER>/Library/Preferences/com.analog.LTspice.App.plist)```)

## Storing a configuration as a theme

By first creating a color schema in LTSpice it can then be saved as a new theme. So if you want to store your settings as the new theme, say, "```mytheme```" you use the "```-d```" (=dump) option as such

```
$> themeltspice -d mytheme
Dumping current color setup from 'com.analog.LTspice.App.plist' to '/Users/ljp/.ltspice_themes/themes.txt' as theme 'mytheme'
$> _
```

This will store the new theme at the end of the existing theme file. If a theme with this name already exsts an error message will be printed informing about this.

## Listing all themes available

To see a list of all themes defined use the "```-l```" option as

```
$> themeltspice -l 
Listing themes in '/Users/<USER>/.ltspice_themes/themes.txt''
 1. default
 2. sakabug
 3. twilight-after-dawn
 4. dracula
 5. softdark
$> _
```

### Checking if a named theme exists

Use the '```-l```' option with a theme name

```
$> themeltspice.sh -l mytheme
*** ERROR *** Theme 'mytheme' DOESN'T exists in '/Users/<USER>/.ltspice_themes/themes.ltt'
```

or

```
$> themeltspice.sh -l default
Theme 'default' exists in '/Users/ljp/.ltspice_themes/themes.ltt'
```


## Printing a human readable configuration file

To see the complete configuration file (and not only the color settings) use the "```-p```" (=print) option as in

```
$> themeltspice -p
'/Users/<USER>/Library/Preferences/com.analog.LTspice.App.plist' content:{
  "AllowShortedCompPins" => 0
  "AutoDotRawDeletion" => 1

  ...

  "WaveColor11" => 12237492
  "WaveColor12" => 255
  "WaveColor13" => 16748287
}
$> _
```

# How the script works

The configuration file where the **LTSpice** configurations are stored
is a binary configuration file and cannot be directly manipulated. The format
used is a standard OSX *"Property List"* (plist) and as such OSX provides a
command line tool that can be used to manipuate the individual fields in that
property file.

Instead the OSX utility '```plutil```' can be used to read and manipulate individual 
fields in this configuration file.

By default the plist configuration file of LTSpice is stored at:

    /Users/<USER>/Library/Preferences/com.analog.LTspice.App.plist

Since LTSpice updates this file at least on every exit the simulator must be closed before
running this script. This is also checked in the script and an error message is shown
if any running copies are detected.and for this to truly be the case we needed a theme manager.

As an extra precaution the first time the script is run it creates a backup copy of the
configuration file and stores it in the theme directory with the added suffix 
"```.ORIGINAL```".

Since OSX caches all plist files it is not enough to just update the property file
on its own, one must also force a refresh of the propert cash using "```defalt read <PLIST-FILE>```" command. 

## Atomic configuration file update
To minimize the risk of corruption the script never updates the aplication 
configuration file directly. Instead it first creates a copy of of the config file and does
the changes necessary on that copy. The it uses the '```pltutil```' to do an integrity check
och the file and only of this integrity check succeeds does it copy the file to its 
original location where LTSpice looks for it.

## Directories and files used

The default location of themes are

    /User/<USER>/.ltspice_themes/themes.ltt

Copy of the LTSpice application plist file at the time of first run 

    /User/<USER>/.ltspice_themes/com.analog.LTspice.App.plist.ORIGINAL

LTSpice application plist file

    /Users/<USER>/Library/Preferences/com.analog.LTspice.App.plist


# Theme file format

For each theme a total of 34 color parameters are stored as listed in figure 2 below. *Unfortunately there are small differences between the Windows version and OSX version in that some fields have different names in the two versions.* For example the OSX version uses "```GridColor```" while the windows version call it simply "```Grid```". A similar difference is "```InActiveAxisColor```" which in the window version is called "```InActiveAxis```". The window version also have a "```SchematicColor13```" which doesn't exist in the OSX version.

The BNF grammar for the theme file is extremely simple as shown in Figure 1 below

```
themes    ::= theme | theme <EMPTY_LINE> themes
theme     ::= '[' theme-name ']' <NL> fields
fields    ::= field | field <NL> fields
field     ::= fieldname '=' digits
fieldname ::= "" | alnum fieldname
alnum     ::= "A" | "B" | ...
digits    ::= "0" | "1" | ...
 ```
***Fig 1: The simplified BNF grammar for the themes file format***


&nbsp; 

```
GridColor
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
```
***Fig 2: The fields stored as a color theme***


