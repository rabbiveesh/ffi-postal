use strict;
use warnings;
package Geo::Postal::FFI;
use v5.22;
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

use FFI::Platypus;
use FFI::CheckLib;
use Geo::Postal::Structs;

sub ffi {
  #NOTE- do we really need an ffi singleton? It helps for sharing
  #types, i guess
  state $ffi = FFI::Platypus->new( api => 1 ,
    #TODO- take this out for CPAN 
    experimental => 1);
}

my $ffi = ffi;

$ffi->lib(find_lib_or_die lib => 'postal');

$ffi->type("record(Geo::Postal::Structs::Hashes)" => 'hash_options');
$ffi->type("record(Geo::Postal::Structs::Expansions)" => 'expansion_options');



$ffi->function(libpostal_setup => [], 'bool')->call;


$ffi->function(libpostal_setup_language_classifier  => [], 'bool')->call;

#TODO- move this to lazy load itself whenever we use the parser
$ffi->attach( 
  [ libpostal_setup_parser => 'postal_setup_parse' ] 
  => [], 'bool');

=method EXPANSION FUNCTIONS 

=method my $opts = expansion_defaults;

Returns a raw C struct suitable to be passed to the expansion
functions. Not intended to be used directly.

=cut
$ffi->attach(
  [ libpostal_get_default_options => 'expansion_defaults' ],
  [], 'expansion_options', );

=method destroy_expansions( char** $array_ptr, $array_len )

Walks through a C array of strings, freeing all members and then
finally the array itself. Not intended to be used directly.

=cut 

$ffi->attach(
  [ libpostal_expansion_array_destroy => 'destroy_expansions' ],
  [ opaque => 'size_t' ]);
  
sub process_char_pp {
  my ($inner, @args) = @_;
  my $ret_ptr = 
    $inner->(@args, \my $ret_len);
  return () unless $ret_len;
  my $ret = $ffi->cast( opaque => "string[$ret_len]", $ret_ptr);
  destroy_expansions($ret_ptr, $ret_len);
  return @$ret;
}

sub process_expansions {
  #third arg is the options
  $_[2] //= expansion_defaults();
  process_char_pp(@_);
}

=method my @expansion = expand_address( $address, $options? )

Returns a list of possible expansions for the $address. This may
give you some ridiculous results, like dr expanding out to doctor in
a place you'd expect it to say drive, but hey, it's fast and works.

The intended usage is to compare lists of expansions to one
another, and if there's any collision, then the two are
duplicates. 

This is in the middle of being superceded by L</near_dupes>. See
there for more options.

=cut

$ffi->attach(
  [ libpostal_expand_address => 'expand_address' ],
  [ 'string', 'expansion_options', 'size_t*' ], 
  'opaque', \&process_expansions );

=method my @expansion_roots = expand_address_roots( $address, $options? )

Similar to expand_address, but instead of expanding suspects, it
will just drop out items that could be ommited. That means instead
of expanding dr to both doctor and drive, it just drops it out
from the expansion. This is much more compact (b/c expand_address
can sometimes return over 500 expansions, because it returns every
relevant combination. I haven't gotten over 9000 expansions yet,
but it could still happen).

=cut

$ffi->attach(
  [ libpostal_expand_address_root => 'expand_address_root' ],
  [ 'string', 'expansion_options', 'size_t*' ], 
  'opaque', \&process_expansions );

=method NEAR DUPE HASHING FUNCTIONS

=method my $hashes_options = hash_defaults

Returns a C struct representing the default options for the generation of near dupe hashes. Not intended to be used directly.

=cut

$ffi->attach( 
  [ libpostal_get_near_dupe_hash_default_options => 'hash_defaults' ], 
  [ ], 'hash_options');

sub process_near_dupes {
  #fourth arg is the options
  $_[3] //= hash_defaults();
  process_char_pp(@_)
}

$ffi->attach( [ libpostal_near_dupe_hashes => 'near_dupes' ],
  [ 'size_t', 'string[]', 'string[]', 'hash_options', 'size_t*' ],
  'opaque', \&process_near_dupes
);

$ffi->attach(
  [ libpostal_near_dupe_hashes_languages => 'near_dupes_languages' ],
  [ size_t => 'string[]', 'string[]', 'hash_options',
    size_t => 'string[]', 'size_t*' ],
  'opaque', \&process_near_dupes
);

our @EXPORT = 
  qw/ expand_address_root expand_address expansion_defaults ffi
      hash_defaults near_dupes near_dupes_languages /;

'my work here is done'
