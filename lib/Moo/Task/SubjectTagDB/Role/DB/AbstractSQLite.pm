# ABSTRACT : Do DB Things using SQLite + SQL Abstract in TagForSubject
package Moo::Task::SubjectTagDB::Role::DB::AbstractSQLite;
our $VERSION = 'v2.0.3';
##~ DIGEST : 67fc133387d74a3479ae238f2f3315c1
use Moo::Role;
use Carp qw(cluck confess);

with qw/

  Moo::GenericRole::DB
  Moo::GenericRole::DB::Abstract
  Moo::GenericRole::DB::SQLite
  /;

=head1 NAME
	SubSystem::TagForSubject - Assign arbitrary tags ids to arbitrary subject ids
	the _original_ used a caching system
=cut

#TODO: subject alias - given subject string, determine if it has an alias
## String to number methods
sub get_subject_id {
	my ( $self, $string ) = @_;
	return $self->select_insert_string_id( $string, 'subject' );
}

sub read_subject_id {
	my ( $self, $string ) = @_;
	return $self->select( 'subject', [qw/*/], {string => $string} )->fetchrow_hashref();
}

sub get_tag_id {
	my ( $self, $string, $p ) = @_;
	return $self->select_insert_string_id( $string, 'tag' );
}

sub get_subject_tag_id {
	my ( $self, $subject_id, $tag_id ) = @_;
	$self->select_insert_href(
		'subject_tag',
		{
			subject_id => $subject_id,
			tag_id     => $tag_id
		},

		#[qw/id/]
	);
}

sub tag_string_to_id_aref {
	my ( $self, $tag_string ) = @_;
	my @return;
	for ( split( ' ', $tag_string ) ) {
		my $id = $self->get_tag_id( $_ );
		push( @return, $id );
	}
	return \@return;
}

1;
