# CLog - Command Line Ham Radio Logbook

**CLog** is a command-line logbook for amateur radio. There is no other
interface available. If you don't like working on a command-line, forget this
software. There's no GUI, TUI or whatever. However, if you can't live without
your command-line, you might love it. At least I do :-)

CLog was originally named Hamlog-CLI, but since lots of ham radio logbooks are
called 'Hamlog' this name would be too confusing. Therefore I renamed it to
CLog.

CLog can be downloaded from <https://github.com/pa3hcm/clog>. Here you can also
raise issues for bugs, feature requests, etc.

To contact the author, send an email to pa3hcm at amsat dot org or visit
the website <https://pa3hcm.nl/>.

## Requirements

These are required:

* Perl 5.26 or newer, with the modules Switch, DBI and DBD::mysql (listed in
  the `cpanfile`)
* MySQL or MariaDB server and client

CLog is tested with all Perl versions from 5.26 up to the latest release, and
on the currently supported releases of Ubuntu (LTS), Debian, RHEL, AlmaLinux,
Rocky Linux, SLES and openSUSE Leap (see `.github/workflows/tests.yml`). Linux
Mint uses the packages of Ubuntu (Mint) or Debian (LMDE). It should run on most
UNIX/linux platforms. In some occasions you may have to change the perl path on
the first line of the `bin/clog` file.

### Installing the Perl modules

The easiest way is to use the packages of your distribution.

On Ubuntu, Debian and Linux Mint:

``` sh
sudo apt install libswitch-perl libdbi-perl libdbd-mysql-perl
```

On RHEL, AlmaLinux and Rocky Linux 9 (perl-Switch is in the CRB repository;
on version 8 this repository is called powertools):

``` sh
sudo dnf config-manager --set-enabled crb
sudo dnf install perl-Switch perl-DBI perl-DBD-MySQL
```

