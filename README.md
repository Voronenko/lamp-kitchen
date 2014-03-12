lamp-kitchen
===============

## Required soft on dev box

Note: use parameters --no-ri --no-rdoc only if you are sure that you do not need any documentation locally - improves speed.

Windows setup: I suggest using Ruby Installer approach to install Ruby (http://rubyinstaller.org/downloads/).
Important: make sure that ruby installation path does not contain any spaces or special symbols (like "Program Files", etc).
For example, mine path is  C:\Utils\Ruby193\. 

If you are using Berkshelf, you will need to install Development KIT additionally. It can be downloaded from the same downloads page as Ruby Installer.
Installation instructions: https://github.com/oneclick/rubyinstaller/wiki/Development-Kit
In brief: download, unpack, cd <DEVKIT_INSTALL_DIR>,  ruby dk.rb init,  ruby dk.rb install, done!
Validate installation by running ruby -rubygems -e "require 'json'; puts JSON.load('[42]').inspect"


1. Ruby 1.9.3 & DevKit
2. Test kitchen  (gem install test-kitchen --no-ri --no-rdoc)
3. Kitchen Vagrant (gem install kitchen-vagrant --no-ri --no-rdoc)
4. Berkshelf itself (gem install berkshelf --no-ri --no-rdoc)


##Cooking steps
Assume you have some 3rd party project repository you want to work on. For some reasons it does not allow commiting development specific data into project. 
This repoository provides approach to 'wrap' external repository into your own development environment.

Approach assumes that bash shell is in path (for windows environment it is located in msysgit bin folder)

1.  Define your project cooking recipes in test\integration\site-cookbooks\current_project_setup\ . This may include setting up specific databases, users, plugins, packages etc. Example provided
2.  If your project has recipes from #1, uncomment following line in Berksfile #cookbook 'current_project_setup', path: './test/integration/site-cookbooks/current_project_setup'
3.  in kitchen's run_list  add "recipe[current_project_setup]" to ensure that your project recipe is included in provision process
3.  Define hints for development website in \test\integration\data_bags\sites\ . This may include DNS entries. I propose using localhost catchers like *.lvh.me - saves some time.
3.  Define your dev environment settings in \test\integration\environments\ .  I provide my default setup for vagrant as an example
4.  Roles: \test\integration\roles\ : actually portions from original 'big' approach at https://github.com/Voronenko/chef-developer_bootstrap - instructions to install software bundles specific to your development stack. Note: make sure, that Berksfile and Cheffile in the project root match software packages required.
5.  Register project you want to wrap into .projmodules file.  Syntax of the file is identical to .gitmodules format. Difference it - that wrapped project is not installed as a git submodule, but as fully independent project. Note - you have way to work with multiple projects/sites on the same vagrant box, if needed.
6.  Initialize .projmodules  with running init.sh in the project root
7.  I often use local folder to keep set of files I need to overwrite in original solution to make it run on a vagrant (usually pathes, DB credentials, etc)
8.  Feel free to commit your IDE related configs to parent repository (for example, I commit core settings from JetBrains IDea dev environment. In this way I have the same settings regardless of PC I work on)


## \test\integration sub-folders description

### site-cookbooks
I use this directory to checkout cookbooks that are not available for the public, and are specifically related to project specific environment configuration

### databags
Directory contains optional project specific file artifacts for cookbooks.

### environments
Contains preferences to package versions, vendors and machine wide configuraiton for packages installed

### nodes
Contains instructions to configure predefined set of the software on specific workstation basing on it's role (lamp box, java box, big data box, MEAN box, etc.

### roles
Contains combination of recipes (roles) to configure workstation for predefined needs.
By default roles are:

- lamp_complete - apache php mysql xdebug phpmyadmin webgring mailcatcher
- sql - installs set of tools for efficient work with MySQL (Percona, MariaDB) box
- vagrant - automatically installs sites basing on data bags configuration, configures error reporting to browser for php

##What is in the repository demo box setup?

###common_schema
Installs DBA framework Common_Schema 2.2  [http://code.openark.org/blog/mysql/common_schema-2-2-better-queryscript-isolation-tokudb-table_rotate-split-params](http://code.openark.org/blog/mysql/common_schema-2-2-better-queryscript-isolation-tokudb-table_rotate-split-params) , requires MySQL/MariaDB/Percona to be installed.

Check usage options: [http://www.percona.com/live/london-2013/sites/default/files/slides/common_schema-pllondon-2013_0.pdf](http://www.percona.com/live/london-2013/sites/default/files/slides/common_schema-pllondon-2013_0.pdf)

### mailcatcher
Debug tool to catch emails send from the box. Nicely mocks sendmail and SMTP servers.
[http://mailcatcher.me/](http://mailcatcher.me/)
Web interface available on port **1080**


### mariadb_client
Client packages for mariaDB, note: requires appropriate environment settings in environment file:
<pre>
  "mariadb": {
                   "version":"5.5"
                },
     "mysql" :  {
                   "use_upstart": false,
                   "server_root_password": "devroot",
                   "server_repl_password": "devrepl",
                   "server_debian_password": "devdebian",                   
                   "client": {
                                "packages":["mariadb-client", "libmariadbclient-dev"]
                             },
                   "server": {
                                "packages":["mariadb-server"]
                             }          
                }

</pre>

###mariadb_server
MariaDB server (MySQL compatible) - see notes for **mariadb_client**


###percona_toolkit
Percona Toolkit for MySQL is a collection of advanced command-line tools used by Percona MySQL Support staff to perform a variety of MySQL server and system tasks that are too difficult or complex to perform manually, including:

- Verify master and replica data consistency
- Efficiently archive rows
- Find duplicate indexes
- Summarize MySQL servers
- Analyze queries from logs and tcpdump
- Collect vital system information when problems occur

More: [http://www.percona.com/doc/percona-toolkit/2.2/](http://www.percona.com/doc/percona-toolkit/2.2/)

### php_webgrind
Webgrind is a Xdebug profiling web frontend in PHP5. It implements a subset of the features of kcachegrind and installs in seconds and works on all platforms

- Super simple, cross platform installation - obviously :)
- Track time spent in functions by self cost or inclusive cost. Inclusive cost is time inside function + calls to other functions.
- See if time is spent in internal or user functions.
- See where any function was called from and which functions it calls.
- Generate a call graph using gprof2dot.py

[https://github.com/jokkedk/webgrind](https://github.com/jokkedk/webgrind)

### php_xdebug
Debug extension for PHP

### phpmyadmin

Classic web frontend for mysql, available at /phpmyadmin/ virtual folder

## Enjoy!

#Linked projects: #

Interested in pure Chef template?
See [https://github.com/Voronenko/chef-developer_bootstrap](https://github.com/Voronenko/chef-developer_bootstrap)

Interested in using developer box Chef recipes in your own cookbooks?
See [https://github.com/Voronenko/chef-developer_recipes](https://github.com/Voronenko/chef-developer_recipes)

Interested in building your devbox on top of Vagrant + vagrant-berkshelf plugin?
See [https://github.com/Voronenko/vagrant-wrap](https://github.com/Voronenko/vagrant-wrap)
Note: see following article about future of the vagrant-berkshelf plugin [https://sethvargo.com/the-future-of-vagrant-berkshelf/](https://sethvargo.com/the-future-of-vagrant-berkshelf/)

Interested in building your devbox on top of Vagrant + test-kitchen?
See See [https://github.com/Voronenko/lamp-kitchen](https://github.com/Voronenko/lamp-kitchen) 