package Geo::Postal::Structs::Expansions;
use FFI::Platypus::Record;
use FFI::Platypus::Record::StringArray;
use Carp;
# ABSTRACT: Struct for expand_address options

our $VERSION = '0.003';



sub languages {
  my $self = shift;
  my $langs;
  if ( @_ > 1 ) {
    $langs = [ @_ ] if @_ > 1;
  } else {
    $langs = shift;
    unless ($langs) {
      $self->langs(undef);
      $self->num_langs(0);
      return ()
    }
    croak 'Arguments must either be a list or arrayref!' 
      unless ref $langs eq 'ARRAY';
  }
  my $strings = FFI::Platypus::Record::StringArray->new(@$langs);
  $self->langs($strings->opaque);
  $self->num_langs($strings->size);

  return $strings;
}

record_layout( qw/
  opaque  langs
  size_t  num_langs
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


1

__END__

=pod

=encoding UTF-8

=head1 NAME

Geo::Postal::Structs::Expansions - Struct for expand_address options

=head1 VERSION

version 0.003

=head1 METHODS

=head2 languages

  my $reference = $options->languages(@lang_codes)

This is a mutator which edits the langs and num_langs fields of
this record. You must keep the reference returned by this
function, or perl will destroy your c-land array.

=head2 
=head2 new

Creates an instance of the options for expand_address. Not
intended for public consumption.

=head1 AUTHOR

Avishai Goldman <veesh@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2019-2020 by Avishai Goldman.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
