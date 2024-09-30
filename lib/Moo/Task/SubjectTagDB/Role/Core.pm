# ABSTRACT : implementation agnostic methods
package Moo::Task::SubjectTagDB::Role::Core;
our $VERSION = 'v2.0.4';
##~ DIGEST : 78c0573e994c7250ef305dcb1d961dfd
use Moo::Role;
use Carp qw(cluck confess);

sub process_single_tag_string {
	my ( $self, $tag, $p ) = @_;
	$p ||= {};
	unless ( $p->{no_lc} ) {
		$tag = lc( $tag );
	}

	unless ( $p->{no_snake} ) {
		$tag =~ s/ /_/g;
	}
	chomp( $tag );
	return $tag;
}

sub search_tag_string {
	my ( $self, $string, $want_number, $page ) = @_;
	my @tags = map { '"' . lc( $_ ) . '"' } split( ' ', $string );
	return $self->search_tag_array(
		\@tags,
		{
			rows => $want_number || 20,
			page => $page        || 1
		}
	);
}

1;
