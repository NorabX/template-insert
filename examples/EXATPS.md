## Structure Template
#### Node Server Structure
Create a text file `node server.atps` in the structure folder (defined in the package settings) and insert the following code:

![img1](https://raw.githubusercontent.com/NorabX/template-insert/master/img/egs2.png)

###### Explanation
* `app d`: Creates an empty folder _app_
* `views`: Creates a folder, if the next line starts with a tab. Otherwise it creates an empty file _views_
* `index.html "<h2>It works!</h2>"`: Creates _index.html_ that contains the code in qoutes
* `package.json }!}td{...!{ testserver`: Create _package.json_ that contains the same code as in _nodeserver/package.json.atp_ and replace variable `}0{` with _testserver_
* `.gitignore *.coffee`: Creates _.gitignore_ that contains the line _*.coffee_
* `README.md "# README"`: Creates _README.md_ that contains the line _# README_
* `server.coffee }!}td{...!{ 'localhost';8080`: Create _server.coffee_ that contains the same code as in _nodeserver/server.coffee.atp_ and replace variable `}0{` with _'localhost'_ and `}1{` with _8080_
* `server.js`: Creates an empty file _server.js_


Then create a subfolder `nodeserver` in your template folder and add two text files `server.coffee.atp` and `package.json.atp` to `nodeserver`

![img2](https://raw.githubusercontent.com/NorabX/template-insert/master/img/egs3.png)

![img3](https://raw.githubusercontent.com/NorabX/template-insert/master/img/egs4.png)

Reload your Atom, right click at the tree view and click at `Create Structure` -> `node server`

![img4](https://raw.githubusercontent.com/NorabX/template-insert/master/img/egs1.png)

A folder dialog opens. Select the parent folder for your structure and click save. Then you have something like this:

![img5](https://raw.githubusercontent.com/NorabX/template-insert/master/img/egs5.png)
