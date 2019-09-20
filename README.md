# Geo::Postal::FFI

This is the Perl FFI bindings for libpostal. It's a work in
progress, and any feedback is appreciated. 

One of the things that I'm planning on doing is writing up
documentation with decent examples so as to clarify what exactly
this library can do. (This is something I haven't found yet,
so...)

The roadmap for this project is something like this:

1) get the low level bindings to the library, with arguments
passed in more or less as C would expect them, and return the
values as returned by C.

2) implement a higher level interface, where you can pass in
normal perl-y things like hashrefs, which will then be converted
into the requisite C structs and stuff.

3) wrap an object system around that so you can do cool stuff like 

```perl
my @unique_addresses = parse_address(@address_list)
                         ->near_dupes
                         ->reduce
                         ->dedupe;
```

where you parse a list of addresses and then get the hashes, and
then group them, and then dedupe the whole lot so you only get
fresh addresses.
