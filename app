#!/usr/bin/env perl

use Mojolicious::Lite;

use lib 'lib';
use Geo::Postal::FFI;

load_parser;

post '/parse' => sub {
  my $c = shift;
  my $string = $c->req->json->{string};
  $c->render(json => [ parse_address($string) ] );
};

app->start;

