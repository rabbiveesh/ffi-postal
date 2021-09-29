use Test2::V0;
use Geo::Postal::FFI qw/parse_address/;

subtest 'address parsing' => sub {
  is { parse_address('franklin university 99 your face ln cleveland ohio 44118 apt 12') },
  { house => 'franklin university',
    house_number => 99,
    unit => 'apt 12',
    road => 'your face ln',
    city => 'cleveland',
    state => 'ohio',
    postcode => 44118,
  }, 'parses correctly'; 

  is { parse_address('franklin university 99 your face ln cleveland ohio 44118 usa apt 12') }, 
  { house => 'franklin university',
    house_number => 99,
    unit => 'apt 12',
    road => 'usa',
    city => 'cleveland',
    state => 'ohio',
    postcode => 44118,
  }, 'parses correctly'; 

  is { parse_address('99 your face ln cleveland ohio 44118 usa') },
  { road => 'your face ln',
    city => 'cleveland',
    state => 'ohio',
    postcode => 44118,
    house_number => 99,
    country => 'usa'
  }, 'parses again correctly';

  is { parse_address('99 your face ln cleveland') },
  { road => 'your face ln',
    house_number => 99,
    city => 'cleveland'
  }, 'and again';

  is [ parse_address('franklin university 99 your face ln cleveland ohio 44118 usa apt 12') ],
  [
    house => 'franklin university',
    house_number => 99,
    road => 'your face ln',
    city => 'cleveland',
    state => 'ohio',
    postcode => 44118,
    road => 'usa',
    unit => 'apt 12'
  ], 'correctly borks on malformed address';
  
};

subtest 'parsing addresses with utf8' => sub {

  like { parse_address 'TÍPICO DOMINICANO 1390 SAINT NICHOLAS AVE' },
    { house => 'típico dominicano' },
    'did a utf8 right';

  like { parse_address '15321 Ârborio ln' },
    { road => 'ârborio ln' },
    'survived without dying on utf8 input';

  like { parse_address '14443 MARIÁ AVE' }, 
    { road => 'mariá ave' },
    'even when it used to die horribly';

};


done_testing;
