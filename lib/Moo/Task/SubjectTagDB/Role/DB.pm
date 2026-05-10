# ABSTRACT : Do DB Things using  SQL Abstract in TagForSubject
package Moo::Task::SubjectTagDB::Role::DB;
our $VERSION = 'v2.1.0';
##~ DIGEST : 8c85e8042cbb0c06d7ddb08c54359063
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

	my ( $id,$row, $is_new ) = $self->select_insert_string_id( $string, 'subject' );
	if ( wantarray() ) {
		return ( $id,$row, $is_new );
	} else {
		return $id;
	}
}

sub read_subject_id {
	my ( $self, $string ) = @_;
	return $self->select( 'subject', [qw/*/], {string => $string} )->fetchrow_hashref();

}

sub get_tag_id {
	my ( $self, $string, $p ) = @_;
	my ( $row, $is_new ) = $self->select_insert_string_id( $string, 'tag' );
	if ( wantarray() ) {
		return ( $row, $is_new );
	} else {
		return $row;
	}
}

sub get_subject_tag_id {
	my ( $self, $subject_id, $tag_id ) = @_;
	Carp::confess( "Subject ID not provided" ) unless $subject_id;
	my ( $row, $is_new ) = $self->select_insert_href(
		'subject_tag',
		{
			subject_id => $subject_id,
			tag_id     => $tag_id
		},

		#[qw/id/]
	);

	if ( wantarray() ) {
		return ( $row, $is_new );
	} else {
		return $row;
	}
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
