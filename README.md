![logo](https://raw.githubusercontent.com/NorabX/template-insert/master/img/atoemp_logo.gif)

[![version](https://img.shields.io/apm/v/template-insert.svg)](https://atom.io/packages/template-insert) &nbsp;
[![downloads](https://img.shields.io/apm/dm/template-insert.svg)](https://atom.io/packages/template-insert) &nbsp;
[![Dependency Status](https://david-dm.org/norabx/template-insert.svg)](https://david-dm.org/norabx/template-insert) &nbsp;
[![license](https://img.shields.io/apm/l/template-insert.svg)](https://github.com/NorabX/template-insert/blob/master/LICENSE.md)

Insert templates and file structres! Includes i.a. current timestamp support.

## Usage
#### Controls

* `ctrl-alt-s`: show the scope name of the active text editor grammar
* `ctrl` + `0-9`: insert grammar specific templates
* `ctrl-alt` + `0-9`: insert global templates

#### Variables

* `}f{`: filename without extension
* `}F{`: filename
* `}p{`: absolute file path
* `}a{`: author (settings)
* `}d{`: local date string (default)
* `}D{`: iso date string (default)
* `}` + `0-n` + `{`: local number variables
* `}` + `0-n` + `g{`: global number variables
* `}!` + <i>`file-path`</i> + `!{`: file text import
* `}=` + <i>`any charater`</i> + `{`: custom variables  
* `}oa{`: operating system CPU architecture
* `}oh{`: home directory of the current user
* `}oH{`: hostname of the operating system
* `}op{`: operating system platform
* `}or{`: operating system release
* `}on{`: operating system name
* `}ot{`: default directory for temporary files
* `}sd{`: structure directory
* `}td{`: template directory
* `}v{`: custom variables filename
* `}V{`: absolute path of custom variables file
* `}vd{`: directory of custom varibales file
* `}>` + <i>`shell command`</i> + `<{`: command variables
* `}` <i>`hashname`</i> `=` <i>`any charater`</i> `=` <i>`bytes|binary|hex|base64`</i> `{`: hash code variables

## Changelog
Click [here](https://github.com/NorabX/template-insert/blob/master/CHANGELOG.md) to read it.

## Template Examples
Click [here](https://github.com/NorabX/template-insert/blob/master/examples/EXATP.md) to read it.

## Structure Examples
Click [here](https://github.com/NorabX/template-insert/blob/master/examples/EXATPS.md) to read it.
