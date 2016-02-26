# template-insert

Insert templates!

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
* `}` + <i>any number</i> + `{`: local number variables
* `}` + <i>any number</i> + `g{`: global number variables

## Examples
#### Markdown Template
* Create a text file "source.gfm.1" in the templates folder (defined in the package settings).

* Insert e.g. `# README FILE` in the text file and save it.

* Open a .md file and press `ctrl-1`.

#### Global Template
* Create a text file "global.1" in the template folder.

* Insert e.g. `A long long default text` in the text file and save it.

* Open any file in press `ctrl-alt-1`.

#### Java Template with Variables

Edit your settings.

![img1](https://raw.githubusercontent.com/NorabX/template-insert/master/img/eg1.png)

Make a template. (example in the template folder)

![img2](https://raw.githubusercontent.com/NorabX/template-insert/master/img/eg2.png)

Type something like this and select the text.

![img3](https://raw.githubusercontent.com/NorabX/template-insert/master/img/eg3.png)

Press `ctrl-1` and you get:

![img4](https://raw.githubusercontent.com/NorabX/template-insert/master/img/eg4.png)
