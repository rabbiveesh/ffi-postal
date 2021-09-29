package Geo::Postal::Preload;
use strict;
use Test2::Harness::Runner::Preload;

use Geo::Postal::FFI;

stage Postal => sub {
  default();
  load_parser
};

1

__END__

=pod

=encoding UTF-8

=head1 NAME

Geo::Postal::Preload

=head1 VERSION

version 0.005

=head1 AUTHOR

Avishai Goldman <veesh@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2019-2020 by Avishai Goldman.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
