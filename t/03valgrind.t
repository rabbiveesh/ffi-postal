use Test2::V0;

skip_all 'set the TEST_LEAKS env variable to run this test' unless $ENV{TEST_LEAKS};

use Test::LeakTrace;
use Geo::Postal::FFI;

leaks_cmp_ok { 
  expand_address
    'franklin university 99 your face ln cleveland ohio 44118 apt 12'
} '<', 1;

done_testing;
