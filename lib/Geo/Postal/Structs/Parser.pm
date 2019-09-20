package Geo::Postal::Structs::Parser;
use FFI::Platypus::Record;
# ABSTRACT: Struct for the return of parse_address

our $VERSION = '0.001';

=pod

This is a low level implementation of the options for parse_adress. 
It's not really intended to be used directly.

=cut

=method String Options

=for :list
* language
* country
=cut

record_layout( qw/
  string language
  string country
/);

'so many options, so little time!'
