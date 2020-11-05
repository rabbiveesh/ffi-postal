package Geo::Postal::Structs;
# ABSTRACT: Exports the C level options structs

our $VERSION = '0.003';

use Import::Into;

sub import {
  my $target = caller;
  Geo::Postal::Structs::Hashes->import::into($target);
  Geo::Postal::Structs::Expansions->import::into($target);
  Geo::Postal::Structs::Parser->import::into($target);
  Geo::Postal::Structs::ParserResponse->import::into($target);
  Geo::Postal::Structs::Duplicates->import::into($target);
}

sub unimport {
  my $target = caller;
  Geo::Postal::Structs::Hashes->unimport::out_of($target);
  Geo::Postal::Structs::Expansions->unimport::out_of($target);
  Geo::Postal::Structs::Parser->unimport::out_of($target);
  Geo::Postal::Structs::ParserResponse->unimport::out_of($target);
  Geo::Postal::Structs::Duplicates->unimport::out_of($target);
}

'ship em out'

__END__

=pod

=encoding UTF-8

=head1 NAME

Geo::Postal::Structs - Exports the C level options structs

=head1 VERSION

version 0.003

=head1 AUTHOR

Avishai Goldman <veesh@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2019 by Avishai Goldman.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
