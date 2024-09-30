# ABSTRACT : wrap DB::* methods in fastmmap cache
package Moo::Task::SubjectTagDB::Role::CacheWrappers::FastMmap;

our $VERSION = 'v1.0.5';
##~ DIGEST : 26cb968fedd875f975c331395796e904
use Moo::Role;

use Carp qw(cluck confess);
use Cache::FastMmap;

ACCESSORS: {
	has tag_cache_object => (
		is      => 'rw',
		builder => '_build_fastmmap'
	);

}

sub _build_fastmmap {
	my ( $self, ) = @_;

	#TODO: this properly
	my $path = '/tmp/' . time . '_fastmmap';
	warn "Using generated mmap path [$path] ";
	my $cache = Cache::FastMmap->new(
		share_file => $path,
		cache_size => '2m',
	);
	$self->tag_cache_object( $cache );
}

around 'get_tag_id' => sub {
	my ( $orig, $self, $string, $p ) = @_;
	if ( my $id = $self->tag_cache_object->get( $string ) ) {

		# 		warn "cache hit on [$string] :)";
		return $id;
	}
	my $id = $self->$orig( $string, $p );
	$self->tag_cache_object->set( $string, $id );
	return $id;
};

1;
