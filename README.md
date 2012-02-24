# SPOPS: Simple Perl Object Persistence with Security

## QUICK INSTALL NOTE

Installing via the CPAN shell is always a good thing, otherwise just
do the standard:

    perl Makefile.PL
    make 
    make test (see 'RUNNING TESTS' below)
    make install

Note that the first step will ask you a few questions that determine
which tests are run.

Also, there is a 'Bundle' for SPOPS. If you're using the CPAN shell,
just do:

    perl -MCPAN -e 'install Bundle::SPOPS'

Easy!

## RUNNING TESTS

Tests are designed to run without human intervention, although you can
set parameters if you like: run 'perl Makefile.PL MANUAL=1' for the
build process to query you.

DBI tests use the following environment variables as specified by DBI:

    DBI_DSN        - (mandatory) DBI:DriverName:xxx 
    DBI_USER       - (optional) username
    DBI_PASS       - (optional) password for DBI_USER

LDAP tests use the following environment variables:

    LDAP_BASE_DN   - (mandatory) Base DN of server
    LDAP_HOST      - (default: localhost) hostname or IP
    LDAP_PORT      - (default: 389) port number
    LDAP_BIND_DN   - (optional) DN for authentication
    LDAP_BIND_PASS - (optional) Password for authentication

## WHAT IS IT?

SPOPS is a robust and powerful module that allows you to serialize
objects. It is unique in that it also allows you to apply security to
these objects using a fairly simple but powerful scheme of users and
groups. (You can, of course, turn off security if you want.)

It's also unique in that for most objects, you will not need to write
any code. It's true! A fairly simple configuration file is all you
need which you can then feed to SPOPS and have a class for your object
ready to go, right out of thin air.

The configuration you specify not only lists the properties of the
object and possibly some information about where its data should be
stored, but can also describe the relationship an object might have
with another object (or objects).

One great benefit is that you can retrofit SPOPS to existing data. If
you don't use any of the metadata layers or security, you can simply
describe your data in a configuration file, process the configuration
and start making (and processing) objects! If you want to add security
to these objects later, it's easy!

## SHOW ME THE CODE!

Here's a sample session to show how easily you can access existing
data in an object-oriented fashion. In it, we have a simple
configuration which names the table in our database and the primary
key field. We process the config, then fetch a group of objects based
on criteria passed in from the command-line.

Just set the variables starting the file to your relevant information.

    #!/usr/bin/perl
    
    use strict;
    use SPOPS::Initialize;
    
    my $TABLE        = 'mytable';
    my $ID           = 'id';
    my $DSN          = 'DBI:mysql:test';
    my $USER         = 'test';
    my $PASS         = 'test';
    
    {
        my ( $search_field, $search_value ) = @ARGV;
        unless ( defined $search_field and defined $search_value ) {
            die "Usage $0 search-field search-value\n";
        }
        my $config = {
          generic => {
            class          => 'My::Object',
            isa            => [ 'SPOPS::DBI' ],
            rules_from     => [ 'SPOPS::Tool::DBI::Datasource',
                                'SPOPS::Tool::DBI::DiscoverField' ],
            field_discover => 'yes',
            id_field       => $ID,
            base_table     => $TABLE,
            dbi_config     => { dsn      => $DSN,
                                username => $USER,
                                password => $PASS },
          } };
        SPOPS::Initialize->process({ config => $config });
        my $iter = My::Object->fetch_iterator({ where => "$search_field = ?",
                                                value => [ $search_value ] });
        while ( my $o = $iter->get_next ) {
            print "Object: (", $o->id, ")", "\n",
                  join( "\n",
                        map { "$_: $o->{ $_ }" }
                            @{ My::Object->field_list } ), "\n\n";
        }
    }


## APPLICATION-SPECIFICITY 

