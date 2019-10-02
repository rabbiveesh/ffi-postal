#!/usr/bin/env perl

use Mojolicious::Lite;

use lib 'lib';
use Geo::Postal::FFI;

load_parser;

post '/parse' => sub {
  my $c = shift;
  my $string = $c->param('address');
  $c->render(json => { parse_address($string) } );
};

post '/hashes' => sub {
  my $c = shift;
  my $hash = $c->req->json;
  my @labels = keys %$hash;
  my @values = map { $hash->{$_} } @labels;
  #TODO- add intelligent option parsing here
  $c->render(json => near_dupes(\@labels, \@keys) );
};



app->start;

