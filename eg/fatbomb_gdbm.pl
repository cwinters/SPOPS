#!/usr/bin/perl

use strict;
use Log::Log4perl;
Log::Log4perl::init( 'log4perl.conf' );
use SPOPS::Configure;
use Data::Dumper  qw( Dumper );

my $GDBM_FILENAME = './spops.gdbm';

my $spops = {
     fatbomb => {
       class        => 'My::ObjectClass',
       isa          => [ qw/ SPOPS::GDBM / ],
       field        => [ qw/ fatbomb_id calories cost name servings / ],
       id_field     => 'fatbomb_id',
     },
};

SPOPS::Configure->process_config( { config      => $spops,
                                    require_isa => 1 } );
My::ObjectClass->class_initialize;

my $object = My::ObjectClass->new( { GDBM_FILENAME => $GDBM_FILENAME, 
                                     id => 'bmac-0912' } );
$object->{calories} = 1500;
$object->{cost}     = '$3.50';
$object->{name}     = "Super Deluxe Jumbo Big Mac";
my $fb_id = eval { $object->save };
if ( $@ ) {
   my $ei = SPOPS::Error->get;
   die "Error found! ($@) Error information: ", Dumper( $ei ), "\n";
}
print "Object saved ok!\n",
      "Object ID: $fb_id\n";

# Comment the next two lines out if you want to inspect the gdbm file
unlink( $GDBM_FILENAME ) 
  || warn "Oops! For some reason I couldn't cleanup after myself and remove the file ($GDBM_FILENAME). Why? $!";
