package Geo::Postal::Structs;
# ABSTRACT: Exports the C level options structs

our $VERSION = '0.001';

use Import::Into;

sub import {
  my $target = caller;
  Geo::Postal::Structs::Hashes->import::into($target);
  Geo::Postal::Structs::Expansions->import::into($target);
  Geo::Postal::Structs::Parser->import::into($target);
  Geo::Postal::Structs::ParserResponse->import::into($target);
}

sub unimport {
  my $target = caller;
  Geo::Postal::Structs::Hashes->unimport::out_of($target);
  Geo::Postal::Structs::Expansions->unimport::out_of($target);
  Geo::Postal::Structs::Parser->unimport::out_of($target);
  Geo::Postal::Structs::ParserResponse->unimport::out_of($target);
}

'ship em out'
