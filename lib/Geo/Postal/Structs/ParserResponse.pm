package Geo::Postal::Structs::ParserResponse;
use FFI::Platypus::Record;
# ABSTRACT: Struct for the return of parse_address

our $VERSION = '0.003';


record_layout( qw/
  size_t  num_components
  opaque  components
  opaque  labels
/);


'if only C had list return types'

__END__

=pod

=encoding UTF-8

=head1 NAME

Geo::Postal::Structs::ParserResponse - Struct for the return of parse_address

=head1 VERSION

version 0.003

This is a low level implementation of the return value from parse_adress. 
It provides no usable interface, because it's only meant to be read from.

=head1 AUTHOR

Avishai Goldman <veesh@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2019 by Avishai Goldman.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
