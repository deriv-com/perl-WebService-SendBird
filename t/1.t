use strict;
use warnings;

use Test::More;
#use Test::Fatal;
#use Test::MockObject;
#use Test::MockObject::Extends;

use WebService::SendBird;

use JSON::PP;
is_deeply(\1,$JSON::PP::true, "scalar ref 1 is true or not ? ");
done_testing;

