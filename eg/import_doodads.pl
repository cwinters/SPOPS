#!/usr/bin/perl

# $Id: import_doodads.pl,v 3.1 2004/01/10 02:49:58 lachoy Exp $

# To use this, first edit My/Common.pm with your database information
# and then run (mysql example)

# $ mysql test < users_groups_mysql.sql
# $ perl stock_user_group.pl

use strict;
use Log::Log4perl;
Log::Log4perl::init( 'log4perl.conf' );

use SPOPS::Import;

require My::Security;
require My::User;
require My::Doodad;

{
    my $import = SPOPS::Import->new( 'object' )
                              ->data_from_fh( \*DATA );
    my $status = $import->run;
    foreach my $item ( @{ $status } ) {
        print "Status for $item->[1][0]: ";
        if ( $item->[0] ) { print "OK\n" }
        else              { print "FAILED ($item->[2])\n" }
    }
}

__DATA__
$item = [
  { spops_class => 'My::Doodad',
    field_order => [ qw/ name description unit_cost factory created_by / ] },
  [q{Amazing Melonhead}, q{Spits seeds}, q{100.75}, q{Saskatoon, Saskatchewan, Canada}, q{2}],
  [q{Dipsy Doodler}, q{Who knows?}, q{5.00}, q{Chicago, Illinois, USA}, q{2}],
  [q{Greg Kihn Band}, q{I lost on Jeopardy}, q{11.99}, q{Topeka, Kansas, USA}, q{2}]
];
