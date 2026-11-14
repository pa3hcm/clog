#!/usr/bin/perl
# Band lookup, locators, bearing and distance.

use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/lib";
use CLogTest;

CLogTest::load();

my @bands = (
	[ '1.840',    '160m' ], [ '3.630',  '80m' ],  [ '7.074',  '40m' ],
	[ '10.136',   '30m' ],  [ '14.074', '20m' ],  [ '18.100', '17m' ],
	[ '21.074',   '15m' ],  [ '24.915', '12m' ],  [ '28.074', '10m' ],
	[ '50.313',   '6m' ],   [ '144.300', '2m' ],  [ '222.100', '1.25m' ],
	[ '432.200',  '70cm' ], [ '1296.2', '23cm' ], [ '10368.1', '3cm' ],
	[ '122250.1', '2.5mm' ],
	[ '5.3',      '' ],     # 60m is not supported yet
	[ '',         '' ],
	[ 'abc',      '' ],
);
foreach my $case (@bands) {
	my ($freq, $band) = @$case;
	is(mhz_to_band($freq), $band, "$freq MHz is band '$band'");
}

ok(valid_locator('JO21'),      'JO21 is a valid locator');
ok(valid_locator('jo21ox'),    'jo21ox is a valid locator');
ok(valid_locator('JO21OX12'),  'JO21OX12 is a valid locator');
ok(!valid_locator('ZZ99'),     'ZZ99 is not a valid locator');
ok(!valid_locator('foo'),      'foo is not a valid locator');
ok(!valid_locator(undef),      'undef is not a valid locator');

my ($lat, $long) = qratoll('JO21');
is(sprintf('%.1f %.1f', $lat, $long), '51.5 5.0', 'JO21 is the center of the square');
($lat, $long) = qratoll('JO21OX');
is(sprintf('%.3f %.3f', $lat, $long), '51.979 5.208', 'JO21OX position');

my ($bearing, $distance) = beardist(qratoll('JO21OX'), qratoll('IO91WM'));
is(sprintf('%.0f %.0f', $bearing, $distance), '264 370', 'JO21OX to IO91WM (London): 264 degrees, 370 km');
($bearing, $distance) = beardist(qratoll('JO21OX'), qratoll('JO21OX'));
is("$bearing $distance", '0 0', 'same locator: no bearing or distance');

{
	my $warning = '';
	local *STDERR;
	open(STDERR, '>', \$warning);
	is(normalize_locator('jo21ox12'), 'JO21OX', '8 character locator is stored as 6 characters');
	like($warning, qr/truncated/, '... with a warning');
}
is(normalize_locator('jo22'), 'JO22', '4 character locator is kept');

done_testing();
