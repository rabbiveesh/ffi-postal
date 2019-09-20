package Geo::Postal::Structs::ParserResponse;
use FFI::Platypus::Record;
# ABSTRACT: Struct for the return of parse_address

our $VERSION = '0.001';

=pod

This is a low level implementation of the return value from parse_adress. 
It provides no usable interface, because it's only meant to be read from.

=cut

record_layout( qw/
  size_t  num_conmponents
  opaque  components
  opaque  labels
/);


'if only C had list return types'
