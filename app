#!/usr/bin/env perl

use Mojolicious::Lite;

use lib 'lib';
use Geo::Postal::FFI qw/load_parser local_parse_address/;

load_parser;

app->config(
  hypnotoad => {
    pid_file => app->home->child('geo-postal-ffi.pid'),
    listen => [ 'http://localhost:9009' ]
  }
);

post '/parse' => sub {
  my $c = shift;
  my $string = $c->req->json->{string};
  $c->render(json => [ local_parse_address($string) ] );
};

app->start;
