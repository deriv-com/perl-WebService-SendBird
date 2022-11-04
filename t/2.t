use strict;
use warnings;
use Test::More;
use JSON::PP;

is_deeply(\1,$JSON::PP::true, "scalar ref 1 is true or not ? ");
done_testing;

