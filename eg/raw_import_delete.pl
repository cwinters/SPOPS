#!/usr/bin/perl

use strict;
use DBI;
use SPOPS::Import;

# Run the 'raw_import.pl preserve' first...

{
    my $dbh = DBI->connect( 'DBI:Pg:dbname=test' );
    $dbh->{RaiseError} = 1;

    my $importer = SPOPS::Import->new( 'dbdelete' );
    $importer->db( $dbh );
    $importer->table( 'import' );
    $importer->where( 'import_id >= ?' );
    $importer->add_where_params( '2' );
    my $status = $importer->run();
    if ( $status->[0][0] ) {
        print "OK: $status->[0][1]\n";
    }
    else {
        print "FAILED: $status->[0][2]\n";
    }
}
