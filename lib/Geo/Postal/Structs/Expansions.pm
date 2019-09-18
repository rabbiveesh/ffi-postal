package Geo::Postal::Structs::Expansions;
use FFI::Platypus::Record;
# ABSTRACT: A class representing options for expand_address

=pod
This class is intended as an EXTREMELY raw glue layer between perl
and C. Take a look instead at L<Geo::Postal::Options::Expansions> for
a usable interface.
=cut


record_layout( qw/
  opaque  languages
  size_t  num_languages
  uint16  address_components

  bool latin_ascii
  bool transliterate
  bool strip_accents
  bool decompose
  bool lowercase
  bool trim_string
  bool drop_parentheticals
  bool replace_numeric_hyphens
  bool delete_numeric_hyphens
  bool split_alpha_from_numeric
  bool replace_word_hyphens
  bool delete_word_hyphens
  bool delete_final_periods
  bool delete_acronym_periods
  bool drop_english_possessives
  bool delete_apostrophes
  bool expand_numex
  bool roman_numerals
/);

=method
=head2 new

Creates an instance of the options for expand_address. Not
intended for public consumption.

=cut

1
