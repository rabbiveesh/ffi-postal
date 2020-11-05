package Geo::Postal::Structs::Hashes;
use FFI::Platypus::Record;
# ABSTRACT: Structs for near_dupes options

our $VERSION = '0.003';




record_layout( qw/
    bool with_name
    bool with_address
    bool with_unit
    bool with_city_or_equivalent
    bool with_small_containing_boundaries
    bool with_postal_code
    bool with_latlon
    double latitude
    double longitude
    uint32 geohash_precision
    bool name_and_address_keys
    bool name_only_keys
    bool address_only_keys
/);

'hash this out'

__END__

=pod

=encoding UTF-8

=head1 NAME

Geo::Postal::Structs::Hashes - Structs for near_dupes options

=head1 VERSION

version 0.003

=head1 METHODS

=head2 Labels Options

These are boolean options controlling which labels are processed
to create the hashes. They are listed here with their defaults.

=over 4

=item *

with_name = true

=item *

with_address = true

=item *

with_unit = false

=item *

with_city_or_equivalent = true

=item *

with_small_containing_boundaries = true

=item *

with_postal_code = true

=item *

with_latlon = false

=back

=head2 Geohash options

These are options that control the keys generated regarding
latitude and longitude.

=over 4

=item *

latitude  = 0.0 

=item *

longitude = 0.0

=item *

geohash_precision = 6

=back

=head2 Combination Options

These are options about which information you'd like to generate
hashes for matching. The ones about 'name' involve the 'house'
field, for matching things like 'electric company' or 'Franklin
University'.

These are not exclusive options, they each generate a different
set of hashes.

=over 4

=item *

name_and_address_keys = true

=item *

name_only_keys = false

=item *

address_only_keys = false

=back

=head1 AUTHOR

Avishai Goldman <veesh@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2019 by Avishai Goldman.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
