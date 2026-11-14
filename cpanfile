# Perl dependencies of CLog.
#
# Install them with cpanminus, from the clog directory:
#
#   sudo cpanm --installdeps .
#
# Install system-wide: clog runs in taint mode (perl -T), which ignores
# PERL5LIB, so modules installed with local::lib or Carton are not found.
#
# Or use the packages of your distribution, e.g.:
#   RHEL/AlmaLinux/Rocky: perl-Switch perl-DBI perl-DBD-MySQL
#   SLES/openSUSE:        perl-Switch perl-DBI perl-DBD-mysql
#   Debian/Ubuntu/Mint:   libswitch-perl libdbi-perl libdbd-mysql-perl
#
# Building DBD::mysql from CPAN requires a C compiler and the MySQL or MariaDB
# client development files (e.g. mysql-devel or mariadb-connector-c-devel, or
# libmysqlclient-dev or libmariadb-dev and libmariadb-dev-compat). DBD::mysql
# 5.x only builds with the MySQL 8.x client library; with the MariaDB client
# library, first install the last 4.x version:
#
#   sudo cpanm DBD::mysql@4.052

# The oldest Perl in a supported distribution (RHEL 8 and clones, SLES 15).
# CLog is tested with all Perl versions from 5.26 up to the latest release,
# see .github/workflows/tests.yml.
requires 'perl', '5.026';

# Removed from the Perl core in 5.14, so it must be installed separately.
requires 'Switch';

# Database access; DBD::mysql is loaded by DBI through the dbi:mysql: DSN.
# Both 4.x and 5.x work (RHEL 10 and clones ship 5.x).
requires 'DBI';
requires 'DBD::mysql', '4.0';

# Part of the Perl core, listed for completeness.
requires 'Encode';
requires 'POSIX';
