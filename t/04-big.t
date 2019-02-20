use Digest::SHA1::Native;
use Test;

is sha1-hex( ('z' x 10000) ),  '8ae70c86655f6edc2c32923a7d0b73aea813ed6d', 'long string';

my $blob = ('z' x 10000).encode('ascii');
my $orig = $blob.clone;
is sha1-hex($blob), '8ae70c86655f6edc2c32923a7d0b73aea813ed6d', 'long buffer';
is-deeply $blob, $orig, 'Calculating SHA-1 does not mangle the input buffer';

done-testing;
