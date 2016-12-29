# CLog - Command Line Ham Radio Logbook

CLog is a command-line logbook for amateur radio. There is no other
interface available. If you don't like working on a command-line, forget this
software. There's no GUI, TUI or whatever. However, if you can't live without
your command-line, you might love it. At least I do :-)

CLog was originally named Hamlog-CLI, but since lots of ham radio logbooks are
called 'Hamlog' this name would be too confusing. Therefore I renamed it to
CLog.

CLog can be downloaded from http://github.com/pa3hcm/clog.

To contact the author, send an email to pa3hcm<at>amsat<dot>org.


# Copyright

Copyright (C) 2008-2016 Ernest Neijenhuis PA3HCM

This file is part of CLog.

CLog is free software: you can redistribute it and/or modify it under the terms
of the GNU General Public License as published by the Free Software Foundation,
either version 3 of the License, or (at your option) any later version.

CLog is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
CLog. If not, see <http://www.gnu.org/licenses/>.


# Author

CLog is written by Ernest Neijenhuis PA3HCM.

Special thanks to Adrian van Bloois PA0RDA for testing CLog, and providing lots
of ideas on functionality and usability.


# Requirements

* Perl, including DBI and DBD::MySQL
* MySQL server (3.23.23 or higher) and client

CLog is developed and tested on CentOS 5, with the included Perl, perl-DBI,
perl-DBD-MySQL and MySQL. However, it should run on most UNIX/linux platforms.
In some occasions you may have to change the perl path on the first line of the
'clog' file.


# Installation

* Use git to download the latest version:

    cd ~
    git clone https://github.com/pa3hcm/clog.git

* Go into the clog directory:

    cd clog

* Copy files to the desired directories:

    cp clog /usr/local/bin
    chmod 755 /usr/local/bin/clog
    cp clog.1.gz /usr/local/share/man/man1
    cp example.clogrc ~/.clogrc

* Run the following command to create the 'clog' database:

    mysql -u root -p < clog.sql

* Review the configuration file ~/.clogrc. At least set the 'mycall' and
  'mylocator' variables.

    vi ~/.clogrc

* Import the latest cty.dat:

    wget http://www.country-files.com/cty/old/cty.dat
    clog import_cty cty.dat

Consider creating a crontab entry for this, e.g.:

    6 6 * * 1 wget http://www.country-files.com/cty/cty.dat ; \
            clog import_cty cty.dat ; \
            rm cty.dat


# Upgrading

A direct upgrade from CLog 0.4b or older is not possible. Upgrade to CLog 0.5b
first, then upgrade to 1.0.

Upgrading is like installing, except that you mustn't create the 'clog'
database. Instead, run the database upgrade:

    clog dbupgrade

Since we changed the way of upgrading the database in version 0.6b, some users
may see this error when running the 'clog dbupgrade' command:

    DBD::mysql::db do failed: ALTER command denied to user 'apache'@'localhost'
    for table 'qsos' at ./clog line 822, <CONFIG> line 13.

The problem is that the given user is not allowed to modify the database
structure. To solve this, log in to the MySQL client as root, and run the
following queries:

    mysql -u root -p
    Enter password: ********
    mysql> REVOKE ALL PRIVILEGES ON clog.* FROM 'cloguser'@'localhost';
    mysql> GRANT ALL PRIVILEGES ON clog.* TO 'cloguser'@'localhost'; 

Now run the upgrade again:

    clog dbupgrade


# Security

When creating the database, a user 'cloguser' is created with the password
'clogpass'. Maybe you don't want these default credentials. Therefore you can
modify the password of this user in the database using the MySQL client:

    mysql -u root -p
    Password: ******
    mysql> SET PASSWORD FOR 'cloguser'@'localhost' = PASSWORD('new_password');

Now edit/create the .clogrc file in your home directory (see example.clogrc)
and modify the value for dbpass:

    dbpass = new_password


# WordPress plugin

From version 0.11b a simple WordPress plugin is included with CLog. This
plugin allows you to publish your logbook on a WordPress enabled website.
The plugin is a single PHP-script and is named wp-clog.php.

Follow these steps to install the plugin:

* Go to the document root of your WordPress website, e.g.:

    cd /var/www/html

* Go to the directory 'wp-content/plugins'.

    cd wp-content/plugins

* Create a directory called 'wp-clog':

    mkdir wp-clog

* Put the wp-clog.php file in this directory.

* Verify rights are correctly set, e.g.:

    chmod 0755 . wp-clog.php

* Go to your WordPress dashboard using your favourite webbrowser.

* Click on 'Plugins' in the sidebar.

* Look for 'WP-CLog' and click 'Activate'.

* Click 'Settings', customize the given options and click 'Save Changes'.

To list your QSO's on a page or blog post, include this in your content:

    [wpclog-list]

This will include a table with the 25 latest QSO's. If you want to change
this number, use the 'limit' parameter, e.g.:

    [wpclog-list limit=100]

