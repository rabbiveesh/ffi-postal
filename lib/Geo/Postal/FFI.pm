use strict;
use warnings;
package Geo::Postal::FFI;
use v5.22;
use Exporter::Shiny;
use Try::Tiny;
# ABSTRACT: FFI bindings for libpostal, an address parsing and deduping library

our $VERSION = '0.004';

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
  state $ffi = FFI::Platypus->new( api => 1 );
}

my $ffi = ffi;

$ffi->lib(find_lib_or_die lib => 'postal');

# Type Definitions
$ffi->type("record(Geo::Postal::Structs::Hashes)" => 'hash_options');
$ffi->type("record(Geo::Postal::Structs::Expansions)" => 'expansion_options');
$ffi->type("record(Geo::Postal::Structs::Parser)" => 'parser_options');
$ffi->type("record(Geo::Postal::Structs::ParserResponse)" => 'parser_response');
$ffi->type("record(Geo::Postal::Structs::Duplicates)" => 'duplicate_options');


$ffi->function(libpostal_setup => [], 'bool')->call;


$ffi->function(libpostal_setup_language_classifier  => [], 'bool')->call;


=method EXPANSION FUNCTIONS 

=method expansion_defaults

    my $options = expansion_defaults;

Returns a raw C struct suitable to be passed to the expansion
functions. Not intended to be used directly.

=cut
$ffi->attach(
  [ libpostal_get_default_options => 'expansion_defaults' ],
  [], 'expansion_options', );

=method destroy_expansions

    destroy_expansions( char** $array_ptr, $array_len )

Walks through a C array of strings, freeing all members and then
finally the array itself. Not intended to be used directly.

=cut 

$ffi->attach(
  [ libpostal_expansion_array_destroy => 'destroy_expansions' ],
  [ opaque => 'size_t' ], 'void');
  

sub process_char_pp {
  my ($inner, @args) = @_;
  #call the function
  my $ret_ptr = 
    $inner->(@args, \my $ret_len);
  #nothing to do if there are no results
  return () unless $ret_len;
  #cast the char** into an arrayref
  my $ret = $ffi->cast( opaque => "string[$ret_len]", $ret_ptr);
  #clean up the C side of things
  destroy_expansions($ret_ptr, $ret_len);
  #send back the string[]
  return @$ret;
}

sub process_expansions {
  #third arg is the options, if not passed, then supply the
  #defaults
  $_[2] //= expansion_defaults();
  process_char_pp(@_);
}

=method expand_address

    my @expansion = expand_address( $address, $options? )

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

=method expand_address_root

    my @expansion_roots = expand_address_roots( $address, $options? )

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

=method ADDRESS PARSING FUNCTIONS

=method parser_defaults

Returns a C struct representing the default options for the
parsing an address. Not intended to be used directly.

=cut

$ffi->attach( [ libpostal_get_address_parser_default_options =>
    'parser_defaults' ], [], 'parser_options');

$ffi->attach( [ libpostal_address_parser_response_destroy =>
    'destroy_parsings' ], [ 'opaque' ], 'void');

=method parse_address

  my @labels_and_values = parse_address($address, $options?)

Returns the labels and values one next to the other, basically
perfect for being transformed into a hashref (as per
Geo::libpostal). I decided to keep that because sometimes you have
a malformed address, and then the parser will return multiple
values for the same label, and you may want to check for that to
mark the address off for manual inspection.

Encoding on input and output is taken care of for you. Please file a bug
immediately if you don't find that to work for you.

This function is the big memory hog of the library. As such, a Mojo app is
bundled together with this release that can be used to offload all the memory
to one process.  On the usage side, this is activated by setting the
GEO_POSTAL_FFI_SERVER env variable with a url that represents where your app is
running. The variable is checked at import time, and it will silently replace this function
with an equivalent one that calls the backend.

If for some reason you need to parse in this process specifically, then you can
request the local_parse_address function as a named import.

=cut

my $parser_loaded = 0;
$ffi->attach( [ libpostal_setup_parser => 'load_parser' ],
  [], 'bool', sub {
  my ($inner) = @_;
  $parser_loaded = $inner->() unless $parser_loaded;
});

use Encode::Simple;
$ffi->attach( [ libpostal_parse_address => 'parse_address' ],
  [ 'string', 'parser_options' ], 'opaque',
  sub {
    my ($inner, @args) = @_;
    #lazy load the parser
    load_parser();
    
    #let options be optional
    push @args, parser_defaults() if @args == 1;
    #get the pointer
    $args[0] = encode_utf8 $args[0];
    my $raw = $inner->(@args);
    #copy it to perl space
    my $ret = $ffi->cast( opaque => 'parser_response*', $raw);
    #extract the goodies
    my $len = $ret->num_components;
    my $labels = $ffi->cast( 'opaque', "string[$len]", $ret->labels);
    my $values = $ffi->cast( 'opaque', "string[$len]", $ret->components);
    #free it in c space
    destroy_parsings($raw);
    return map { decode_utf8 $_ } map { ($labels->[$_] => $values->[$_] ) } 0..$len-1;
  }
);


