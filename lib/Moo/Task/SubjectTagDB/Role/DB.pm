# ABSTRACT : Do DB Things using  SQL Abstract in TagForSubject
package Moo::Task::SubjectTagDB::Role::DB;
our $VERSION = 'v2.0.9';
##~ DIGEST : 87b99f7cdb4350b784f22bb64d71b761
use Moo::Role;
use Carp qw(cluck confess);

with qw/

  Moo::GenericRole::DB
  Moo::GenericRole::DB::Abstract
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
	Carp::confess( "Subject ID not provided" ) unless $subject_id;
	$self->select_insert_href(
		'subject_tag',
		{
			subject_id => $subject_id,
			tag_id     => $tag_id
		},

		#[qw/id/]
	);
}

#tag_subject_id is a method somewhere
sub tag_this_subject_id {
	my ( $self, $subject_id, $tags ) = @_;

	unless ( ref( $tags ) eq 'ARRAY' ) {
		$tags = [$tags];
	}
	my @return;
	for my $tag ( @{$tags} ) {

		my $tag_id = $self->get_tag_id( $tag );
		push( @return, $self->get_subject_tag_id( $subject_id, $tag_id ) );
	}

	return \@return;
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

sub tag_arref_to_id_aref {
	my ( $self, $tag_arref ) = @_;
	my @return;
	for ( @{$tag_arref} ) {
		my $id = $self->get_tag_id( $_ );
		push( @return, $id );
	}
	return \@return;
}

1;
