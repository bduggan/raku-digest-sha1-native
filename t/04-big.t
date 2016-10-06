use Digest::SHA1::Native;
use Test;

diag sha1-hex('x' x 10000);

ok 1;

done-testing;
