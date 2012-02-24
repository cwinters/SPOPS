#!/usr/bin/perl

# $Id: table_translate.pl,v 3.1 2004/01/10 02:49:58 lachoy Exp $

# table_translate.pl
#   Takes a table definition from STDIN and performs the built-in
#   transformations on it

use strict;
use Log::Log4perl;
Log::Log4perl::init( 'log4perl.conf' );

use SPOPS::Import;

{
    my $table_type = shift;
    unless ( $table_type ) {
        die "Usage: $0 table-type < spops_table.sql > db_table.sql\n";
    }
    my $table_import = SPOPS::Import->new( 'table' );
    $table_import->database_type( $table_type );
    $table_import->read_table_from_fh( \*STDIN );
    $table_import->print_only( 1 );
    $table_import->run;
}
