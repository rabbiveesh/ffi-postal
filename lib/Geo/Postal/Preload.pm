package Geo::Postal::Preload;
use strict;
use Test2::Harness::Runner::Preload;

use Geo::Postal::FFI;

stage Postal => sub {
  default();
  load_parser
};

1
