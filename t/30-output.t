#!/usr/bin/perl
# Formatting of 'clog list' lines and of the exports.

use strict;
use warnings;
use utf8;
use Test::More;
use Encode qw(encode decode);
use FindBin;
use lib "$FindBin::Bin/lib";
use CLogTest;

CLogTest::load();

# clog works with UTF-8 bytes (as stored in the database)
sub bytes { return encode('UTF-8', shift) }
sub text  { return decode('UTF-8', shift) }

# fit_width: cut by terminal columns, mark cut-off text with '>'
is(fit_width('short', 10),                 'short',        'short text is kept');
is(fit_width('short   ', 10),              'short',        'trailing spaces are removed');
is(fit_width('short', 10, 1),              'short     ',   'padding to the full width');
is(fit_width('exactly 10', 10, 0, 1),      'exactly 10',   'text that fits gets no marker');
is(fit_width('exactly 10    ', 10, 0, 1),  'exactly 10',   'cutting off only spaces gets no marker');
is(fit_width('this is too long', 10),      'this is to',   'long text is cut');
is(fit_width('this is too long', 10, 0, 1),'this is t>',   'cut-off text ends with >');
is(fit_width("tab\there", 10),             'tab here',     'tabs become a space');
is(text(fit_width(bytes('Jürgen München'), 10)), 'Jürgen Mün', 'accented characters count as one column');
is(text(fit_width(bytes('東京都千代田区'), 7)), '東京都',   'wide characters count as two columns');
is(text(fit_width(bytes('東京都千代田区'), 7, 0, 1)), '東京>', '... and are never split');

# short_callsign: callsigns are shortened in 'clog list' only
is(short_callsign('PA3HCM'),           'PA3HCM',       'short callsign is kept');
is(short_callsign('LZ130LO/QRPP'),     'LZ130LO/QRPP', '12 characters fit');
is(short_callsign('PA100MGY/QRPP'),    'PA100MGY/QR>', '13 characters are shortened');
is(short_callsign('ON65SUSKEENWISKE'), 'ON65SUSKEEN>', '16 characters are shortened');

# list_columns: known columns, unknown ones give a warning
{
	my $warning = '';
	local *STDERR;
	open(STDERR, '>', \$warning);
	is_deeply([ list_columns("callsign\tqso_date  band coments") ], [ 'callsign', 'qso_date', 'band' ], 'list_columns splits on any whitespace');
	like($warning, qr/unknown column 'coments'/, 'unknown column gives a warning');
}

# Exports
is(html_escape(q{<b>"Tom" & 'Jerry'</b>}), '&lt;b&gt;&quot;Tom&quot; &amp; &#39;Jerry&#39;&lt;/b&gt;', 'HTML escaping');
is(csv_quote('say "hi"'), '"say ""hi"""', 'CSV quoting doubles quotation marks');
is(csv_quote(undef),      '""',           'CSV quoting of an empty value');
is(adif_field('CALL', 'PA3HCM'),       '<CALL:6>PA3HCM',       'ADIF field');
is(adif_field('QSO_DATE', '20261114', 'D'), '<QSO_DATE:8:D>20261114', 'ADIF field with data type');
is(adif_field('COMMENT', ''),          '',                     'empty ADIF field is left out');

done_testing();
