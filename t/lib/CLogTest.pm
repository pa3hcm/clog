package CLogTest;

# Loads the functions of bin/clog for testing, without running the main
# routine (which needs a configuration file and a database).

use strict;
use warnings;
use File::Temp qw(tempfile);
use FindBin;

sub load {
	my $script = "$FindBin::Bin/../bin/clog";
	open(my $in, '<', $script) or die "Unable to read $script: $!\n";
	my $source = do { local $/; <$in> };
	close($in);
	my $marker = '# MAIN ROUTINE STARTS HERE';
	my $pos = index($source, $marker);
	die "Marker '$marker' not found in $script\n" if $pos < 0;
	# Keep everything up to the main routine. The Switch source filter
	# only works on files, so write it to a temporary file and load that.
	my ($fh, $file) = tempfile('clog-test-XXXXXX', SUFFIX => '.pl', TMPDIR => 1, UNLINK => 1);
	print $fh "package main;\n" . substr($source, 0, $pos) . "\n1;\n";
	close($fh);
	my $result = do $file;
	die "Unable to load functions from $script: " . ($@ || $! || 'unknown error') . "\n" unless $result;
	return 1;
}

1;
