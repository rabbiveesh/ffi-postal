#!/usr/bin/env perl

use Mojolicious::Lite;

use lib 'lib';
use Geo::Postal::FFI;

app->hook(before_server_start => sub {
  load_parser;
});

app->config(
  hypnotoad => {
    pid_file => app->home->child('geo-postal-ffi.pid'),
    listen => [ 'http://localhost:9009' ]
  }
);

post '/parse' => sub {
  my $c = shift;
  my $string = $c->req->json('/string');
  $c->render(json => [ parse_address($string) ] );
};

group {
  under '/api/v1';
  post '/parseAddress' => sub {
    my $c = shift;
    my $text = $c->req->json('/text');
    $c->render(json => { parsedPairs => [ parse_address($text) ] } );
  };

  post '/expandAddress' => sub {
    my $c = shift;
    my $text = $c->req->json('/text');
    $c->render(json => { expansions => [ expand_address($text) ] } );
  };

  post '/expandAddressRoot' => sub {
    my $c = shift;
    my $text = $c->req->json('/text');
    $c->render(json => { expansions => [ expand_address_root($text) ] } );
  };
};
  

app->start;
