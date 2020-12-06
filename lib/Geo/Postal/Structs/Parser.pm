package Geo::Postal::Structs::Parser;
use FFI::Platypus::Record;
# ABSTRACT: Struct for the return of parse_address

our $VERSION = '0.004';



record_layout( qw/
  string language
  string country
/);

'so many options, so little time!'

__END__

=pod

=encoding UTF-8

=head1 NAME

Geo::Postal::Structs::Parser - Struct for the return of parse_address

=head1 VERSION

version 0.004

=head1 METHODS

=head2 String Options

=over 4

=item *

language

=item *

country

=back

This is a low level implementation of the options for parse_adress. 
It's not really intended to be used directly.

=head1 AUTHOR

Avishai Goldman <veesh@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2019-2020 by Avishai Goldman.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
