# ABSTRACT : Do DB Things using MariaDB + SQL Abstract in TagForSubject
package Moo::Task::SubjectTagDB::Role::DB::MariaDB;
our $VERSION = 'v2.0.9';
##~ DIGEST : e31550b1c9310d012f4f7f4722937672
use Moo::Role;
use Carp qw(cluck confess);

=head1 NAME
	SubSystem::TagForSubject - Assign arbitrary tags ids to arbitrary subject ids
	the _original_ used a caching system
=cut

sub search_tag_array {
	my ( $self, $tags, $p ) = @_;
	$p ||= {};

	# 	warn "here";
	my $q_string = '
		select s.id from subject s
		join subject_tag st 
			on s.id = st.subject_id
		join tag t 
			on st.tag_id = t.id 
		where t.string in
		(' . join( ',', @{$tags} ) . ')
		LIMIT ? 
		OFFSET ? 
		';

	my $limit  = $p->{rows} || 20;
	my $offset = $p->{page} ||= 1;
	$offset = ( $offset - 1 ) * $limit;

	my $sth = $self->query( $q_string, $limit, $offset );
	return $self->get_column_array( $sth );
}

#case to be made for wrapping this in a cache
sub intersect_search_arref_subject_ids {
	my ( $self, $search_tag_arref, $p ) = @_;

	my ( @q_strings, @binds );

	for my $tag_id ( @{$search_tag_arref} ) {
		my ( $q_string, $bind ) = $self->sqla->select( 'subject_tag', [qw/subject_id/], {tag_id => $tag_id} );
		push( @q_strings, $q_string );
		push( @binds,     $bind );
	}
	my $limit  = $p->{rows} || 20;
	my $offset = $p->{page} ||= 1;
	$offset = ( $offset - 1 ) * $limit;

	my $q_string = join( "$/ INTERSECT $/", @q_strings );
	$q_string .= ' limit ? offset ?';

	my $intersect_sth = $self->query( $q_string, @binds, $limit, $offset );
	my $result        = $self->get_column_array( $intersect_sth );

	return $result;
}
