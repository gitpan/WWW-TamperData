#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'WWW::TamperData' );
}

diag( "Testing WWW::TamperData $WWW::TamperData::VERSION, Perl $], $^X" );
