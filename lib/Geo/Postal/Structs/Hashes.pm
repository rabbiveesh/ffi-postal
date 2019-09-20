package Geo::Postal::Structs::Hashes;
use FFI::Platypus::Record;
# ABSTRACT: Structs for near_dupes options

our $VERSION = '0.001';

=method Labels Options

These are boolean options controlling which labels are processed
to create the hashes. They are listed here with their defaults.

=for :list
* with_name = true
* with_address = true
* with_unit = false
* with_city_or_equivalent = true
* with_small_containing_boundaries = true
* with_postal_code = true
* with_latlon = false
=cut

=method Geohash options

These are options that control the keys generated regarding
latitude and longitude.

=for :list
* latitude  = 0.0 
* longitude = 0.0
* geohash_precision = 6

=cut

=method Combination Options

These are options about which information you'd like to generate
hashes for matching. The ones about 'name' involve the 'house'
field, for matching things like 'electric company' or 'Franklin
University'.

These are not exclusive options, they each generate a different
set of hashes.

=for :list
* name_and_address_keys = true
* name_only_keys = false
* address_only_keys = false

=cut

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
