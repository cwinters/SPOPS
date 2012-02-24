#!/usr/bin/perl

use strict;
use DBI;
use Log::Log4perl;
Log::Log4perl::init( 'log4perl.conf' );

use SPOPS::Import;
use SPOPS::SQLInterface;

{
    my ( $option ) = @ARGV;
    my $dbh = DBI->connect( 'DBI:Pg:dbname=test' );
    $dbh->{RaiseError} = 1;

    my $table_sql = qq/
      CREATE TABLE import ( import_id SERIAL,
                            name varchar(50),
                            bad int,
                            good int,
                            disco int ) /;
    $dbh->do( $table_sql );

    my $importer = SPOPS::Import->new( 'dbdata' );
    $importer->db( $dbh );
    $importer->table( 'import' );
    $importer->fields( [ 'name', 'bad', 'good', 'disco' ] );
    $importer->data( [ [ 'Saturday Night Fever', 5, 10, 15 ],
                       [ 'Grease', 12, 5, 2 ],
                       [ "You Can't Stop the Music", 15, 0, 12 ] ] );
    my $status = $importer->run;
    foreach my $entry ( @{ $status } ) {
        if ( $entry->[0] ) { print "$entry->[1][0]: OK\n" }
        else               { print "$entry->[1][0]: FAIL ($entry->[2])\n" }
    }

    unless ( $option eq 'preserve' ) {
        $dbh->do( 'DROP TABLE import' ); # this also drops the sequence...
    }
    $dbh->disconnect;
}
