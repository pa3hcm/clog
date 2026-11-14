#!/usr/bin/perl
# Recognition of the arguments of 'clog add' and 'clog update'.

use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/lib";
use CLogTest;

CLogTest::load();

my @cases = (
	# Callsigns
	[ 'pa3hcm',      'is_callsign' ],
	[ 'PA3HCM',      'is_callsign' ],
	[ 'f5jdg/p',     'is_callsign' ],
	[ 'pa/dl1abc',   'is_callsign' ],
	[ 'kh6/w1aw',    'is_callsign' ],
	[ 'pa100mgy',    'is_callsign' ],    # special event, 3 digits
	[ 'dq2006x',     'is_callsign' ],    # special event, 4 digits
	[ '9a287r',      'is_callsign' ],    # starts with a digit
	[ '4x1abc/p',    'is_callsign' ],
	[ '2e0xyz/m',    'is_callsign' ],
	[ 'call=ef6',    'is_callsign' ],    # forced
	[ 'call=c4fm',   'is_callsign' ],    # forced, looks like a mode
	# Frequencies
	[ '14m',         'is_freq' ],
	[ '7m',          'is_freq' ],        # single digit
	[ '3500k',       'is_freq' ],
	[ '14.074m',     'is_freq' ],
	[ '144.300M',    'is_freq' ],
	# Modes
	[ 'cw',          'is_mode' ],
	[ 'USB',         'is_mode' ],
	[ 'ft8',         'is_mode' ],
	[ 'FT4',         'is_mode' ],
	[ 'psk31',       'is_mode' ],
	[ 'msk144',      'is_mode' ],
	[ 'c4fm',        'is_mode' ],        # mode wins over callsign
	[ 'd-star',      'is_mode' ],        # alias
	[ 'pactor',      'is_mode' ],        # alias
	[ 'sstv',        'is_mode' ],
	# Reports
	[ 't599',        'is_rst_tx' ],
	[ 'r579',        'is_rst_rx' ],
	[ 't59a',        'is_rst_tx' ],
	[ 'r59+20',      'is_rst_rx' ],
	[ 'r59+20dB',    'is_rst_rx' ],
	[ 't-10',        'is_rst_tx' ],      # dB report
	[ 'r+05',        'is_rst_rx' ],
	# Locator, contest exchange
	[ 'loc=jo21',    'is_locator' ],
	[ 'loc=jo21ox',  'is_locator' ],
	[ 'LOC=JO21OX12','is_locator' ],
	[ 'txs=12',      'is_serial_tx' ],
	[ 'rxs=345',     'is_serial_rx' ],
	[ 'txd=ut',      'is_data_tx' ],
	[ 'rxd=abc',     'is_data_rx' ],
	# Date and time
	[ '2026-11-14',  'is_date' ],
	[ '12:34',       'is_time' ],
	[ '9:05',        'is_time' ],
	# Comments
	[ 'nice',        'unknown' ],
	[ 'Adrian,',     'unknown' ],
	[ 'EF6',         'unknown' ],        # needs call=
);

foreach my $case (@cases) {
	my ($arg, $expected) = @$case;
	is(get_type($arg), $expected, "$arg is $expected");
}

# A locator without loc= looks like a callsign; 'clog add' then uses it
# as the start of the comments (see add_entry).
is(get_type('JN62PI'), 'is_callsign', 'JN62PI looks like a callsign');

is(normalize_mode('amtor'),  'TOR',   'AMTOR is stored as TOR');
is(normalize_mode('D-STAR'), 'DSTAR', 'D-STAR is stored as DSTAR');
is(normalize_mode('bpsk31'), 'PSK31', 'BPSK31 is stored as PSK31');
is(normalize_mode('usb'),    'USB',   'USB is stored as USB');

done_testing();
