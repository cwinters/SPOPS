#!/usr/bin/perl

use strict;
use Log::Log4perl;
Log::Log4perl::init( 'log4perl.conf' );
use SPOPS::Import;

{
    my $table_import = SPOPS::Import->new( 'table' );
    $table_import->database_type( 'sybase' );
    $table_import->read_table_from_fh( \*DATA );
    $table_import->print_only( 1 );
    $table_import->run;
}

__DATA__
CREATE TABLE sys_user (
 user_id       %%INCREMENT%%,
 login_name    varchar(25) not null,
 password      varchar(30) not null,
 last_login    datetime null,
 num_logins    int null,
 theme_id      %%INCREMENT_TYPE%% default 1,
 first_name    varchar(50) null,
 last_name     varchar(50) null,
 title         varchar(50) null,
 email         varchar(100) not null,
 language      char(2) default 'en',
 notes         text null,
 removal_date  datetime null,
 primary key   ( user_id ),
 unique        ( login_name )
)