=method NEAR DUPE HASHING FUNCTIONS

=method hash_defaults

    my $hashes_options = hash_defaults

Returns a C struct representing the default options for the generation of near dupe hashes. Not intended to be used directly.

=cut

$ffi->attach( 
  [ libpostal_get_near_dupe_hash_default_options => 'hash_defaults' ], 
  [ ], 'hash_options');

=method near_dupes

    my @near_dupe_hashes = near_dupes \@labels, \@values, $options?

Returns hashes suitable for grouping suspiciously similar
addresses.  The format for the address is two arrayrefs, one of
labels and the other of corresponding values, as returned by
parse_address (or at least with the same labels).

If you pass undef or nothing as the third argument, the default
options will be used. This defaults to returning
name_and_address_keys, which means for a lot of addresses (unless
they have a 'house' label) you'll get back nothing. See the
options docs for more information.

Low level documentation for the options is available in 
L<Geo::Postal::Structs::Hashes>.

Language detection will be performed on the address in question,
and then expansions will include terms from all relevant
dictionaries.

=cut

$ffi->attach( [ libpostal_near_dupe_hashes => 'near_dupes' ],
  [ 'size_t', 'string[]', 'string[]', 'hash_options', 'size_t*' ],
  'opaque', 
  sub {
    my $inner = shift;
    unshift @_, scalar @{$_[0]};
    push @_, hash_defaults() unless $_[3];
    process_char_pp($inner, @_);
  }
);

=method near_dupes_languages

    my @hashes = near_dupes_languages \@labels, \@values, $options?, \@langs

Returns hashes suitable for grouping suspiciously similar
addresses.  The format for the address is two arrayrefs, one of
labels and the other of corresponding values, as returned by
parse_address (or at least with the same labels).

If you omit the third argument, then the default options
will be used.

Low level documentation for the options is available in 
L<Geo::Postal::Structs::Hashes>.

The hashes will only use terms from the languages provided in
\@langs.

=cut

$ffi->attach(
  [ libpostal_near_dupe_hashes_languages => 'near_dupes_languages' ],
  [ size_t => 'string[]', 'string[]', 'hash_options',
    size_t => 'string[]', 'size_t*' ],
  'opaque',
  sub {
    my $inner = shift;
    #put in length of keys/values
    unshift @_, scalar @{$_[0]};
    my $langs = pop;
    #put in default options if not supplied
    push @_, hash_defaults() unless $_[3];
    #put in length of language list
    push @_, 0 + @$langs, $langs;
    process_char_pp($inner, @_);
  }
);



=method PAIRWISE DEDUPING FUNCTIONS

=method duplicate_defaults

  my $duplicates_options = duplicate_defaults

Returns a C struct representing the default options for the
pairwise comparison of addresses. Not intended to be used directly.
=cut


$ffi->attach( [ libpostal_get_default_duplicate_options => 
    'duplicate_defaults' ], [], 'duplicate_options');

=method is_duplicate


=cut

$ffi->attach( [ libpostal_is_toponym_duplicate => 'is_toponym_duplicate' ],
  [ size_t => 'string[]', 'string[]',
    size_t => 'string[]', 'string[]',
    'duplicate_options' ], 'senum',
  sub {
    my ($inner, $labels1, $values1, $labels2, $values2, $opts) = @_;
    $opts //= duplicate_defaults();
    $inner->(0+ @$labels1, $labels1, $values1,
             0+ @$labels2, $labels2, $values2,
             $opts)
  }
);

my @duplicate_parts =
   qw/ name street house_number po_box unit floor/;

sub dupe_defaults {
  my ($inner, @args) = @_;
  push @args, duplicate_defaults() if @args == 2;
  $inner->(@args)
}

for (@duplicate_parts) {
  $ffi->attach( [ "libpostal_is_${_}_duplicate" => "is_${_}_duplicate" ],
    [ string => 'string', 'duplicate_options' ], 'senum', 
    \&dupe_defaults );
}

$ffi->attach( [ libpostal_is_postal_code_duplicate => 
    'is_postcode_duplicate' ], [ string => 'string', 'duplicate_options' ],
  'senum', \&dupe_defaults );

our @EXPORT = 
qw/ 
  ffi
  expansion_defaults expand_address_root expand_address
  hash_defaults near_dupes near_dupes_languages
  parser_defaults parse_address load_parser
  duplicate_defaults is_toponym_duplicate is_postcode_duplicate
  /;

push @EXPORT, "is_${_}_duplicate" for @duplicate_parts;

END { 
  my $ffi = ffi;
  $ffi->function(libpostal_teardown_parser => [], 'void')->call()
    if $parser_loaded;
  $ffi->function(libpostal_teardown_language_classifier => [], 'void')
    ->call();
  $ffi->function(libpostal_teardown => [], 'void')->call();
}

'my work here is done'
