use Test2::V0;

skip_all 'set the TEST_LEAKS env variable to run this test' unless $ENV{TEST_LEAKS};

use Test::LeakTrace;
use Geo::Postal::FFI;

use Geo::Postal::Structs;

is leaked_count { 
  expand_address
    'franklin university 99 your face ln cleveland ohio 44118 apt 12'
}, 3, 'expand_address does not leak';

no_leaks_ok {
  Geo::Postal::Structs::Hashes->new
} 'making our struct is fine';

no_leaks_ok {
  hash_defaults
} 'casting to our struct is fine' ;


done_testing;
