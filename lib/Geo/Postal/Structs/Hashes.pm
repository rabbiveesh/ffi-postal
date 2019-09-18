package Geo::Postal::Structs::Hashes;
use FFI::Platypus::Record;

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
