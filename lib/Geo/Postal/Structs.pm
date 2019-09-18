package Geo::Postal::Structs;

use Import::Into;

sub import {
  my $target = caller;
  Geo::Postal::Structs::Hashes->import::into($target);
  Geo::Postal::Structs::Expansions->import::into($target);

}

sub unimport {
  my $target = caller;
  Geo::Postal::Structs::Hashes->unimport::out_of($target);
  Geo::Postal::Structs::Expansions->unimport::out_of($target);

}

'ship em out'
