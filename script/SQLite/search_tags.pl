#!/usr/bin/perl
# ABSTRACT:
our $VERSION = 'v0.0.6';

##~ DIGEST : 321fbfb6857d7a410b6e8f1eeb0239dc

use strict;
use warnings;

package Obj;
use Moo;
use parent 'Moo::GenericRoleClass::CLI'; #provides  CLI, FileSystem, Common
with qw/
  Moo::GenericRole::DB
  Moo::GenericRole::DB::Abstract
  Moo::GenericRole::DB::SQLite
  Moo::Task::SubjectTagDB::Role::Core
  Moo::Task::SubjectTagDB::Role::DB::AbstractSQLite
  /;
has config => (
	is      => 'rw',
	lazy    => 1,
	default => sub { my $self = shift; $self->cfg(); }
);

sub _do_db {
	my ( $self, $res ) = @_;
	$res ||= {};
	$self->sqlite3_file_to_dbh( $res->{db_file} );
}

sub process {
	my ( $self ) = @_;
	$self->_do_db( $self->cfg() );
	my $id_stack = $self->search_tag_string( $self->cfg->{search} );
	use Data::Dumper;
	print Dumper( $id_stack );
}
1;

package main;

main();

sub main {
	my $self = Obj->new();
	$self->get_config(
		[
			qw/
			  db_file
			  search
			  /
		],
		[
			qw/
			/
		],
		{
			required => {
				db_file => "./working_db.sqlite in most cases",
				search  => "search string",
			},
			optional => {}
		}
	);
	$self->process();

}
