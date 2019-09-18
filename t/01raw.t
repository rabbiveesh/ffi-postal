use Test2::V0;

use Geo::Postal::FFI;

subtest 'expansions' => sub {
  my $ex_def = expansion_defaults;
  my $check_addr =  '555 your face dr cleveland hts oh 44118';
  is [ expand_address $check_addr, $ex_def ],
     [ expand_address $check_addr ],
     'correctly uses default settings';

  is [ expand_address $check_addr ],
  [ "555 your face doctor cleveland heights ohio 44118",
    "555 your face doctor cleveland heights oh 44118",
    "555 your face drive cleveland heights ohio 44118",
    "555 your face drive cleveland heights oh 44118" ],
  'expands as it should';

  is [ expand_address_root $check_addr ], 
     [ "555 your face cleveland ohio 44118",
       "555 your face cleveland oh 44118" ],
     'roots returns as expected';


  #TODO- add testing for when we do pass in options. Or maybe
  #we'll do that later when we have a saner interface for it?
};

subtest 'near dupe hashes' => sub {
  my @labels = ( 5, [ qw/ house_number road city state postcode /] );
  my $opts = hash_defaults;
  $opts->address_only_keys(1);
  is [ near_dupes @labels => 
       [ 555, 'your face ln', 'cleveland hts', 'oh', 44118  ],
       $opts ],
     [ 'act|your face lane|555|cleveland heights',
       'act|your face line|555|cleveland heights',
       'act|yourface|555|cleveland heights' ],
     'near dupes returns correctly!';

  is [ near_dupes @labels,
       [ 'nine ninety nine', 'ave rd', 'aurora', 'california', '55223'],
      $opts ],
   [ 'act|avenue road|999|aurora',
     'act|avenue|999|aurora'],
   'gets another one';

};

done_testing;
