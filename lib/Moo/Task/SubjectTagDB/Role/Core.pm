# ABSTRACT : Universal activities regardless
package Moo::Task::SubjectTagDB::Role::Core;
our $VERSION = 'v2.0.3';
##~ DIGEST : 9bfd71374121975270011516b669cd44
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

1;
