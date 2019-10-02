package Geo::Postal::Preload;
use base Test2::Harness::Preload;

use Geo::Postal::FFI;

sub preload {
  load_parser
}

1
