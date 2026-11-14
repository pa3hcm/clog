#!/usr/bin/perl
# bin/clog must compile with the Perl that runs the tests. The Switch source
# filter behaves differently between Perl versions, so run the tests with
# both an old (e.g. 5.26) and a new Perl when changing the code.

use strict;
use warnings;
use Test::More;
use FindBin;

my $script = "$FindBin::Bin/../bin/clog";
my $output = `"$^X" -T -c "$script" 2>&1`;
is($?, 0, "bin/clog compiles with Perl $^V") or diag($output);
like($output, qr/syntax OK/, 'perl -c reports syntax OK');

done_testing();