For some time, this library was tied relatively closely to the
OpenInteract project (www.openinteract.org, or check out the CPAN
module OpenInteract). However, it can easily stand on its own two feet
-- we've used it like this without any problem. But there might be a
few assumptions lurking around the code somewhere. If you spot
something that looks totally out of place or appears to have no real
purpose, let us know!


## WHAT DATABASES ARE SUPPORTED RIGHT NOW?

Following is a list of supported databases. Note that *ANY* DBI
database should work fine for read-only operations -- just use
'SPOPS::DBI' in the 'isa'.

* Interbase/FirebirdSQL (using DBD::InterBase and
  SPOPS::DBD::InterBase)
* Microsoft SQL Server (using DBD::ODBC and SPOPS::DBI::Sybase)
* MySQL (using DBD::mysql and SPOPS::DBI::MySQL
* Oracle (using DBD::Oracle and SPOPS::DBI::Oracle)
* PostgreSQL (using DBD::Pg and SPOPS::DBI::Pg)
* SQLite (using DBD::SQLite and SPOPS::DBI::SQLite)
* Sybase Adaptive Server Enterprise (using DBD::Sybase and
  SPOPS::DBI::Sybase)
* Sybase Adaptive Server Anywhere (using DBD::ASAny and
  SPOPS::DBI::Sybase)
* ODBC datasources; we have used this to access DB2 on
  an AS/400 for read-only operations and it worked great.

We also support:

* LDAP (using Net:::LDAP -- if you have a need for access using
  another client, let us know)
* GDBM (using GDBM_File)

## DO YOU HAVE A LIBRARY FOR <insert name here>?

Maybe. Future development should include:

* DB2 (using DBD::DB2)
* CORBA (likely using CORBA::ORBit in the beginning)

Have something you want implemented? Let us know! We might be able to
help you out. Or you might be able to give something back to the
community by funding development -- all LDAP functionality in SPOPS
was funded by MSN Marketing Service Nordwest, GmbH.

## HOW DO I SAY IT?

It's usually pronounced so it rhymes with 'mess mops', although you're
free to make up your own.


## WHERE CAN I LEARN MORE?

If you want to learn more about how to use SPOPS, read the
documentation! Once you've installed SPOPS, start out with:

    $ perldoc SPOPS::Manual

And follow pointers from there.

## IDEAS? SUGGESTIONS? PATCHES?

Send them in! We welcome patches and try to keep on top of new
developments (such as new DBD drivers) as much as possible. Send
everything to the openinteract-dev mailing list (info below).

## CONTACT

This module is supported by the openinteract-help (for help) and
openinteract-dev (for developers) mailing lists. Find out more about
them at:

    http://lists.sourceforge.net/lists/listinfo/openinteract-help
    http://lists.sourceforge.net/lists/listinfo/openinteract-dev

Also check out the SPOPS website and SourceForge project for
up-to-date versions, support information, party hat designs, etc.
 
    http://spops.sourceforge.net/
    http://sourceforge.net/projects/spops/

## AUTHORS

Chris Winters <chris@cwinters.com> is the primary author of
SPOPS. (Sourceforge name: 'lachoy')

Other folks who have had a hand to some degree or other:

* Ray Zimmerman <rz10@cornell.edu>
* Vsevolod (Simon) Ilyushchenko <simonf@cshl.edu>
* Christian Lemburg <lemburg@aixonix.de>
* Marcus Baker <mbaker@intes.net>
* Rusty Foster <rusty@kuro5hin.org>
* Rick Myers <rik@sumthin.nu>
* Harry Danilevsky <hdanilevsky@DeerfieldCapital.com>
* Leon Brocard <acme@astray.com>
* David Boone <dave@bis.bc.ca>

## COPYRIGHT AND DISCLAIMER

SPOPS is Copyright (c) 2001-2002 by intes.net, inc and 2003-
Chris Winters. All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the terms of the Perl Artistic License or the GNU General
Public License as published by the Free Software Foundation; either
version 2 of the License (see 'COPYING'), or (at your option) any
later version.
