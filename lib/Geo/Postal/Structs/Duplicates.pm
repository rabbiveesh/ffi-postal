package Geo::Postal::Structs::Duplicates;
use FFI::Platypus::Record;
use Carp;


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
  size_t num_langs
  opaque langs
/);


1

__END__

=pod

=encoding UTF-8

=head1 NAME

Geo::Postal::Structs::Duplicates

=head1 VERSION

version 0.005

=head1 AUTHOR

Avishai Goldman <veesh@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2019-2020 by Avishai Goldman.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