On RHEL, AlmaLinux and Rocky Linux 10, perl-Switch is only available from
[EPEL](https://docs.fedoraproject.org/en-US/epel/):

``` sh
sudo dnf config-manager --set-enabled crb
sudo dnf install epel-release
sudo dnf install perl-Switch perl-DBI perl-DBD-MySQL
```

On SLES and openSUSE Leap:

``` sh
sudo zypper install perl-Switch perl-DBI perl-DBD-mysql
```

**Alternative: install from CPAN with the cpanfile.** If your distribution
doesn't provide these packages, or you prefer CPAN, install the modules listed
in the `cpanfile` with [cpanminus](https://metacpan.org/pod/App::cpanminus),
from the clog directory (see Installation below):

``` sh
sudo cpanm --installdeps .
```

This builds DBD::mysql, which requires a C compiler and the MySQL or MariaDB
client development files (e.g. `libmysqlclient-dev`, or `libmariadb-dev` and
`libmariadb-dev-compat` on Ubuntu/Debian; `mysql-devel` or
`mariadb-connector-c-devel` on RHEL and its clones). DBD::mysql 5.x and newer
only build with the MySQL 8.x client library. With the MariaDB client library,
first install the last 4.x version, then the other modules:

``` sh
sudo cpanm DBD::mysql@4.052
sudo cpanm --installdeps .
```

Install the modules system-wide as shown: clog runs in taint mode (`perl -T`),
which ignores `PERL5LIB`, so modules installed in your home directory
(local::lib) or with Carton are not found.

## Installation

Download CLog from <https://github.com/pa3hcm/clog> and extract the file, or use
git to download the latest development version:

``` sh
cd ~
git clone https://github.com/pa3hcm/clog.git
```

Go into the clog directory:

``` sh
cd clog
```

Install clog and its man page in /usr/local:

``` sh
sudo make install
```

To install somewhere else, set PREFIX, e.g. `make install PREFIX=~/.local`.
Without make, copy the files yourself:

``` sh
sudo install -m 755 bin/clog /usr/local/bin/clog
gzip -9n -c man/clog.1 | sudo tee /usr/local/share/man/man1/clog.1.gz > /dev/null
```

Copy the example configuration file to your home directory:

``` sh
cp examples/clogrc ~/.clogrc
```

Run the following command to create the 'clog' database:

``` sh
mysql -u root -p < sql/clog.sql
```

Review the configuration file ~/.clogrc. At least set the 'mycall' and
  'mylocator' variables.

``` sh
vi ~/.clogrc
```

Import the latest cty.dat:

``` sh
wget https://www.country-files.com/cty/cty.dat
clog import_cty cty.dat
```

Consider creating a crontab entry for this, e.g.:

``` text
6 6 * * 1 wget https://www.country-files.com/cty/cty.dat ; \
            clog import_cty cty.dat ; \
            rm cty.dat
```

## Upgrading

Upgrading is like installing, except that you mustn't create the 'clog'
database. Instead, run the database upgrade:

``` sh
clog dbupgrade
```

This upgrades databases created by CLog 1.0 or newer in one go.

**Upgrading from a version older than 1.0:** the current version of CLog can
not upgrade these databases. First upgrade to CLog 1.2 (git tag `1.2.1`), and
run `clog dbupgrade` with that version until it reports that there is nothing
to do. Then upgrade to the current version as described above.

When running 'clog dbupgrade', you may see an error like this:

``` text
DBD::mysql::db do failed: ALTER command denied to user 'cloguser'@'localhost'
for table 'dxccs'
```

The problem is that the given user is not allowed to modify the database
structure. To solve this, log in to the MySQL client as root, and run the
following queries:

``` sh
mysql -u root -p
Enter password: ********
mysql> REVOKE ALL PRIVILEGES ON clog.* FROM 'cloguser'@'localhost';
mysql> GRANT ALL PRIVILEGES ON clog.* TO 'cloguser'@'localhost'; 
```

Now run the upgrade again:

``` sh
clog dbupgrade
```

## Security

When creating the database, a user 'cloguser' is created with the password
'clogpass'. Maybe you don't want these default credentials. Therefore you can
modify the password of this user in the database using the MySQL client:

``` sh
mysql -u root -p
Password: ******
mysql> SET PASSWORD FOR 'cloguser'@'localhost' = PASSWORD('new_password');
```

Now edit/create the .clogrc file in your home directory (see examples/clogrc)
and modify the value for dbpass:

``` text
    dbpass = new_password
```

## WordPress plugin

From version 0.11b a simple WordPress plugin is included with CLog. This
plugin allows you to publish your logbook on a WordPress enabled website.
The plugin is a single PHP-script: wordpress/wp-clog.php.

Follow these steps to install the plugin:

Go to the document root of your WordPress website, e.g.:

``` sh
cd /var/www/html
```

Go to the directory 'wp-content/plugins'.

``` sh
cd wp-content/plugins
```

Create a directory called 'wp-clog' (use this name, the plugin's 'Settings'
link expects it), and copy the plugin into it, e.g. from your clog directory:

``` sh
mkdir wp-clog
cp ~/clog/wordpress/wp-clog.php wp-clog/
```

Verify rights are correctly set, e.g.:

``` sh
chmod 0755 wp-clog
chmod 0644 wp-clog/wp-clog.php
```

Go to your WordPress dashboard using your favourite webbrowser.

Click on 'Plugins' in the sidebar.

Look for 'WP-CLog' and click 'Activate'.

Click 'Settings', customize the given options and click 'Save Changes'.

To list your QSO's on a page or blog post, include this in your content:

``` text
[wpclog-list]
```

This will include a table with the 25 latest QSO's. If you want to change
this number, use the 'limit' parameter, e.g.:

``` text
[wpclog-list limit=100]
```

## Repository layout

* `bin/clog` - the program
* `man/clog.1` - the clog(1) man page (compressed during installation)
* `sql/clog.sql` - SQL script to create the database
* `examples/clogrc` - example configuration file, copy it to ~/.clogrc
* `wordpress/wp-clog.php` - the WordPress plugin
* `t/` - tests, run them with `make test`
* `cpanfile` - the required Perl modules
* `Makefile` - `make install`, `make uninstall` and `make test`
* `.github/workflows/` - automated tests and linters on GitHub (see Testing)
* `.perlcriticrc`, `.markdownlint-cli2.yaml` - settings of the linters

## Testing

Run the tests from the clog directory:

``` sh
make test
```

The tests don't need a database or configuration file. CLog uses the Switch
module, a source filter that behaves differently between Perl versions. When
changing the code, run the tests with both an old Perl (e.g. 5.26 on AlmaLinux
8) and a new one.

GitHub Actions runs these workflows on every pull request and on every push to
the main branch:

* **Tests** (`tests.yml`) - `make test` with:
  * every Perl version from 5.26 to the latest release: the versions supported
    by the Perl community and the versions of the supported distributions
  * the supported releases of Ubuntu (LTS), Debian, AlmaLinux, Rocky Linux,
    openSUSE Leap and SLES, with the Perl modules installed from their
    packages as described above
  * the modules installed from CPAN with the `cpanfile`, with both the MySQL
    and the MariaDB client library
* **Perl lint** (`perl-lint.yml`) - a compile check and
  [Perl::Critic](https://metacpan.org/pod/Perl::Critic) at severity 4, with
  the settings in `.perlcriticrc`
* **Markdown lint** (`markdown-lint.yml`) -
  [markdownlint](https://github.com/DavidAnson/markdownlint-cli2) on all `.md`
  files, with the settings in `.markdownlint-cli2.yaml`

To run the linters yourself, from the clog directory:

``` sh
perlcritic bin/clog t/
docker run --rm -v "$PWD":/workdir davidanson/markdownlint-cli2:v0.24.1
```

Perl::Critic is packaged as `libperl-critic-perl` (Ubuntu, Debian) or
`perl-Perl-Critic` (RHEL and clones, with EPEL).

## Credits

CLog is written by Ernest Neijenhuis PA3HCM.

Special thanks to Adrian van Bloois PA0RDA for testing CLog, and providing lots
of ideas on functionality and usability.

## License

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <http://www.gnu.org/licenses/>.
