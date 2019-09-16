use strict;
use warnings;
package FFI::Postal;
use Exporter::Shiny;
# ABSTRACT: FFI bindings for libpostal, an address parsing and deduping library

our $VERSION = '0.001';

=head1 SYNOPSIS

libpostal is a C library with bindings available in many languages.
There's even a perl version, but it isn't up to date with the new
features which have been added since 2018. This is an attempt to
achieve parity with the official bindings, and even provide a more
intuitive, perl-y interface to the library.

=cut


1;
