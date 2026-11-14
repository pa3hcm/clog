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
#   AlmaLinux/RHEL: perl-Switch perl-DBI perl-DBD-MySQL
#   Debian/Ubuntu:  libswitch-perl libdbi-perl libdbd-mysql-perl
#
# Building DBD::mysql from CPAN requires the MySQL or MariaDB client
# development files (e.g. mariadb-connector-c-devel or libmariadb-dev).

# s///r (used by import_cty) needs Perl 5.14. CLog is tested with Perl 5.26
# (AlmaLinux 8), 5.32 (AlmaLinux 9) and 5.40 (Ubuntu).
requires 'perl', '5.014';

# Removed from the Perl core in 5.14, so it must be installed separately.
requires 'Switch';

# Database access; DBD::mysql is loaded by DBI through the dbi:mysql: DSN.
requires 'DBI';
requires 'DBD::mysql';

# Part of the Perl core, listed for completeness.
requires 'Encode';
requires 'POSIX';
