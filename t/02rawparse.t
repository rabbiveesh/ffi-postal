use Test2::V0;
use Geo::Postal::FFI;

subtest 'address parsing' => sub {
  is parse_address('franklin university 99 your face ln cleveland ohio 44118 apt 12'), 
  { house => 'franklin university',
    house_number => 99,
    unit => 'apt 12',
    road => 'your face ln',
    city => 'cleveland',
    state => 'ohio',
    postcode => 44118,
  }, 'parses correctly'; 

  is parse_address('franklin university 99 your face ln cleveland ohio 44118 usa apt 12'), 
  { house => 'franklin university',
    house_number => 99,
    unit => 'apt 12',
    road => 'usa',
    city => 'cleveland',
    state => 'ohio',
    postcode => 44118,
  }, 'parses correctly'; 

  is parse_address('99 your face ln cleveland ohio 44118 usa'),
  { road => 'your face ln',
    city => 'cleveland',
    state => 'ohio',
    postcode => 44118,
    house_number => 99,
    country => 'usa'
  }, 'parses again correctly';

  is parse_address('99 your face ln cleveland'),
  { road => 'your face ln',
    house_number => 99,
    city => 'cleveland'
  }, 'and again';


};



done_testing;
