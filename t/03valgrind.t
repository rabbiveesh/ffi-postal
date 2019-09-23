use Test2::V0;
use Geo::Postal::FFI;

skip_all 'set the TEST_LEAKS env variable to run this test' unless $ENV{TEST_LEAKS};

eval "use Test::Valgrind ";
my $hi =  parse_address('franklin university 99 your face ln cleveland ohio 44118 apt 12');


done_testing;
