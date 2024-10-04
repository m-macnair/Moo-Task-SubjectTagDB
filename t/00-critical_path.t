#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;
use Test::Exception;
use File::Slurp;
use File::Copy;
use Data::Dumper;

my $test_id = time;
diag( "Using test id [$test_id]" );
my $module = $1   || 'Moo::Task::SubjectTagDB::Class::TagForSubject';
use_ok( $module ) || BAIL_OUT "Failed to use $module : [$!]";
dies_ok( sub { new( $module ) } ); #passed a test earlier w/o db init

my $reference_db        = 'etc/db/test_db.sqlite';
my $test_directory_root = 'tmp_test/';
unless ( -d $test_directory_root ) {
	mkdir( $test_directory_root ) || BAIL_OUT "Failed to create absent test temp root directory [$test_directory_root] : [$!]";
}

my $this_test_directory = $test_directory_root . $test_id . '/';

unless ( -d $this_test_directory ) {
	mkdir( $this_test_directory ) || BAIL_OUT "Failed to create test temp directory [$this_test_directory] : [$!]";
}
my $test_db = "$this_test_directory/test_db.sqlite";
copy( $reference_db, $test_db ) || BAIL_OUT "Failed to copy test sql file to  [$this_test_directory] : [$!]";

my $self;

$self = new_ok( $module, [ {db_file => $test_db} ] );
$self->sqlite3_file_to_dbh( $test_db );
my $subject_id = $self->get_subject_id( 'subject 1' );
ok( $subject_id == 1, 'created subject 1' );

{
	my $res = $self->tag_this_subject_id( $subject_id, [qw/funky fresh beats/] );
	is( scalar( @{$res} ), 3, 'Assigned 3 tags to subject 1' );
}

{
	my $res = $self->intersect_search_arref_subject_ids( [qw/funky fresh/] );
	is( $res->[0], 1, 'Got subject 1 from intersect search' );
}

done_testing();
