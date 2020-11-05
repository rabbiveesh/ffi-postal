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

  is $ex_def->langs, undef, 'empty langs is undef';

  subtest 'Language Options' => sub {
    isa_ok my $ref = $ex_def->languages(qw/ en ja /), 
      ['FFI::Platypus::Record::StringArray'],
      'the languages mutator returns the correct ref';
    is $ref->size, 2, 'array reports correct size';
    is $ref->element(0), 'en', 'returns right string';
    is $ref->element(1), 'ja', 'and second one too';

    is ffi->cast( opaque => 'string[2]', $ref->opaque), [ qw/ en ja / ],
      'the array correctly represents our strings on roundtrip';

    is [ expand_address_root $check_addr, $ex_def ], 
       [ "555 your face cleveland ohio 44118",
         "555 your face cleveland oh 44118",
         '555 your face dr cleveland hts oh 44118',
       ],
       'roots returns as expected when accounting for lang w/o expansion';
  };
  #TODO- add testing for when we do pass in options. Or maybe
  #we'll do that later when we have a saner interface for it?
};

subtest 'near dupe hashes' => sub {
  my $labels = [ qw/ house_number road city state postcode /];
  my $values = [ 555, 'your face ln', 'cleveland hts', 'oh', 44118  ];
  my $opts = hash_defaults;
  $opts->address_only_keys(1);

  is [ near_dupes $labels => $values, $opts ],
     [ 'act|your face lane|555|cleveland heights',
       'act|your face line|555|cleveland heights',
       'act|yourface|555|cleveland heights',
       'apc|your face lane|555|44118',
       'apc|your face line|555|44118',
       'apc|yourface|555|44118',
     ],
     'near dupes returns correctly!';

  is [ near_dupes_languages $labels => $values, $opts, [ 'ja' ] ],
     [ 'act|your face ln|555|cleveland hts',
       'apc|your face ln|555|44118',
     ],
     'near dupes w/ langs, no english returns correctly!';

  is [ near_dupes_languages $labels => $values, $opts, [ 'ja', 'en', ] ],
     [ 
       'act|your face ln|555|cleveland hts',
       'act|your face ln|555|cleveland heights',
       'act|your face lane|555|cleveland hts',
       'act|your face lane|555|cleveland heights',
       'act|your face line|555|cleveland hts',
       'act|your face line|555|cleveland heights',
       'act|yourface|555|cleveland hts',
       'act|yourface|555|cleveland heights',
       'apc|your face ln|555|44118',
       'apc|your face lane|555|44118',
       'apc|your face line|555|44118',
       'apc|yourface|555|44118',
     ],
     'near dupes w/ 2 langs returns correctly!';

  is [ near_dupes $labels, $values ], [], 'near_dupes uses defaults';
  is [ near_dupes_languages $labels, $values, ['en'] ], [], 
    'near_dupes_languages uses defaults';

  is [ near_dupes $labels,
       [ 'nine ninety nine', 'ave rd', 'aurora', 'california', '55223'],
      $opts ],
   [ 'act|avenue road|999|aurora',
     'act|avenue|999|aurora',
     'apc|avenue road|999|55223',
     'apc|avenue|999|55223',

   ],
   'gets another one';

};

subtest 'pairwise deduping' => sub {
 
  is is_street_duplicate('drury ln', 'drury lane'), 9, 
    'gets common abbreviation for street';
  is is_street_duplicate('drury', 'drury lane'), 3,
    'marks likely dupes';

  is is_postcode_duplicate('drury ln', 'drury lane'), 0,
    'streets are not postcodes';
  is is_postcode_duplicate( 'five five eight four three', 55843 ), 9,
    'alpha and numeric zip codes match';

  #TODO- test name house_number po_box unit floor and toponym

};

done_testing;
