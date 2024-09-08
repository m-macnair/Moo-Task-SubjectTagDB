# ABSTRACT : Do DB Things using SQLite + SQL Abstract in TagForSubject
package Moo::Task::SubjectTagDB::Role::DB::AbstractSQLite;
our $VERSION = 'v1.0.3';
##~ DIGEST : fb4e44ed1ce0cc1bad40dfe6c4b27912
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

## String to number methods
sub get_subject_id {
	my ( $self, $string ) = @_;
	return $self->select_insert_string_id( $string, 'subject' );
}

sub get_tag_id {
	my ( $self, $string ) = @_;
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

## critical path
sub apply_tag_string_to_subject {
	my ( $self, $string, $subject ) = @_;
	my $subject_id = $self->get_subject_id( $subject );
	my $tag_aref   = $self->tag_string_to_id_aref( $string );
	my @return;
	for my $tag_id ( @{$tag_aref} ) {
		push( @return, $self->get_subject_tag_id( $subject_id, $tag_id ) );
	}
	return \@return;
}

1;